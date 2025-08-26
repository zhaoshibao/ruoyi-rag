package com.ruoyi.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mapper.ChatFileSegmentMapper;
import com.ruoyi.domain.ChatFileSegment;
import com.ruoyi.service.IChatFileSegmentService;

/**
 * 文件分片Service业务层处理
 * 
 * @author zhaoshibao
 * @date 2025-06-26
 */
@Service
public class ChatFileSegmentServiceImpl implements IChatFileSegmentService 
{
    @Autowired
    private ChatFileSegmentMapper chatFileSegmentMapper;

    /**
     * 查询文件分片
     * 
     * @param segmentId 文件分片主键
     * @return 文件分片
     */
    @Override
    public ChatFileSegment selectChatFileSegmentBySegmentId(String segmentId)
    {
        return chatFileSegmentMapper.selectChatFileSegmentBySegmentId(segmentId);
    }

    /**
     * 查询文件分片列表
     * 
     * @param chatFileSegment 文件分片
     * @return 文件分片
     */
    @Override
    public List<ChatFileSegment> selectChatFileSegmentList(ChatFileSegment chatFileSegment)
    {
        return chatFileSegmentMapper.selectChatFileSegmentList(chatFileSegment);
    }

    /**
     * 新增文件分片
     * 
     * @param chatFileSegment 文件分片
     * @return 结果
     */
    @Override
    public int insertChatFileSegment(ChatFileSegment chatFileSegment)
    {
        chatFileSegment.setCreateTime(DateUtils.getNowDate());
        return chatFileSegmentMapper.insertChatFileSegment(chatFileSegment);
    }

    /**
     * 修改文件分片
     * 
     * @param chatFileSegment 文件分片
     * @return 结果
     */
    @Override
    public int updateChatFileSegment(ChatFileSegment chatFileSegment)
    {
        chatFileSegment.setUpdateTime(DateUtils.getNowDate());
        return chatFileSegmentMapper.updateChatFileSegment(chatFileSegment);
    }

    /**
     * 批量删除文件分片
     * 
     * @param segmentIds 需要删除的文件分片主键
     * @return 结果
     */
    @Override
    public int deleteChatFileSegmentBySegmentIds(String[] segmentIds)
    {
        return chatFileSegmentMapper.deleteChatFileSegmentBySegmentIds(segmentIds);
    }

    /**
     * 删除文件分片信息
     * 
     * @param segmentId 文件分片主键
     * @return 结果
     */
    @Override
    public int deleteChatFileSegmentBySegmentId(String segmentId)
    {
        return chatFileSegmentMapper.deleteChatFileSegmentBySegmentId(segmentId);
    }


    /**
     * 删除文件分片信息
     * @param fileId 文件ID
     * @return
     */
    @Override
    public int deleteChatFileSegmentByFileId(String fileId) {
        return chatFileSegmentMapper.deleteChatFileSegmentByFileId(fileId);
    }
}
