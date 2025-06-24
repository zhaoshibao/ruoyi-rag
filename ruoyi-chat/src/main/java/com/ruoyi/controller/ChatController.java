package com.ruoyi.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.pojo.Chat;
import com.ruoyi.pojo.Message;
import com.ruoyi.service.AiService;
import com.ruoyi.vo.ChatVo;
import com.ruoyi.vo.MessageVo;
import com.ruoyi.vo.QueryVo;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import reactor.core.publisher.Flux;

import java.util.List;

@RestController
@Tag(name = "AI大模型交互")
@RequestMapping("ai")
@Slf4j
public class ChatController extends BaseController {


    @Autowired
    private AiService aiService;


    @Operation(summary = "文本问答")
    @PostMapping(value = "chat-stream", produces = "text/plain;charset=UTF-8")
    public Flux<String> chatStream(@RequestBody @Valid QueryVo queryVo) {

        try {
            return aiService.chatStream(queryVo);
        } catch (Exception e) {
            log.error("AI大模型交互-文本文答接口异常", e);
            throw new RuntimeException(e);
        }
    }


    @Operation(summary = "文本问答V2")
    @PostMapping(value = "chat-stream-v2", produces = "text/plain;charset=UTF-8")
    public void chatStreamv2(@RequestBody @Valid QueryVo queryVo) {
        aiService.chatStreamv2(queryVo);
    }

    @Operation(summary = "创建新的会话")
    @PostMapping("create-chat")
    public String createChat(@Valid @RequestBody ChatVo chatVo){
        return this.aiService.createChat(chatVo);
    }

    @Operation(summary = "修改会话标题")
    @PostMapping("update-chat")
    public AjaxResult updateChat(@RequestBody ChatVo chatVo){
        this.aiService.updateChat(chatVo);
        return success();
    }

    @Operation(summary = "查询会话列表")
    @GetMapping("list-chat")
    public List<Chat> listChat(String projectId, Long userId){
        return this.aiService.listChat(projectId, userId);
    }

    @Operation(summary = "删除一个会话")
    @GetMapping("delete-chat")
    public AjaxResult deleteChat(String projectId, Long chatId){
        this.aiService.deleteChat(projectId, chatId);
        return success();
    }

    @Operation(summary = "查询一个会话中的问答消息")
    @GetMapping("list-msg")
    public List<Message> listMsg(Long chatId){
        return this.aiService.listMsg(chatId);
    }

    @Operation(summary = "如果需要保存AI回答的结果，调用此接口")
    @PostMapping("save-msg")
    public AjaxResult saveMsg(@Valid @RequestBody MessageVo messageVo){
        this.aiService.saveMsg(messageVo);
        return success();
    }




    public record CompletionRequest(String text, int cursorPosition) {}
    public record CompletionResponse(String completion, String fullText) {}

    /**
     * 智能补全
     * @param request
     * @return
     */
    @PostMapping("/complete")
    public CompletionResponse complete(@RequestBody CompletionRequest request) {
        try {
            return aiService.complete(request);
        } catch (Exception e) {
            log.error("智能补全接口异常", e);
            throw new RuntimeException(e);
        }
    }

    /**
     * 获取补全选项
     * @param request
     * @return
     */
    @PostMapping("/complete-options")
    public List<CompletionResponse> getCompletionOptions(@RequestBody CompletionRequest request) {
        try {
            return aiService.getCompletionOptions(request);
        } catch (Exception e) {
            log.error("获取补全选项接口异常", e);
            throw new RuntimeException(e);
        }
    }
}
