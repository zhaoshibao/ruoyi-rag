package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.searxng.SearXNGSearchParams;
import com.ruoyi.searxng.SearXNGSearchResult;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.service.IChatProjectService;
import com.ruoyi.sse.SSEMsgType;
import com.ruoyi.sse.SSEServer;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.vo.QueryVo;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.SystemConstant;
import lombok.extern.slf4j.Slf4j;
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
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
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

    // 历史消息列表，用于存储聊天的历史记录
    private static List<Message> historyMessage = new ArrayList<>();

    // 历史消息列表的最大长度，用于限制历史记录的数量
    private static final int maxLen = 50;


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
        if (!CollectionUtils.isEmpty(documentList)) {
            msgList = documentList.stream().map(result ->
                    new SystemMessage(result.getText())).collect(Collectors.toList());
        } else {
            msgList = new ArrayList<>();
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
    public Boolean upload( ChatProject chatProject, String knowledgeId, String content) throws Exception {
        String projectId = chatProject.getProjectId();
        Document document = new Document(knowledgeId, content, Map.of("projectId", projectId));
        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore openAiQdrantVectorStore = qdrantVectorStoreComponet.getOpenAiQdrantVectorStore(baseUrl, apiKey, embeddingModel);
        openAiQdrantVectorStore.add(List.of(document));
        return true;
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
}


