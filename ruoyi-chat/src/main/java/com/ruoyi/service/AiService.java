package com.ruoyi.service;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatFile;
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.pojo.ChatList;
import com.ruoyi.pojo.Message;
import com.ruoyi.service.async.VectorStoreAsyncService;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.pojo.Chat;
import com.ruoyi.vo.ChatVo;
import com.ruoyi.vo.MessageVo;
import com.ruoyi.vo.QueryVo;
import com.ruoyi.operator.AiOperator;
import com.ruoyi.domain.ChatApp;
import com.mongodb.client.result.UpdateResult;
import lombok.extern.slf4j.Slf4j;
import net.sourceforge.tess4j.Tesseract;
import net.sourceforge.tess4j.TesseractException;
import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.text.PDFTextStripper;
import org.springframework.ai.document.Document;
import org.springframework.ai.reader.JsonReader;
import org.springframework.ai.reader.TextReader;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.transformer.splitter.TokenTextSplitter;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.data.domain.Sort;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

@Component
@Slf4j
public class AiService implements ApplicationContextAware {

    // 策略模式 的 bean容器
    private final Map<String, AiOperator> MAP = new ConcurrentHashMap<>();

    @Autowired
    private IChatAppService chatAppService;

    @Autowired
    private IChatKnowledgeService chatKnowledgeService;

    @Autowired
    private IChatFileService chatFileService;

    @Autowired
    private IChatFileSegmentService fileSegmentService;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private VectorStoreAsyncService vectorStoreAsyncService;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        Map<String, Object> beanMap = applicationContext.getBeansWithAnnotation(BeanType.class);
        if (CollectionUtils.isEmpty(beanMap)) {
            return;
        }
        // 遍历放入Map集合
        beanMap.values().forEach(bean -> {
            BeanType beanType = bean.getClass().getAnnotation(BeanType.class);
            String model = beanType.value().getType();
            MAP.put(model, (AiOperator) bean);
        });
    }

    private AiOperator getAiOperator(String type) {
        return MAP.get(type);
    }

    public ChatController.CompletionResponse complete(ChatController.CompletionRequest request) throws Exception {
        return this.getAiOperator("openai").complete(request);
    }
    public List<ChatController.CompletionResponse> getCompletionOptions(ChatController.CompletionRequest request) throws Exception {
        return this.getAiOperator("openai").getCompletionOptions(request);
    }


    public Flux<String> chatStream(QueryVo queryVo) throws Exception {
        // 根据项目id查询项目，获取类型 及 具体模型
        ChatApp chatApp = this.chatAppService.selectChatAppByAppId(queryVo.getAppId());
        return this.getAiOperator(chatApp.getType()).chatStream(chatApp, queryVo);
    }

    @Transactional("transactionManager")
    public String upload(ChatFile chatFile, MultipartFile file) throws Exception {

        // 获取文件名
        String filename = file.getOriginalFilename();
        //获取文件格式
        String fileFormat = filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
        //获取文件大小
        long fileSize = file.getSize();

        String  fileId = UUID.randomUUID().toString();
        chatFile.setFileId(fileId);
        chatFile.setFileName(filename);
        chatFile.setFileFormat(fileFormat);
        chatFile.setFileSize(fileSize);
        chatFileService.insertChatFile(chatFile);
        String knowledgeId = chatFile.getKnowledgeId();
        ChatKnowledge chatKnowledge = chatKnowledgeService.selectChatKnowledgeByKnowledgeId(knowledgeId);
        String knowledgeName = chatKnowledge.getKnowledgeName();


        // 上传到向量数据库
        List<Document> documentList = new ArrayList<>();
        switch (fileFormat) {
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
                documentList = this.readPdfPages(file,chatFile);


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
        List<Document> docList = new ArrayList<>();
        if (!CollectionUtils.isEmpty(documentList)) {

            for (Document document : documentList) {
                String docId = UUID.randomUUID().toString();
                String text = document.getText();
                //去除text 中的空白符
                text = text.replaceAll("\\s+", "");
                if (StringUtils.hasLength(text) ) {
                    Document doc = new Document(docId,text, Map.of("fileId", fileId, "knowledgeId", knowledgeId));
                    docList.add(doc);
                }
            }
            documentList = docList;

            //Document document = new Document(knowledgeId, content, Map.of("projectId", projectId));
            if (!CollectionUtils.isEmpty(documentList)) {


                List<ChatFileSegment> chatFileSegmentList = documentList.stream().map(document -> {
                    ChatFileSegment chatFileSegment = new ChatFileSegment();
                    chatFileSegment.setSegmentId(document.getId());
                    chatFileSegment.setFileId(fileId);
                    chatFileSegment.setFileName(filename);
                    chatFileSegment.setContent(document.getText());
                    return chatFileSegment;
                }).collect(Collectors.toList());
                for (ChatFileSegment chatFileSegment : chatFileSegmentList) {
                    chatFileSegment.setCreateTime(new Date());
                    fileSegmentService.insertChatFileSegment(chatFileSegment);
                }
                // 暂时注释掉知识图谱功能
                // 判断是否开启知识图谱
//                Integer isKnowledgeGraph = chatKnowledge.getIsKnowledgeGraph();
//                if (isKnowledgeGraph == 1) {
//                    neo4jService.processCsvFile(file,projectId,knowledgeId);
//                }

                QdrantVectorStore dashScopeQdrantVectorStore = qdrantVectorStoreComponet.getVectorStore(knowledgeName);
                //异步执行
                this.vectorStoreAsyncService.addVectorStore(fileId,dashScopeQdrantVectorStore, docList);


            } else {
                //异步执行
                this.vectorStoreAsyncService.addVectorStore(fileId,null, null);
            }

        } else {
            //异步执行
            this.vectorStoreAsyncService.addVectorStore(knowledgeId,null, null);
        }
        return fileId;
    }

    /**
     * 读取PDF每页内容（含乱码处理）
     * @param file
     * @return 每页内容的列表
     */
    public List<Document> readPdfPages(MultipartFile file,ChatFile chatFile) throws Exception {
        // 尝试标准文本提取
        byte[] pdfData = file.getBytes();
        List<Document> documentList = tryStandardExtraction(pdfData);

        // 如果提取失败（通常是乱码文档）
        //if (documentList == null || needsOcrFallback(documentList)    ) {
        if (documentList == null) {
            log.info("==============检测到文本提取异常，启用OCR回退方案==================");
            //判断pdf增强解析是否启用，如果启用则执行ocr解析
            if (chatFile.getIsPdfAnalysis().equals(0)) {
                return null;
            }
            return readPagesWithOcr(file);
        } else {
            //判断pdf增强解析是否启用，如果启用则执行ocr解析
            if (chatFile.getIsPdfAnalysis().equals(0)) {
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

    @Transactional("transactionManager")
    public Boolean remove(String knowledgeId,String  fileId) throws Exception {
        // 删除文件
        this.chatFileService.deleteChatFileByFileId(fileId);
        //删除文件分片
        this.fileSegmentService.deleteChatFileSegmentByFileId(fileId);
        // 删除redis向量数据库中对应的文档
        QdrantVectorStore dashScopeQdrantVectorStore = qdrantVectorStoreComponet.getVectorStore(knowledgeId);
        //异步执行
        vectorStoreAsyncService.removeByFileId(dashScopeQdrantVectorStore,fileId);
        return true;
    }



    public String createChat(ChatVo chatVo) {
        Chat chat = new Chat();
        BeanUtils.copyProperties(chatVo, chat);
        chat.setCreateTime(new Date());
        Long chatId = IdUtil.getSnowflake().nextId();
        chat.setChatId(chatId);
        this.mongoTemplate.insert(chat, MongoUtil.getChatCollection(chatVo.getAppId()));
        return chatId.toString();
    }

    public AjaxResult listChat(String appId, Long userId) {
        List<ChatList> result = new ArrayList<>();
        List<Chat> chatList = this.mongoTemplate.find(
                Query.query(Criteria.where("userId").is(userId)).with(Sort.by(Sort.Order.desc("createTime"))),
                Chat.class,
                MongoUtil.getChatCollection(appId));
        if (CollectionUtils.isEmpty(chatList)) {
            return AjaxResult.success(result);
        }
        result = chatList.stream().map(chat -> {
            ChatList chatList1 = new ChatList();
            BeanUtils.copyProperties(chat,chatList1);
            chatList1.setChatId(chat.getChatId().toString());
            return chatList1;
        }).collect(Collectors.toList());

        return AjaxResult.success(result);

    }

    public void updateChat(ChatVo chatVo) {
        if (chatVo == null || chatVo.getAppId() == null) {
            throw new RuntimeException("appId不能为空");
        }
        UpdateResult result = this.mongoTemplate.updateFirst(
                Query.query(Criteria.where("_id").is(chatVo.getChatId())),
                Update.update("title", chatVo.getTitle()),
                MongoUtil.getChatCollection(chatVo.getAppId())
        );
    }

    public void deleteChat(String appId, Long chatId) {
        if (appId == null || chatId == null) {
            throw new RuntimeException("appId或chatId不能为空");
        }
        this.mongoTemplate.remove(Query.query(Criteria.where("_id").is(chatId)), MongoUtil.getChatCollection(appId));
    }

    public AjaxResult listMsg(Long chatId) {
        if (chatId == null) {
            throw new RuntimeException("chatId不能为空");
        }
        List<Message> messageList = this.mongoTemplate.find(
                Query.query(Criteria.where("chatId").is(chatId)).with(Sort.by(Sort.Order.asc("createTime"))),
                Message.class,
                MongoUtil.getMessageCollection(chatId)
        );
        return AjaxResult.success(messageList);
    }

    public void saveMsg(MessageVo messageVo) {
        Message message = new Message();
        BeanUtils.copyProperties(messageVo, message);
        message.setCreateTime(new Date());
        message.setType(1);
        message.setId(IdUtil.getSnowflake().nextId());
        this.mongoTemplate.insert(message, MongoUtil.getMessageCollection(messageVo.getChatId()));
    }




}
