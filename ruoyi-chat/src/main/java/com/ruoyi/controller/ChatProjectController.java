package com.ruoyi.controller;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.service.IChatProjectService;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 项目配置Controller
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
@RestController
@Tag(name = "项目后台管理", description = "该智能聊天可以同时供多个项目进行对接")
@RequestMapping("/chat/project")
public class ChatProjectController extends BaseController
{
    @Autowired
    private IChatProjectService chatProjectService;

    @Operation(summary = "不分页查询项目列表")
//    @PreAuthorize("@ss.hasPermi('chat:project:list')")
    @GetMapping
    public TableDataInfo listAll()
    {
        List<ChatProject> list = chatProjectService.selectChatProjectList(null);
        return getDataTable(list);
    }

    @Operation(summary = "分页查询项目列表")
//    @PreAuthorize("@ss.hasPermi('chat:project:list')")
    @GetMapping("/list")
    public TableDataInfo list(ChatProject chatProject) {
        Long userId = SecurityUtils.getUserId();
        startPage();
        chatProject.setUserId(userId);
        List<ChatProject> list = chatProjectService.selectChatProjectList(chatProject);
        return getDataTable(list);
    }

    @Operation(summary = "导出项目配置列表")
    //@PreAuthorize("@ss.hasPermi('chat:project:export')")
    @Log(title = "项目配置", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatProject chatProject)
    {
        List<ChatProject> list = chatProjectService.selectChatProjectList(chatProject);
        ExcelUtil<ChatProject> util = new ExcelUtil<ChatProject>(ChatProject.class);
        util.exportExcel(response, list, "项目配置数据");
    }

    @Operation(summary = "获取一个项目的详细信息")
    //@PreAuthorize("@ss.hasPermi('chat:project:query')")
    @GetMapping(value = "/{projectId}")
    public AjaxResult getInfo(@PathVariable("projectId") String projectId)
    {
        return success(chatProjectService.selectChatProjectByProjectId(projectId));
    }

    @Operation(summary = "新增项目配置")
    //@PreAuthorize("@ss.hasPermi('chat:project:add')")
    @Log(title = "项目配置", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatProject chatProject) {
        Long userId = SecurityUtils.getUserId();
        chatProject.setUserId(userId);
        return toAjax(chatProjectService.insertChatProject(chatProject));
    }

    @Operation(summary = "修改项目")
    //@PreAuthorize("@ss.hasPermi('chat:project:edit')")
    @Log(title = "项目配置", businessType = BusinessType.UPDATE)
    @PostMapping(value = "/edit")
    public AjaxResult edit(@RequestBody ChatProject chatProject) {
        return toAjax(chatProjectService.updateChatProject(chatProject));
    }

    @Operation(summary = "删除项目")
    @PreAuthorize("@ss.hasPermi('chat:project:remove')")
    @Log(title = "项目配置", businessType = BusinessType.DELETE)
	@DeleteMapping("/{projectIds}")
    public AjaxResult remove(@PathVariable String[] projectIds)
    {
        return toAjax(chatProjectService.deleteChatProjectByProjectIds(projectIds));
    }
}
