package com.ruoyi.controller;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.domain.ChatApp;
import com.ruoyi.service.IChatAppService;
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
 * 应用配置Controller
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
@RestController
@Tag(name = "应用管理", description = "应用管理")
@RequestMapping("/chat/app")
public class ChatAppController extends BaseController
{
    @Autowired
    private IChatAppService chatAppService;

    @Operation(summary = "不分页查询应用列表")
    @GetMapping
    public TableDataInfo listAll()
    {
        List<ChatApp> list = chatAppService.selectChatAppList(null);
        return getDataTable(list);
    }

    @Operation(summary = "分页查询应用列表")
    @GetMapping("/list")
    public TableDataInfo list(ChatApp chatApp) {
        Long userId = SecurityUtils.getUserId();
        startPage();
        chatApp.setUserId(userId);
        List<ChatApp> list = chatAppService.selectChatAppList(chatApp);
        return getDataTable(list);
    }

    @Operation(summary = "导出应用列表")
    @Log(title = "应用", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatApp chatApp)
    {
        List<ChatApp> list = chatAppService.selectChatAppList(chatApp);
        ExcelUtil<ChatApp> util = new ExcelUtil<ChatApp>(ChatApp.class);
        util.exportExcel(response, list, "应用数据");
    }

    @Operation(summary = "获取一个应用的详细信息")
    @GetMapping(value = "/{appId}")
    public AjaxResult getInfo(@PathVariable("appId") String appId)
    {
        return success(chatAppService.selectChatAppByAppId(appId));
    }

    @Operation(summary = "新增应用")
    @Log(title = "应用", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatApp chatApp) {
        Long userId = SecurityUtils.getUserId();
        chatApp.setUserId(userId);
        return toAjax(chatAppService.insertChatApp(chatApp));
    }

    @Operation(summary = "修改应用")
    @Log(title = "应用", businessType = BusinessType.UPDATE)
    @PostMapping(value = "/edit")
    public AjaxResult edit(@RequestBody ChatApp chatApp) {
        return toAjax(chatAppService.updateChatApp(chatApp));
    }

    @Operation(summary = "删除应用")
    @PreAuthorize("@ss.hasPermi('chat:app:remove')")
    @Log(title = "应用", businessType = BusinessType.DELETE)
	@DeleteMapping("/{appIds}")
    public AjaxResult remove(@PathVariable String[] appIds)
    {
        return toAjax(chatAppService.deleteChatAppByAppIds(appIds));
    }
}
