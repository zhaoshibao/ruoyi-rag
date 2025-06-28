package com.ruoyi.service;

import java.util.List;
import com.ruoyi.domain.ChatKnowledge;

/**
 * 知识库管理Service接口
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
public interface IChatKnowledgeService 
{
    /**
     * 查询知识库管理
     * 
     * @param knowledgeId 知识库管理主键
     * @return 知识库管理
     */
    public ChatKnowledge selectChatKnowledgeByKnowledgeId(String knowledgeId);




    /**
     * 查询知识库管理列表
     * 
     * @param chatKnowledge 知识库管理
     * @return 知识库管理集合
     */
    public List<ChatKnowledge> selectChatKnowledgeList(ChatKnowledge chatKnowledge);

    /**
     * 新增知识库管理
     * 
     * @param chatKnowledge 知识库管理
     * @return 结果
     */
    public int insertChatKnowledge(ChatKnowledge chatKnowledge);

    /**
     * 修改知识库管理
     * 
     * @param chatKnowledge 知识库管理
     * @return 结果
     */
    public int updateChatKnowledge(ChatKnowledge chatKnowledge);

    /**
     * 批量删除知识库管理
     * 
     * @param knowledgeIds 需要删除的知识库管理主键集合
     * @return 结果
     */
    public int deleteChatKnowledgeByKnowledgeIds(Long[] knowledgeIds);

    /**
     * 删除知识库管理信息
     * 
     * @param knowledgeId 知识库管理主键
     * @return 结果
     */
    public int deleteChatKnowledgeByKnowledgeId(String knowledgeId);
}
