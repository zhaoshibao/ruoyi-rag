package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.searxng.SearXNGSearchResult;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.sse.SSEMsgType;
import com.ruoyi.sse.SSEServer;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.vo.QueryVo;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.SystemConstant;
import jakarta.annotation.Resource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.autoconfigure.vectorstore.qdrant.QdrantVectorStoreProperties;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.document.Document;
import org.springframework.ai.ollama.OllamaChatModel;
//import org.springframework.ai.vectorstore.RedisVectorStore;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

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
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;

    // 历史消息列表，用于存储聊天的历史记录
    private static List<Message> historyMessage = new ArrayList<>();

    // 历史消息列表的最大长度，用于限制历史记录的数量
    private static final int maxLen = 50;


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

        // 查询本地知识库
//        List<Document> results = ollamaQdrantVectorStore.similaritySearch(SearchRequest
//                .query(queryVo.getMsg())
//                .withFilterExpression(
//                        new FilterExpressionBuilder()
//                                .eq("projectId", queryVo.getProjectId()) // 查询当前项目的本地知识库
//                                .build())
//                .withTopK(SystemConstant.TOPK) // 取前10个
//                .withSimilarityThreshold(SystemConstant.SIMILARITY_THRESHOLD));

        String baseUrl = chatProject.getBaseUrl();
        String model = chatProject.getModel();
        String embeddingModel = chatProject.getEmbeddingModel();
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
        List<Document> documentList = ollamaQdrantVectorStore.similaritySearch(
                SearchRequest.builder().query(queryVo.getMsg())
                .filterExpression(
                        new FilterExpressionBuilder()
                                .eq("projectId", queryVo.getProjectId()) // 查询当前项目的本地知识库
                                .build())
                .topK(SystemConstant.TOPK) // 取前10个
                .similarityThreshold(SystemConstant.SIMILARITY_THRESHOLD).build()
        );

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
        //Flux<ChatResponse> responseFlux = this.ollamaChatModel.stream(new Prompt(msgList, OllamaOptions.create().withModel(model)));

        OllamaChatModel ollamaChatModel = ChatModelUtil.getOllamaChatModel(baseUrl,model);
        Flux<ChatResponse> responseFlux = ollamaChatModel.stream(new Prompt(msgList));
        return responseFlux.map(response -> response.getResult() != null
                && response.getResult().getOutput() != null
                && response.getResult().getOutput().getText() != null
                ? response.getResult().getOutput().getText() : "");
    }


    @Override
    public void chatStreamV2(ChatProject chatProject, QueryVo queryVo) throws Exception {
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

        List<Document> results = ollamaQdrantVectorStore.similaritySearch(
                SearchRequest.builder().query(queryVo.getMsg())
                        .filterExpression(
                                new FilterExpressionBuilder()
                                        .eq("projectId", queryVo.getProjectId()) // 查询当前项目的本地知识库
                                        .build())
                        .topK(SystemConstant.TOPK) // 取前10个
                        .similarityThreshold(SystemConstant.SIMILARITY_THRESHOLD).build()
        );

        // 把本地知识库的内容作为系统提示放入
        List<Message> msgList = results.stream().map(result ->
                new SystemMessage(result.getText())).collect(Collectors.toList());
        // 中英文切换
        msgList.add(new SystemMessage(LanguageEnum.getMsg(queryVo.getLanguage())));
        // 加入当前用户的提问
        msgList.add(new UserMessage(queryVo.getMsg()));

        // 提交到大模型获取最终结果

        OllamaChatModel ollamaChatModel = ChatModelUtil.getOllamaChatModel(baseUrl,model);
        Flux<ChatResponse> streamResponse = ollamaChatModel.stream(new Prompt(msgList));
        List<String> list = streamResponse.toStream().map(chatResponse -> {
            String content = chatResponse.getResult().getOutput().getText();

            SSEServer.sendMessage(queryVo.getUserId().toString(), content, SSEMsgType.ADD);

            log.info(content);
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
    public Boolean upload(ChatProject chatProject, String knowledgeId, String content) throws Exception {
        String projectId = chatProject.getProjectId();
        String baseUrl = chatProject.getBaseUrl();
        String embeddingModel = chatProject.getEmbeddingModel();
        Document document = new Document(knowledgeId, content, Map.of("projectId", projectId));
        QdrantVectorStore ollamaQdrantVectorStore = qdrantVectorStoreComponet.getOllamaQdrantVectorStore(baseUrl, embeddingModel);
        ollamaQdrantVectorStore.add(List.of(document));
        return true;
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


}
