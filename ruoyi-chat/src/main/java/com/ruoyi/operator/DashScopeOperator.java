package com.ruoyi.operator;

import cn.hutool.core.util.IdUtil;
import com.alibaba.cloud.ai.dashscope.chat.DashScopeChatModel;
import com.alibaba.cloud.ai.dashscope.chat.DashScopeChatOptions;
import com.ruoyi.annotation.BeanType;
import com.ruoyi.component.QdrantVectorStoreComponet;
import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatApp;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.enums.AiTypeEnum;
import com.ruoyi.enums.LanguageEnum;
import com.ruoyi.enums.SystemConstant;
import com.ruoyi.searxng.SearXNGService;
import com.ruoyi.service.IChatAppService;
import com.ruoyi.service.IChatKnowledgeService;
import com.ruoyi.utils.ChatModelUtil;
import com.ruoyi.utils.MongoUtil;
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
import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.vectorstore.SearchRequest;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.util.CollectionUtils;
import reactor.core.publisher.Flux;

import java.util.*;

/**
 * 阿里百炼
 */
@BeanType(AiTypeEnum.DASHSCOPE)
@Slf4j
public class DashScopeOperator implements AiOperator {

    @Autowired
    private DashScopeChatModel dashScopeChatModel;

    @Autowired
    private SimpleLoggerAdvisor simpleLoggerAdvisor;

    @Value("${spring.ai.zhipuai.chat.options.temperature}")
    private double temperature;


    @Autowired
    private QdrantVectorStoreComponet qdrantVectorStoreComponet;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private SearXNGService searXNGService;

//    @Autowired
//    private Neo4jService neo4jService;



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

        String completion = dashScopeChatModel.call(prompt).getResult().getOutput().getText();

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
        DashScopeChatOptions options = DashScopeChatOptions.builder()
                //.model("text-davinci-003")
                .withTemperature(temperature)
                //.maxTokens(1000)
                .withTopK(3) // 获取3个候选项
                .build();

        Prompt prompt = new Prompt(context, options);

        // 2. 获取多个候选项
        //ChatResponse response = chatClient.prompt(prompt).call().chatResponse();

        List<Generation> results = dashScopeChatModel.call(prompt).getResults();

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
        // 把问题记录到mongodb
        Long chatId = queryVo.getChatId();
        com.ruoyi.pojo.Message msg = new com.ruoyi.pojo.Message();
        msg.setChatId(chatId);
        msg.setType(0);
        msg.setContent(queryVo.getMsg());
        msg.setCreateTime(new Date());
        msg.setId(IdUtil.getSnowflake().nextId());
        this.mongoTemplate.insert(msg, MongoUtil.getMessageCollection(chatId));


        String baseUrl = chatProject.getBaseUrl();
        String apiKey = chatProject.getApiKey();
        String model = chatProject.getModel();
        String embeddingModel = chatProject.getEmbeddingModel();


        List<Message> msgList = new ArrayList<>();
        // 暂时注释掉知识图谱功能
        // Neo4j 图数据库查询结果
//        String graphContext = neo4jService.getAllRelationshipsContext(queryVo.getProjectId(), knoledgeIds);
//        if (graphContext != null && !graphContext.isEmpty() && !graphContext.startsWith("未指定") && !graphContext.startsWith("指定的")) {
//            msgList.add(new UserMessage("以下是从图数据库中查询到的相关信息,请根据这些信息回答问题：\n" + graphContext));
//        }
        //是否开启联网搜索
        Boolean useWebSearch = chatProject.getIsWebSearch() == 1;
        if (useWebSearch) {
            String searchResult = searXNGService.searchV2(queryVo.getMsg());
            msgList.add(new UserMessage(searchResult));
        }
        // 中英文切换
        msgList.add(new SystemMessage(LanguageEnum.getMsg(queryVo.getLanguage())));
        msgList.add(new SystemMessage(chatProject.getSystemPrompt()));

        // 加入当前用户的提问
        msgList.add(new UserMessage("用户问题：" + queryVo.getMsg()));

        ToolCallback[] toolCallbacks = tools.getToolCallbacks();

        DashScopeChatModel dashScopeChatModel1 = ChatModelUtil.getDashScopeChatModel(baseUrl, apiKey, model, Arrays.asList(toolCallbacks));

        // 提交到大模型获取最终结果
        ChatClient chatClient = ChatClient.builder(dashScopeChatModel1)
                .defaultToolCallbacks(tools)
                .defaultAdvisors(
                        MessageChatMemoryAdvisor.builder(chatMemory).build(),
                        simpleLoggerAdvisor)
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
//                                            .filterExpression(
//                                                    new FilterExpressionBuilder()
//                                                            .eq("knowledgeId", knowledgeId) // 查询当前应用本地知识库
//                                                            .build())
                                            .topK(SystemConstant.TOPK).build()
                            )
                            .build();
                    advisorList.add(questionAnswerAdvisor);
                }
                chatClientRequestSpec.advisors(advisorList);
            }

        }



        Flux<ChatResponse> responseFlux = chatClientRequestSpec.stream().chatResponse();

        Flux<String> flux = responseFlux.map(response -> {
                   String result =  response.getResult() != null
                            && response.getResult().getOutput() != null
                            && response.getResult().getOutput().getText() != null
                            ? response.getResult().getOutput().getText() : "";
                   //log.info(result);
                    return result;
                 }
        );

        return flux;
    }



}


