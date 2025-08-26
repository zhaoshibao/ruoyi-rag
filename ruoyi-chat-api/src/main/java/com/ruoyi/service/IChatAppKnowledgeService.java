package com.ruoyi.service;

import java.util.List;
import com.ruoyi.domain.ChatAppKnowledge;

/**
 * 应用和知识库关联Service接口
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public interface IChatAppKnowledgeService 
{
    /**
     * 查询应用和知识库关联
     * 
     * @param id 应用和知识库关联主键
     * @return 应用和知识库关联
     */
    public ChatAppKnowledge selectChatAppKnowledgeById(String id);

    /**
     * 查询应用和知识库关联列表
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 应用和知识库关联集合
     */
    public List<ChatAppKnowledge> selectChatAppKnowledgeList(ChatAppKnowledge chatAppKnowledge);

    /**
     * 新增应用和知识库关联
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 结果
     */
    public int insertChatAppKnowledge(ChatAppKnowledge chatAppKnowledge);

    /**
     * 修改应用和知识库关联
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 结果
     */
    public int updateChatAppKnowledge(ChatAppKnowledge chatAppKnowledge);

    /**
     * 批量删除应用和知识库关联
     * 
     * @param ids 需要删除的应用和知识库关联主键集合
     * @return 结果
     */
    public int deleteChatAppKnowledgeByIds(String[] ids);

    /**
     * 删除应用和知识库关联信息
     * 
     * @param id 应用和知识库关联主键
     * @return 结果
     */
    public int deleteChatAppKnowledgeById(String id);
}
