package com.ruoyi.mapper;

import java.util.List;
import com.ruoyi.domain.ChatAppKnowledge;

/**
 * 应用和知识库关联Mapper接口
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public interface ChatAppKnowledgeMapper 
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
     * @param appId 应用ID
     * @return 应用和知识库关联集合
     */
    public List<ChatAppKnowledge> selectChatAppKnowledgeByAppId(String appId);

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
     * 删除应用和知识库关联
     * 
     * @param id 应用和知识库关联主键
     * @return 结果
     */
    public int deleteChatAppKnowledgeById(String id);

    /**
     * 根据应用ID删除
     *
     * @param appId 应用ID
     * @return 结果
     */
    public int deleteChatAppKnowledgeByAppId(String appId);

    /**
     * 批量删除应用和知识库关联
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteChatAppKnowledgeByIds(String[] ids);
}
