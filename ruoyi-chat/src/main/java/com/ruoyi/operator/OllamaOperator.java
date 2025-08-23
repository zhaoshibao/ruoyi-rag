package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.SystemConstant;
import com.ruoyi.searxng.SearXNGSearchResult;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.service.IChatFileSegmentService;
import com.ruoyi.service.async.VectorStoreAsyncService;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.vo.QueryVo;
import lombok.extern.slf4j.Slf4j;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.client.advisor.vectorstore.QuestionAnswerAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.document.Document;
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.ai.reader.JsonReader;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

/**
 * ollama
 */
@BeanType(AiTypeEnum.OLLAMA)
@Slf4j
public class OllamaOperator implements AiOperator {
//
//    @Autowired
//    private OllamaChatModel ollamaChatModel;

    // @Resource
    // private RedisVectorStore ollamaRedisVectorStore;
    // private QdrantVectorStore ollamaQdrantVectorStore;

    @Autowired
    private SimpleLoggerAdvisor simpleLoggerAdvisor;


    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;

//    @Autowired
//    private Neo4jService neo4jService;

    @Autowired
    private IChatFileSegmentService iChatFileSegmentService;

    @Autowired
    private VectorStoreAsyncService vectorStoreAsyncService;
    @Autowired
    private ChatMemory chatMemory;

    @Autowired
    private ToolCallbackProvider tools;

    @Override
    public ChatController.CompletionResponse complete(ChatController.CompletionRequest request) {
        return null;
    }

    @Override
    public List<ChatController.CompletionResponse> getCompletionOptions(ChatController.CompletionRequest request) {
        return null;
    }

    @Override
    public String chat(QueryVo queryVo) {
        return null;
    }

    @Override
    public Flux<String> chatStream(ChatProject chatProject, QueryVo queryVo) throws Exception {
        // 把问题记录到mongodb
        Long chatId = queryVo.getChatId();
        if (chatId != null) {
            com.ruoyi.pojo.Message msg = new com.ruoyi.pojo.Message();
            msg.setChatId(queryVo.getChatId());
            msg.setType(0);
            msg.setContent(queryVo.getMsg());
            msg.setCreateTime(new Date());
            msg.setId(IdUtil.getSnowflake().nextId());
            this.mongoTemplate.insert(msg, MongoUtil.getMessageCollection(queryVo.getChatId()));
        }

        String baseUrl = chatProject.getBaseUrl();
        String model = chatProject.getModel();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);

        List<Message> msgList = new ArrayList<>();
        // 暂时注释掉知识图谱功能
        // 添加 Neo4j 图数据库查询结果
//        String graphContext = neo4jService.getAllRelationshipsContext(queryVo.getProjectId(), knoledgeIds);
//        if (graphContext != null && !graphContext.isEmpty() && !graphContext.startsWith("未指定") && !graphContext.startsWith("指定的")) {
//            msgList.add(new SystemMessage("以下是从图数据库中查询到的相关信息：\n" + graphContext));
//        }

        //是否开启联网搜索
        Boolean useWebSearch = chatProject.getIsWebSearch() == 1;
        if (useWebSearch) {
            String searchResult = searXNGService.searchV2(queryVo.getMsg());
            msgList.add(new UserMessage(searchResult));
        }
        // 中英文切换
        msgList.add(new SystemMessage(LanguageEnum.getMsg(queryVo.getLanguage())));
        if (StringUtils.hasLength(chatProject.getSystemPrompt())) {
            msgList.add(new SystemMessage(chatProject.getSystemPrompt()));
        }


        // 加入当前用户的提问
        msgList.add(new UserMessage("用户问题：" + queryVo.getMsg()));

        // 提交到大模型获取最终结果
        OllamaChatModel ollamaChatModel = ChatModelUtil.getOllamaChatModel(baseUrl, model,tools.getToolCallbacks());
        ChatClient chatClient = ChatClient.builder(ollamaChatModel)
                .defaultToolCallbacks(tools)
                .defaultAdvisors(
                        MessageChatMemoryAdvisor.builder(chatMemory).build(),
                        simpleLoggerAdvisor
                )
                .build();


        ChatClient.ChatClientRequestSpec chatClientRequestSpec = chatClient
                .prompt(new Prompt(msgList))
                .advisors(memoryAdvisor -> memoryAdvisor
                        .param(ChatMemory.CONVERSATION_ID, chatId));

        //开启知识库搜索
        Boolean isKnowledgeSearch = chatProject.getIsKnowledgeSearch() == 1;
        if (isKnowledgeSearch) {
            QuestionAnswerAdvisor questionAnswerAdvisor = QuestionAnswerAdvisor
                    .builder(ollamaQdrantVectorStore)
                    .searchRequest(
                            SearchRequest.builder()
                                    .filterExpression(
                                            new FilterExpressionBuilder()
                                                    .eq("projectId", queryVo.getProjectId()) // 查询当前项目本地知识库
                                                    .build())
                                    .topK(SystemConstant.TOPK).build()
                    )
                    .build();
            chatClientRequestSpec.advisors(questionAnswerAdvisor);
        }

        Flux<ChatResponse> responseFlux = chatClientRequestSpec.stream().chatResponse();
        return responseFlux.map(response -> response.getResult() != null
                && response.getResult().getOutput() != null
                && response.getResult().getOutput().getText() != null
                ? response.getResult().getOutput().getText() : "");
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
        String baseUrl = chatProject.getBaseUrl();
        String embeddingModel = chatProject.getEmbeddingModel();
        Document document = new Document(chatKnowledge.getKnowledgeId(), content, Map.of("projectId", projectId));
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
        ollamaQdrantVectorStore.add(List.of(document));
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
                // 暂时注释掉知识图谱功能
                // 判断是否开启知识图谱
//                Integer isKnowledgeGraph = chatKnowledge.getIsKnowledgeGraph();
//                if (isKnowledgeGraph == 1) {
//                    neo4jService.processCsvFile(file,projectId,knowledgeId);
//                }

                String baseUrl = chatProject.getBaseUrl();
                String embeddingModel = chatProject.getEmbeddingModel();
                QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
                //异步执行
                this.vectorStoreAsyncService.addVectorStore(knowledgeId,ollamaQdrantVectorStore, docList);


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
//        return this.ollamaQdrantVectorStore.delete(List.of(docId)).get();
//    }

    @Override
    public void remove(ChatProject chatProject, String docId) throws Exception {
        String baseUrl = chatProject.getBaseUrl();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
        ollamaQdrantVectorStore.delete(List.of(docId));
    }

    @Override
    public void removeByknowledgeId(ChatProject chatProject, String knowledgeId) throws Exception {
        String baseUrl = chatProject.getBaseUrl();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
        ollamaQdrantVectorStore.delete(
                new FilterExpressionBuilder().eq("knowledgeId", knowledgeId).build()
        );
    }
}
