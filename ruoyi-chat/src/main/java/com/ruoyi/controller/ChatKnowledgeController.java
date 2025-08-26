package com.ruoyi.controller;

import java.util.List;

import com.ruoyi.common.utils.SecurityUtils;
import com.ruoyi.common.utils.uuid.IdUtils;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.service.IChatKnowledgeService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 知识库Controller
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
@RestController
@RequestMapping("/ruoyi/knowledge")
public class ChatKnowledgeController extends BaseController
{
    @Autowired
    private IChatKnowledgeService chatKnowledgeService;

    /**
     * 查询知识库列表
     */
    @GetMapping("/list")
    public TableDataInfo list(ChatKnowledge chatKnowledge)
    {
        Long userId = SecurityUtils.getUserId();
        chatKnowledge.setUserId(userId);
        startPage();
        List<ChatKnowledge> list = chatKnowledgeService.selectChatKnowledgeList(chatKnowledge);
        return getDataTable(list);
    }

    /**
     * 导出知识库列表
     */
    @Log(title = "知识库", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatKnowledge chatKnowledge)
    {
        List<ChatKnowledge> list = chatKnowledgeService.selectChatKnowledgeList(chatKnowledge);
        ExcelUtil<ChatKnowledge> util = new ExcelUtil<ChatKnowledge>(ChatKnowledge.class);
        util.exportExcel(response, list, "知识库数据");
    }

    /**
     * 获取知识库详细信息
     */
    @GetMapping(value = "/{knowledgeId}")
    public AjaxResult getInfo(@PathVariable("knowledgeId") String knowledgeId)
    {
        return success(chatKnowledgeService.selectChatKnowledgeByKnowledgeId(knowledgeId));
    }

    /**
     * 新增知识库
     */
    @Log(title = "知识库", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatKnowledge chatKnowledge)
    {
        Long userId = SecurityUtils.getUserId();
        chatKnowledge.setUserId(userId);
        chatKnowledge.setKnowledgeId(IdUtils.simpleUUID());
        return toAjax(chatKnowledgeService.insertChatKnowledge(chatKnowledge));
    }

    /**
     * 修改知识库
     */
    @Log(title = "知识库", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ChatKnowledge chatKnowledge)
    {
        return toAjax(chatKnowledgeService.updateChatKnowledge(chatKnowledge));
    }

    /**
     * 删除知识库
     */
    @Log(title = "知识库", businessType = BusinessType.DELETE)
	@DeleteMapping("/{knowledgeIds}")
    public AjaxResult remove(@PathVariable String[] knowledgeIds)
    {
        return toAjax(chatKnowledgeService.deleteChatKnowledgeByKnowledgeIds(knowledgeIds));
    }
}
