package com.ruoyi.mapper;

import java.util.List;
import com.ruoyi.domain.ChatFileSegment;

/**
 * 文件分片Mapper接口
 * 
 * @author zhaoshibao
 * @date 2025-06-26
 */
public interface ChatFileSegmentMapper 
{
    /**
     * 查询文件分片
     * 
     * @param segmentId 文件分片主键
     * @return 文件分片
     */
    public ChatFileSegment selectChatFileSegmentBySegmentId(String segmentId);

    /**
     * 查询文件分片列表
     * 
     * @param chatFileSegment 文件分片
     * @return 文件分片集合
     */
    public List<ChatFileSegment> selectChatFileSegmentList(ChatFileSegment chatFileSegment);

    /**
     * 新增文件分片
     * 
     * @param chatFileSegment 文件分片
     * @return 结果
     */
    public int insertChatFileSegment(ChatFileSegment chatFileSegment);

    /**
     * 修改文件分片
     * 
     * @param chatFileSegment 文件分片
     * @return 结果
     */
    public int updateChatFileSegment(ChatFileSegment chatFileSegment);

    /**
     * 删除文件分片
     * 
     * @param segmentId 文件分片主键
     * @return 结果
     */
    public int deleteChatFileSegmentBySegmentId(String segmentId);

    /**
     * 批量删除文件分片
     * 
     * @param segmentIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteChatFileSegmentBySegmentIds(String[] segmentIds);

    /**
     * 删除文件分片
     *
     * @param knowledgeId 知识库ID
     * @return 结果
     */
    public int deleteChatFileSegmentByKnowledgeId(String knowledgeId);
}
