package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatApp;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.MessageTypeEnum;
import com.ruoyi.enums.SystemConstant;
import com.ruoyi.pojo.Chat;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.service.IChatAppService;
import com.ruoyi.service.IChatKnowledgeService;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
import com.ruoyi.vo.ChatVo;
import com.ruoyi.vo.QueryVo;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.client.advisor.api.Advisor;
import org.springframework.ai.chat.client.advisor.vectorstore.QuestionAnswerAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * ollama
 */
@BeanType(AiTypeEnum.OLLAMA)
@Slf4j
public class OllamaOperator implements AiOperator {

    @Autowired
    private SimpleLoggerAdvisor simpleLoggerAdvisor;


    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;


    @Autowired
    private ChatMemory chatMemory;

    @Autowired
    private ToolCallbackProvider tools;

    @Autowired
    private IChatAppService chatAppService;
    @Autowired
    private IChatKnowledgeService chatKnowledgeService;

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
    public Flux<String> chatStream(ChatApp chatProject, QueryVo queryVo) throws Exception {
        Long chatId = queryVo.getChatId();
        if (chatId != null) {
            ChatVo chatVo = new ChatVo();
            chatVo.setAppId(chatProject.getAppId());
            chatVo.setUserId(queryVo.getUserId());
            chatVo.setTitle("新会话" + String.valueOf(Math.random()).substring(2, 7));
            Chat chat = new Chat();
            BeanUtils.copyProperties(chatVo, chat);
            chat.setCreateTime(new Date());
            chat.setChatId(IdUtil.getSnowflake().nextId());
            this.mongoTemplate.insert(chat, MongoUtil.getChatCollection(chatVo.getAppId()));
        }

        com.ruoyi.pojo.Message msg = new com.ruoyi.pojo.Message();
        msg.setChatId(chatId);
        msg.setType(MessageTypeEnum.USER.getType());
        msg.setContent(queryVo.getMsg());
        msg.setCreateTime(new Date());
        msg.setId(IdUtil.getSnowflake().nextId());
        this.mongoTemplate.insert(msg, MongoUtil.getMessageCollection(chatId));

        String baseUrl = chatProject.getBaseUrl();
        String model = chatProject.getModel();

        List<Message> msgList = new ArrayList<>();

        //是否开启联网搜索
        Boolean useWebSearch = chatProject.getIsWebSearch() == 1;
        if (useWebSearch) {
            String searchResult = searXNGService.searchV2(queryVo.getMsg());
            msgList.add(new UserMessage(searchResult));
        }
        // 系统提示词合并
        String sysMessage = LanguageEnum.getMsg(queryVo.getLanguage()) + chatProject.getSystemPrompt();
        msgList.add(new SystemMessage(sysMessage));


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
            List<String> knowledgeIds = chatAppService.selectKnowledgeIdListByAppId(queryVo.getAppId());
            if (!CollectionUtils.isEmpty(knowledgeIds)) {
                List<Advisor> advisorList = new ArrayList<>();
                for (String knowledgeId : knowledgeIds) {
                    ChatKnowledge chatKnowledge = chatKnowledgeService.selectChatKnowledgeByKnowledgeId(knowledgeId);
                    QdrantVectorStore dashScopeQdrantVectorStore = qdrantVectorStoreComponet.getVectorStore(chatKnowledge.getKnowledgeName());
                    QuestionAnswerAdvisor questionAnswerAdvisor = QuestionAnswerAdvisor
                            .builder(dashScopeQdrantVectorStore)
                            .searchRequest(
                                    SearchRequest.builder()
                                            .topK(SystemConstant.TOPK).build()
                            )
                            .build();
                    advisorList.add(questionAnswerAdvisor);
                }
                chatClientRequestSpec.advisors(advisorList);
            }

        }

        Flux<ChatResponse> responseFlux = chatClientRequestSpec.stream().chatResponse();
        return responseFlux.map(response -> response.getResult() != null
                && response.getResult().getOutput() != null
                && response.getResult().getOutput().getText() != null
                ? response.getResult().getOutput().getText() : "");
    }




}
