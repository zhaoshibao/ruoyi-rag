package com.ruoyi.service;

import java.util.List;
import com.ruoyi.domain.ChatKnowledge;

/**
 * 知识库Service接口
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public interface IChatKnowledgeService 
{
    /**
     * 查询知识库
     * 
     * @param knowledgeId 知识库主键
     * @return 知识库
     */
    public ChatKnowledge selectChatKnowledgeByKnowledgeId(String knowledgeId);

    /**
     * 查询知识库列表
     * 
     * @param chatKnowledge 知识库
     * @return 知识库集合
     */
    public List<ChatKnowledge> selectChatKnowledgeList(ChatKnowledge chatKnowledge);

    /**
     * 新增知识库
     * 
     * @param chatKnowledge 知识库
     * @return 结果
     */
    public int insertChatKnowledge(ChatKnowledge chatKnowledge);

    /**
     * 修改知识库
     * 
     * @param chatKnowledge 知识库
     * @return 结果
     */
    public int updateChatKnowledge(ChatKnowledge chatKnowledge);

    /**
     * 批量删除知识库
     * 
     * @param knowledgeIds 需要删除的知识库主键集合
     * @return 结果
     */
    public int deleteChatKnowledgeByKnowledgeIds(String[] knowledgeIds);

    /**
     * 删除知识库信息
     * 
     * @param knowledgeId 知识库主键
     * @return 结果
     */
    public int deleteChatKnowledgeByKnowledgeId(String knowledgeId);
}
