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
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.model.ChatResponse;
import org.springframework.ai.chat.model.Generation;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 *  OpenAI
 */
@BeanType(AiTypeEnum.OPENAI)
@Slf4j
public class OpenAiOperator implements AiOperator {

    @Autowired
    private OpenAiChatModel openAiChatModel;
    @Autowired
    private SimpleLoggerAdvisor simpleLoggerAdvisor;

    @Value("${spring.ai.openai.chat.options.temperature}")
    private double temperature;

    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;

    @Autowired
    private  ChatMemory chatMemory;

    @Autowired
    private ToolCallbackProvider tools;

    @Autowired
    private IChatAppService chatAppService;
    @Autowired
    private IChatKnowledgeService chatKnowledgeService;




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
    public Flux<String> chatStream(ChatApp chatProject, QueryVo queryVo) throws Exception {
        Long chatId = queryVo.getChatId();
        if (chatId == null) {
            ChatVo chatVo = new ChatVo();
            chatVo.setAppId(chatProject.getAppId());
            chatVo.setUserId(queryVo.getUserId());
            chatVo.setTitle("新会话" + String.valueOf(Math.random()).substring(2, 7));
            Chat chat = new Chat();
            BeanUtils.copyProperties(chatVo, chat);
            chat.setCreateTime(new Date());
            chatId = IdUtil.getSnowflake().nextId();
            chat.setChatId(chatId);
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
        String apiKey = chatProject.getApiKey();
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
        msgList.add(new UserMessage(queryVo.getMsg()));


        OpenAiChatModel openAiChatModel = ChatModelUtil.getOpenAiChatModel(baseUrl, apiKey, model,tools.getToolCallbacks());

        // 提交到大模型获取最终结果
        ChatClient chatClient = ChatClient.builder(openAiChatModel)
                .defaultToolCallbacks(tools)
                .build();

        Long finalChatId = chatId;
        // 为流式处理创建专用的Advisor列表
        List<org.springframework.ai.chat.client.advisor.api.Advisor> streamAdvisorList = new ArrayList<>();
        streamAdvisorList.add(MessageChatMemoryAdvisor.builder(chatMemory).conversationId(finalChatId.toString()).build());
        streamAdvisorList.add(simpleLoggerAdvisor);


        //开启知识库搜索
        Boolean isKnowledgeSearch = chatProject.getIsKnowledgeSearch() == 1;
        if (isKnowledgeSearch) {
            List<String> knowledgeIds = chatAppService.selectKnowledgeIdListByAppId(queryVo.getAppId());
            if (!CollectionUtils.isEmpty(knowledgeIds)) {
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
                    streamAdvisorList.add(questionAnswerAdvisor);
                }
            }

        }


        Flux<String> flux = chatClient.prompt(new Prompt(msgList)).advisors(streamAdvisorList).stream().content();

//        Flux<String> flux = responseFlux.map(response -> {
//                   String result =  response.getResult() != null
//                            && response.getResult().getOutput() != null
//                            && response.getResult().getOutput().getText() != null
//                            ? response.getResult().getOutput().getText() : "";
//                    return result;
//                 }
//        );
        // 创建字符串构建器用于累积流式响应内容
//        StringBuilder aiResponseBuilder = new StringBuilder();
//        // 添加完整的订阅处理器，包括错误处理和完成通知
//        flux.subscribe(
//                chunk -> {
//                    log.info("收到模型回复: {}", chunk);
//                    // 累积流式响应内容
//                    aiResponseBuilder.append(chunk);
//                },
//                error -> {
//                    log.error("流处理错误", error);
//                    // 发生错误时也保存已收到的内容
//                    saveAiResponse(finalChatId, aiResponseBuilder.toString());
//                },
//                () -> {
//                    log.info("流处理完成");
//                    //流处理完成后保存完整响应
//                    saveAiResponse(finalChatId, aiResponseBuilder.toString());
//                }
//        );
        return flux;
    }


    /**
     * 保存AI响应到MongoDB的工具方法
     */
    private void saveAiResponse(Long chatId, String content) {
        if (content == null || content.trim().isEmpty()) {
            log.warn("AI响应内容为空，不保存");
            return;
        }

        com.ruoyi.pojo.Message aiMsg = new com.ruoyi.pojo.Message();
        aiMsg.setId(IdUtil.getSnowflake().nextId());
        aiMsg.setChatId(chatId);
        aiMsg.setType(MessageTypeEnum.AI.getType());
        aiMsg.setCreateTime(new Date());
        aiMsg.setContent(content);
        this.mongoTemplate.insert(aiMsg, MongoUtil.getMessageCollection(chatId));
        log.info("AI响应已保存到MongoDB，chatId: {}", chatId);
    }

}


