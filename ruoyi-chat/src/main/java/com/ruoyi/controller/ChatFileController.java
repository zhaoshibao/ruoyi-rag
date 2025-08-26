package com.ruoyi.controller;

import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.domain.ChatFile;
import com.ruoyi.domain.ChatFileSegment;
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
public class ChatFileController extends BaseController
{
    @Autowired
    private IChatFileService chatFileService;

    @Autowired
    private IChatFileSegmentService chatFileSegmentService;

    @Autowired
    private AiService aiService;

    @Operation(summary = "根据知识库ID获取文件列表")
    @GetMapping("/getFileListByKnowledgeId")
    public TableDataInfo getFileListByKnowledgeId(@RequestParam String knowledgeId){
        List<ChatFile> list = chatFileService.selectChatFileByKnowledgeId(knowledgeId);
        return getDataTable(list);
    }

    @Operation(summary = "分页查询文件列表")
    @GetMapping("/list")
    public TableDataInfo list(ChatFile chatFile)
    {
        startPage();
        List<ChatFile> list = chatFileService.selectChatFileList(chatFile);
        return getDataTable(list);
    }

    @Operation(summary = "文件上传")
    @PostMapping("upload")
    public AjaxResult upload(ChatFile chatFile, MultipartFile file){

        chatFile.setCreateBy(getUsername());
        try {
            aiService.upload(chatFile, file);
            return success("上传成功");
        } catch (Exception e) {
            log.error("文件上传接口异常：", e);
            throw new RuntimeException(e);
        }
    }

    @Operation(summary = "文件删除")
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

    @Operation(summary = "导出文件列表")
    @Log(title = "导出文件列表", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatFile chatFile)
    {
        List<ChatFile> list = chatFileService.selectChatFileList(chatFile);
        ExcelUtil<ChatFile> util = new ExcelUtil<ChatFile>(ChatFile.class);
        util.exportExcel(response, list, "文件列表");
    }

    @Operation(summary = "根据文件ID获取文件分片列表")
    @GetMapping(value = "/{fileId}")
    public AjaxResult getInfo(@PathVariable("fileId") String fileId) {
        List<ChatFileSegment> result = null;
        try {
            startPage();
            ChatFileSegment chatFileSegment = new ChatFileSegment();
            chatFileSegment.setFileId(fileId);
            result = chatFileSegmentService.selectChatFileSegmentList(chatFileSegment);
        } catch (Exception e) {
            log.error("根据文件ID获取文件分片列表接口异常：", e);
            return error(e.getMessage());
        }
        return success(result);
    }

    @Operation(summary = "新增文件管理")
    @Log(title = "新增文件管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatFile chatFile)
    {
        return toAjax(chatFileService.insertChatFile(chatFile));
    }

    @Operation(summary = "修改文件管理")
    @Log(title = "修改文件管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ChatFile chatFile)
    {
        return toAjax(chatFileService.updateChatFile(chatFile));
    }

    @Operation(summary = "删除文件管理")
    @Log(title = "删除文件管理", businessType = BusinessType.DELETE)
	@DeleteMapping
    public AjaxResult remove(@RequestBody ChatFile chatFile){
        Boolean result = true;
        try {
            result  = this.aiService.remove(chatFile.getKnowledgeId(), chatFile.getFileId());
        } catch (Exception e) {
            log.error("删除文件管理接口异常：", e);
            return error(e.getMessage());
        }
        return toAjax(result);
    }

}
