package com.ruoyi.controller;

import java.util.List;
import javax.servlet.http.HttpServletResponse;
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
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.service.IChatFileSegmentService;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.common.core.page.TableDataInfo;

/**
 * 文件分片Controller
 * 
 * @author zhaoshibao
 * @date 2025-06-26
 */
@RestController
@RequestMapping("/ruoyi/segment")
public class ChatFileSegmentController extends BaseController
{
    @Autowired
    private IChatFileSegmentService chatFileSegmentService;

    /**
     * 查询文件分片列表
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:list')")
    @GetMapping("/list")
    public TableDataInfo list(ChatFileSegment chatFileSegment)
    {
        startPage();
        List<ChatFileSegment> list = chatFileSegmentService.selectChatFileSegmentList(chatFileSegment);
        return getDataTable(list);
    }

    /**
     * 导出文件分片列表
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:export')")
    @Log(title = "文件分片", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ChatFileSegment chatFileSegment)
    {
        List<ChatFileSegment> list = chatFileSegmentService.selectChatFileSegmentList(chatFileSegment);
        ExcelUtil<ChatFileSegment> util = new ExcelUtil<ChatFileSegment>(ChatFileSegment.class);
        util.exportExcel(response, list, "文件分片数据");
    }

    /**
     * 获取文件分片详细信息
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:queryVo')")
    @GetMapping(value = "/{segmentId}")
    public AjaxResult getInfo(@PathVariable("segmentId") String segmentId)
    {
        return success(chatFileSegmentService.selectChatFileSegmentBySegmentId(segmentId));
    }

    /**
     * 新增文件分片
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:add')")
    @Log(title = "文件分片", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@RequestBody ChatFileSegment chatFileSegment)
    {
        return toAjax(chatFileSegmentService.insertChatFileSegment(chatFileSegment));
    }

    /**
     * 修改文件分片
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:edit')")
    @Log(title = "文件分片", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@RequestBody ChatFileSegment chatFileSegment)
    {
        return toAjax(chatFileSegmentService.updateChatFileSegment(chatFileSegment));
    }

    /**
     * 删除文件分片
     */
    @PreAuthorize("@ss.hasPermi('ruoyi:segment:remove')")
    @Log(title = "文件分片", businessType = BusinessType.DELETE)
	@DeleteMapping("/{segmentIds}")
    public AjaxResult remove(@PathVariable String[] segmentIds)
    {
        return toAjax(chatFileSegmentService.deleteChatFileSegmentBySegmentIds(segmentIds));
    }
}
