package com.ruoyi.operator;

import com.ruoyi.controller.ChatController;
import com.ruoyi.domain.ChatApp;
import com.ruoyi.vo.QueryVo;
import reactor.core.publisher.Flux;

import java.util.List;

/**
 * AI 操作接口
 */
public interface AiOperator {

    /**
     * 智能补全
     * @param request
     * @return
     */
    ChatController.CompletionResponse complete(ChatController.CompletionRequest request);

    /**
     * 获取补全选项
     * @param request
     * @return
     */
    List<ChatController.CompletionResponse> getCompletionOptions(ChatController.CompletionRequest request);

    /**
     * 一次性输出文本问答
     * @param queryVo QueryVo
     * @return
     */
    default String chat(QueryVo queryVo){
        throw new UnsupportedOperationException();
    }

    /**
     * 流式输出文本问答
     *
     * @param chatProject
     * @param queryVo QueryVo
     * @return
     */
    default Flux<String> chatStream(ChatApp chatProject, QueryVo queryVo) throws Exception {
        throw new UnsupportedOperationException();
    }




}
