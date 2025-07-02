package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.searxng.SearXNGSearchParams;
import com.ruoyi.searxng.SearXNGSearchResult;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.service.IChatFileSegmentService;
import com.ruoyi.service.IChatProjectService;
import com.ruoyi.service.Neo4jService;
import com.ruoyi.service.async.VectorStoreAsyncService;
import com.ruoyi.sse.SSEMsgType;
import com.ruoyi.sse.SSEServer;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.vo.QueryVo;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.SystemConstant;
import lombok.extern.slf4j.Slf4j;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;
import org.apache.poi.util.StringUtil;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.document.Document;
import org.springframework.ai.ollama.api.OllamaOptions;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.reader.ExtractedTextFormatter;
import org.springframework.ai.reader.JsonReader;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.reader.pdf.PagePdfDocumentReader;
import org.springframework.ai.reader.pdf.config.PdfDocumentReaderConfig;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.PipedReader;
import java.util.*;
import java.util.stream.Collectors;

@BeanType(AiTypeEnum.OPENAI)
@Slf4j
public class OpenAiOperator implements AiOperator {

    @Autowired
    private OpenAiChatModel openAiChatModel;

    @Value("${spring.ai.openai.chat.options.temperature}")
    private double temperature;

   // @Autowired
    // private RedisVectorStore openaiRedisVectorStore;
    //private QdrantVectorStore openAiQdrantVectorStore;

    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;

    @Autowired
    private Neo4jService neo4jService;

    // 历史消息列表，用于存储聊天的历史记录
    private static List<Message> historyMessage = new ArrayList<>();

    // 历史消息列表的最大长度，用于限制历史记录的数量
    private static final int maxLen = 50;


    @Autowired
    private IChatFileSegmentService iChatFileSegmentService;

    @Autowired
    private VectorStoreAsyncService vectorStoreAsyncService;


    /**
     * 智能补全
     * @param request
     * @return
     */
    @Override
    public ChatController.CompletionResponse complete(ChatController.CompletionRequest request) {
        // 1. 创建智能提示模板
        PromptTemplate promptTemplate = new PromptTemplate("""
            你是一个智能代码/文本补全助手，请根据下面的上下文生成补全建议。
            当前输入内容: 
            {context}
            
            要求:
            1. 只需返回文本补全部分，不要包含原文本
            2. 保持风格和格式一致
            3. 补全内容应是上下文自然延续
            """);

        // 2. 截取光标前的上下文（约1000字符）
        String context = request.text().substring(Math.max(0, request.cursorPosition() - 1000), request.cursorPosition());

        // 3. 构建提示并获取补全
        Prompt prompt = promptTemplate.create(Map.of("context", context));

        String completion = openAiChatModel.call(prompt).getResult().getOutput().getText();

        //String completion = chatClient.prompt(prompt).call().content();

        // 4. 构建完整文本响应
        String fullText = request.text().substring(0, request.cursorPosition()) + completion;

        return new ChatController.CompletionResponse(completion, fullText);
    }

    /**
     * 获取多个候选项
     * @param request
     * @return
     */
    @Override
    public List<ChatController.CompletionResponse> getCompletionOptions(ChatController.CompletionRequest request) {
        String context = request.text().substring(Math.max(0, request.cursorPosition() - 1000), request.cursorPosition());

        // 1. 配置多候选项
        OpenAiChatOptions options = OpenAiChatOptions.builder()
                //.model("text-davinci-003")
                .temperature(temperature)
                //.maxTokens(1000)
                .N(3) // 获取3个候选项
                .build();

        Prompt prompt = new Prompt(context, options);

        // 2. 获取多个候选项
        //ChatResponse response = chatClient.prompt(prompt).call().chatResponse();

        List<Generation> results = openAiChatModel.call(prompt).getResults();

        // 3. 处理每个候选项
        return results.stream().map(result -> {
            AssistantMessage msg = result.getOutput();
            String completion = msg.getText();
            String fullText = request.text().substring(0, request.cursorPosition()) + completion;
            return new ChatController.CompletionResponse(completion, fullText);
        }).toList();
    }

    @Override
    public String chat(QueryVo queryVo) {
        return null;
    }

    @Override
    public Flux<String> chatStream(ChatProject chatProject, QueryVo queryVo) throws Exception {
        // 把问题记录到mongodb
        com.ruoyi.pojo.Message msg = new com.ruoyi.pojo.Message();
        msg.setChatId(queryVo.getChatId());
        msg.setType(0);
        msg.setContent(queryVo.getMsg());
        msg.setCreateTime(new Date());
        msg.setId(IdUtil.getSnowflake().nextId());
        this.mongoTemplate.insert(msg, MongoUtil.getMessageCollection(queryVo.getChatId()));

        // 查询本地知识库
//        List<Document> results = openaiQdrantVectorStore.similaritySearch(SearchRequest
//                .query(queryVo.getMsg())
//                .withFilterExpression(
//                        new FilterExpressionBuilder()
//                                .eq("projectId", queryVo.getProjectId()) // 查询当前用户及管理员的本地知识库
//                                .build())
//                .withTopK(SystemConstant.TOPK)); // 取前10个
        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String model = chatProject.getModel();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
        List<Document> documentList = openAiQdrantVectorStore.similaritySearch(
                SearchRequest.builder().query(queryVo.getMsg())
                        .filterExpression(
                                new FilterExpressionBuilder()
                                        .eq("projectId", queryVo.getProjectId()) // 查询当前用户及管理员的本地知识库
                                        .build())
                        .topK(SystemConstant.TOPK).build()); // 取前10个

        List<Message> msgList;
        // 把本地知识库的内容作为系统提示放入
        List<String> knoledgeIds = new ArrayList<>();
        if (!CollectionUtils.isEmpty(documentList)) {
            msgList = documentList.stream().map(result -> {
                        Object o = result.getMetadata().get("knowledgeId");
                        if (o != null) {
                            knoledgeIds.add(o.toString());
                        }
                        return new SystemMessage(result.getText());
            }
            ).collect(Collectors.toList());
        } else {
            msgList = new ArrayList<>();
        }

        // 添加 Neo4j 图数据库查询结果
        String graphContext = neo4jService.getAllRelationshipsContext(queryVo.getProjectId(), knoledgeIds);
        if (graphContext != null && !graphContext.isEmpty() && !graphContext.startsWith("未指定") && !graphContext.startsWith("指定的")) {
            msgList.add(new SystemMessage("以下是从图数据库中查询到的相关信息：\n" + graphContext));
        }
        //是否开启联网搜索
        Boolean useWebSearch = queryVo.getUseWebSearch();

        if (useWebSearch) {
            SearXNGSearchResult search = searXNGService.search(queryVo.getMsg());
            List<SearXNGSearchResult.Result> searchResultList = search.getResults();
            if (!CollectionUtils.isEmpty(searchResultList)) {
                searchResultList.stream().forEach(result -> {
                    msgList.add(new SystemMessage(result.getTitle()));
                    msgList.add(new SystemMessage(result.getContent()));
                });
            }

        }
        // 中英文切换
        msgList.add(new SystemMessage(LanguageEnum.getMsg(queryVo.getLanguage())));
        msgList.add(new SystemMessage(chatProject.getSystemPrompt()));


        historyMessage.add(new UserMessage(queryVo.getMsg()));
        if (historyMessage.size() > maxLen) {
            historyMessage.remove(0);
        }
        msgList.addAll(historyMessage);
        // 加入当前用户的提问
        msgList.add(new UserMessage(queryVo.getMsg()));



        // 提交到大模型获取最终结果
//        Flux<ChatResponse> responseFlux = this.openAiChatModel.stream(
//                new Prompt(msgList, OpenAiChatOptions.builder().model(chatProject.getModel()).build()));

      OpenAiChatModel openAiChatModel = ChatModelUtil.getOpenAiChatModel(baseUrl, apiKey, model);
        Flux<ChatResponse> responseFlux = openAiChatModel.stream(new Prompt(msgList, OpenAiChatOptions.builder().model(model).build()));
        Flux<String> flux = responseFlux.map(response -> response.getResult() != null
                && response.getResult().getOutput() != null
                && response.getResult().getOutput().getText() != null
                ? response.getResult().getOutput().getText() : "");

        // flux.collectList().subscribe(list -> {\
        //     此处获取的信息和最终返回的信息 是两个结果
        //     System.out.println(StringUtils.join(list, ""));
        // });
        return flux;
    }


    @Override
    public void chatStreamV2(ChatProject chatProject, QueryVo queryVo) throws Exception {
        // 把问题记录到mongodb
        com.ruoyi.pojo.Message msg = new com.ruoyi.pojo.Message();
        msg.setChatId(queryVo.getChatId());
        msg.setType(0);
        msg.setContent(queryVo.getMsg());
        msg.setCreateTime(new Date());
        msg.setId(IdUtil.getSnowflake().nextId());
        this.mongoTemplate.insert(msg, MongoUtil.getMessageCollection(queryVo.getChatId()));

        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String model = chatProject.getModel();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
        // 查询本地知识库
        List<Document> results = openAiQdrantVectorStore.similaritySearch(
                SearchRequest.builder().query(queryVo.getMsg())
                        .filterExpression(
                                new FilterExpressionBuilder()
                                        .eq("projectId", queryVo.getProjectId()) // 查询当前用户及管理员的本地知识库
                                        .build())
                        .topK(SystemConstant.TOPK).build()); // 取前10个

        // 把本地知识库的内容作为系统提示放入
        List<Message> msgList = results.stream().map(result ->
                new SystemMessage(result.getText())).collect(Collectors.toList());
        // 中英文切换
        msgList.add(new SystemMessage(LanguageEnum.getMsg(queryVo.getLanguage())));
        // 加入当前用户的提问
        msgList.add(new UserMessage(queryVo.getMsg()));

        // 提交到大模型获取最终结果
        OpenAiChatModel openAiChatModel = ChatModelUtil.getOpenAiChatModel(baseUrl, apiKey, model);
        Flux<ChatResponse> streamResponse = openAiChatModel.stream(new Prompt(msgList));
        List<String> list = streamResponse.toStream().map(chatResponse -> {
            String content = chatResponse.getResult().getOutput().getText();
            log.info(content);
            SSEServer.sendMessage(queryVo.getUserId().toString(), content, SSEMsgType.ADD);


            return content;
        }).collect(Collectors.toList());
    }

    @Override
    public String imageUrl(QueryVo queryVo) {
        return null;
    }

    @Override
    public String imageBase64Json(QueryVo queryVo) {
        return null;
    }

    @Override
    public String textToAudio(QueryVo queryVo) {
        return null;
    }

    @Override
    public Boolean upload(ChatProject chatProject, ChatKnowledge chatKnowledge, String content) throws Exception {
        String projectId = chatProject.getProjectId();
        Document document = new Document(chatKnowledge.getKnowledgeId(), content, Map.of("projectId", projectId));
        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
        openAiQdrantVectorStore.add(List.of(document));
        return true;
    }

    @Override
    public Boolean upload(ChatProject chatProject, ChatKnowledge chatKnowledge, MultipartFile file) throws Exception {
        String filename = file.getOriginalFilename();
        String fileSuffix  = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
        List<Document> documentList = new ArrayList<>();
         switch (fileSuffix) {
            case "json":
                JsonReader jsonReader = new JsonReader(file.getResource());
                documentList = jsonReader.get();
                break;
            case "txt":
            case "md":
            case "csv":
                TextReader textReader = new TextReader(file.getResource());
                List<Document> documents = textReader.get();
                documentList = new TokenTextSplitter().apply(documents);
                break;
             case "pdf":
                 //`PagePdfDocumentReader`使用Apache PdfBox库解析PDF文档
//                PagePdfDocumentReader pdfReader = new PagePdfDocumentReader(file.getResource(),
//                        PdfDocumentReaderConfig.builder()
//                                .withPageTopMargin(0)
//                                .withPageExtractedTextFormatter(ExtractedTextFormatter.builder()
//                                        .withNumberOfTopTextLinesToDelete(0)
//                                        .build())
//                                .withPagesPerDocument(1)
//                                .build());
//
//                 documentList =  pdfReader.read();
                 documentList = this.readPdfPages(file,chatProject);


                 //pdf增强解析（使用 Tesseract 实现 PDF 转图片并进行 OCR 识别文本 ）
//                 List<Document> pdfDocList = this.readPagesWithOcr(file);
//                 documentList.addAll(pdfDocList);


                 break;
             //`TikaDocumentReader`使用Apache Tika从各种文档格式中提取文本，如PDF、DOC/DOCX、PPT/PPTX和HTML。
             // 有关支持的格式的完整列表，请参阅https://tika.apache.org/3.1.0/formats.html[Tika文档]。
             default:
                 TikaDocumentReader tikaDocumentReader = new TikaDocumentReader(file.getResource());
                 documentList =  tikaDocumentReader.read();
                    break;

         }
        String projectId = chatProject.getProjectId();
        String knowledgeId = chatKnowledge.getKnowledgeId();
        List<Document> docList = new ArrayList<>();
        if (!CollectionUtils.isEmpty(documentList)) {

            for (Document document : documentList) {
                String docId = UUID.randomUUID().toString();
                String text = document.getText();
                //去除text 中的空白符
                text = text.replaceAll("\\s+", "");
                if (StringUtils.hasLength(text) ) {
                    Document doc = new Document(docId,text, Map.of("projectId", projectId, "knowledgeId", knowledgeId));
                    docList.add(doc);
                }
            }
            documentList = docList;

            //Document document = new Document(knowledgeId, content, Map.of("projectId", projectId));
            if (!CollectionUtils.isEmpty(documentList)) {


                List<ChatFileSegment> chatFileSegmentList = documentList.stream().map(document -> {
                    ChatFileSegment chatFileSegment = new ChatFileSegment();
                    chatFileSegment.setSegmentId(document.getId());
                    chatFileSegment.setKnowledgeId(knowledgeId);
                    chatFileSegment.setFileName(filename);
                    chatFileSegment.setContent(document.getText());
                    return chatFileSegment;
                }).collect(Collectors.toList());
                for (ChatFileSegment chatFileSegment : chatFileSegmentList) {
                    chatFileSegment.setCreateTime(new Date());
                    iChatFileSegmentService.insertChatFileSegment(chatFileSegment);
                }
                //判断是否开启知识图谱
                Integer isKnowledgeGraph = chatKnowledge.getIsKnowledgeGraph();
                if (isKnowledgeGraph == 1) {
                    neo4jService.processCsvFile(file,projectId,knowledgeId);
                }

                String baseUrl = chatProject.getBaseUrl();
                String apiKey = chatProject.getApiKey();
                String embeddingModel = chatProject.getEmbeddingModel();
                QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
                //openAiQdrantVectorStore.add(documentList);
                //异步执行
                this.vectorStoreAsyncService.addVectorStore(knowledgeId,openAiQdrantVectorStore, docList);


            }

        }
        return true;
    }

    /**
     * 读取PDF每页内容（含乱码处理）
     * @param file
     * @return 每页内容的列表
     */
    public List<Document> readPdfPages(MultipartFile file,ChatProject chatProject) throws Exception {
        // 尝试标准文本提取
        byte[] pdfData = file.getBytes();
        List<Document> documentList = tryStandardExtraction(pdfData);

        // 如果提取失败（通常是乱码文档）
        //if (documentList == null || needsOcrFallback(documentList)    ) {
        if (documentList == null) {
            log.info("==============检测到文本提取异常，启用OCR回退方案==================");
            //判断pdf增强解析是否启用，如果启用则执行ocr解析
            if (chatProject.getPdfAnalysis().equals(0)) {
                return null;
            }
            return readPagesWithOcr(file);
        } else {
            //判断pdf增强解析是否启用，如果启用则执行ocr解析
            if (chatProject.getPdfAnalysis().equals(0)) {
                return documentList;
            }
            List<Document> docListWithOcr = readPagesWithOcr(file);
            documentList.addAll(docListWithOcr);
        }

        return documentList;
    }

    // 尝试标准文本提取
    private List<Document> tryStandardExtraction(byte[] pdfData) {
        List<Document> results = new ArrayList<>();

        try (PDDocument document = Loader.loadPDF(pdfData)) {
            PDFTextStripper stripper = new PDFTextStripper();

            for (int i = 1; i <= document.getNumberOfPages(); i++) {
                stripper.setStartPage(i);
                stripper.setEndPage(i);
                String text = stripper.getText(document);
                if (StringUtils.hasLength(text)) {
                    results.add(new Document(text));
                }

            }
            return results;
        } catch (Exception e) {
            log.error("==============标准提取失败: " + e.getMessage() + "==================");
            return null;
        }
    }




    /**
     * OCR回退方案
     * @param pdfFile
     * @return
     * @throws IOException
     * @throws TesseractException
     * todo 后续优化：多线程pdf页面处理
     */
    public List<Document> readPagesWithOcr(MultipartFile pdfFile) throws IOException, TesseractException {
        // 临时目录准备
        File tempDir = new File(System.getProperty("java.io.tmpdir"), "pdf_images");
        if (!tempDir.exists()) {
            tempDir.mkdirs();
        }

        List<Document> ocrResults = new ArrayList<>();

        try (PDDocument document = Loader.loadPDF(pdfFile.getBytes())) {
            PDFRenderer renderer = new PDFRenderer(document);

            // 设置DPI提高OCR精度
            int dpi = 300;

            Tesseract tesseract = new Tesseract();
            // 设置语言包（需事先安装）
           /// tesseract.setLanguage("eng");
            tesseract.setLanguage("chi_sim");
            // 如需要指定tessdata路径
            // tesseract.setDatapath("/path/to/tessdata");

            for (int page = 0; page < document.getNumberOfPages(); page++) {
                // 渲染PDF页为BufferedImage
                BufferedImage image = renderer.renderImageWithDPI(page, dpi);

                // 生成临时图像文件
                File imgFile = new File(tempDir, "page_" + page + ".png");
                // 最佳实践：使用 ImageIO 保存图像
                ImageIO.write(image, "png", imgFile);

                // 执行OCR
                String result = tesseract.doOCR(imgFile);
                if (StringUtils.hasLength(result)) {
                    ocrResults.add(new Document(result));
                }

                // 删除临时图像文件
                imgFile.delete();
            }
        }

        // 删除临时目录
        tempDir.delete();
        return ocrResults;
    }

    //    @Override
//    public Boolean remove(String docId) {
//        return this.openaiQdrantVectorStore.delete(List.of(docId)).get();
//    }
    @Override
    public void remove(ChatProject chatProject,String docId) throws Exception {
        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
        openAiQdrantVectorStore.delete(List.of(docId));

    }

    @Override
    public void removeByknowledgeId(ChatProject chatProject, String knowledgeId) throws Exception {
        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl,apiKey,embeddingModel);
        //异步执行
        vectorStoreAsyncService.removeByknowledgeId(openAiQdrantVectorStore,knowledgeId);
//        ollamaQdrantVectorStore.delete(
//                new FilterExpressionBuilder().eq("knowledgeId", knowledgeId).build()
//        );
    }

}


