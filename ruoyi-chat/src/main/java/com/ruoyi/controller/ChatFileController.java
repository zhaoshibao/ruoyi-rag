package com.ruoyi.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.service.AiService;
import com.ruoyi.service.IChatFileSegmentService;
import com.ruoyi.service.IChatFileService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 文件管理Controller
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
@RestController
@Tag(name = "文件管理")
@RequestMapping("/chat/file")
@Slf4j
public class ChatKnowledgeController extends BaseController
{
    @Autowired
    private IChatFileService chatKnowledgeService;

    @Autowired
    private IChatFileSegmentService chatFileSegmentService;

    @Autowired
    private AiService aiService;

    @Operation(summary = "不分页查询知识库管理列表")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:list')")
    @GetMapping
    public TableDataInfo getByProjectId(ChatKnowledge chatKnowledge){
        List<ChatKnowledge> list = chatKnowledgeService.selectChatKnowledgeList(chatKnowledge);
        return getDataTable(list);
    }

    @Operation(summary = "分页查询知识库管理列表")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:list')")
    @GetMapping("/list")
    public TableDataInfo list(ChatKnowledge chatKnowledge)
    {
        startPage();
        chatKnowledge.setUserId(getUserId());
        List<ChatKnowledge> list = chatKnowledgeService.selectChatKnowledgeList(chatKnowledge);
        return getDataTable(list);
    }

    @Operation(summary = "知识库上传")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:add')")
    @PostMapping("upload")
    public AjaxResult upload(ChatKnowledge chatKnowledge, MultipartFile file){

        chatKnowledge.setUserId(getUserId());
        chatKnowledge.setCreateBy(getUsername());
        try {
            aiService.upload(chatKnowledge, file);
            return success("上传成功");
        } catch (Exception e) {
            log.error("知识库上传接口异常：", e);
            throw new RuntimeException(e);
        }
    }

    @Operation(summary = "知识库删除")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:remove')")
    @DeleteMapping("remove")
    public AjaxResult removeFile(@RequestParam String projectId, @RequestParam String knowledgeId){
        try {
            aiService.remove(projectId, knowledgeId);
        } catch (Exception e) {
            log.error("知识库删除接口异常：", e);
            return error("删除失败");
        }
        return success("删除成功");
    }

    @Operation(summary = "导出知识库管理列表")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:export')")
    @Log(title = "知识库管理", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatKnowledge chatKnowledge)
    {
        List<ChatKnowledge> list = chatKnowledgeService.selectChatKnowledgeList(chatKnowledge);
        ExcelUtil<ChatKnowledge> util = new ExcelUtil<ChatKnowledge>(ChatKnowledge.class);
        util.exportExcel(response, list, "知识库管理数据");
    }

    @Operation(summary = "获取知识库管理详细信息")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:query')")
    @GetMapping(value = "/{projectId}/{knowledgeId}")
    public AjaxResult getInfo(@PathVariable("projectId") String projectId,@PathVariable("knowledgeId") String knowledgeId) {
        List<ChatFileSegment> result = null;
        try {
            startPage();
            ChatFileSegment chatFileSegment = new ChatFileSegment();
            chatFileSegment.setKnowledgeId(knowledgeId);
            result = chatFileSegmentService.selectChatFileSegmentList(chatFileSegment);
        } catch (Exception e) {
            log.error("获取知识库管理详细信息接口异常：", e);
            return error(e.getMessage());
        }
        return success(result);
        //return success(chatKnowledgeService.selectChatKnowledgeByKnowledgeId(knowledgeId));
    }

    @Operation(summary = "新增知识库管理")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:add')")
    @Log(title = "知识库管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatKnowledge chatKnowledge)
    {
        return toAjax(chatKnowledgeService.insertChatKnowledge(chatKnowledge));
    }

    @Operation(summary = "修改知识库管理")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:edit')")
    @Log(title = "知识库管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ChatKnowledge chatKnowledge)
    {
        return toAjax(chatKnowledgeService.updateChatKnowledge(chatKnowledge));
    }

    @Operation(summary = "删除知识库管理")
    //@PreAuthorize("@ss.hasPermi('chat:knowledge:remove')")
    @Log(title = "知识库管理", businessType = BusinessType.DELETE)
	@DeleteMapping
    public AjaxResult remove(@RequestBody ChatKnowledge knowledge){
        Boolean result = true;
        try {
            result  = this.aiService.remove(knowledge.getProjectId(), knowledge.getKnowledgeId());
        } catch (Exception e) {
            log.error("删除知识库管理接口异常：", e);
            return error();
        }
        return toAjax(result);
    }

}
