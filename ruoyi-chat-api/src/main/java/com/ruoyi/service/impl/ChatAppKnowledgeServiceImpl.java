package com.ruoyi.service.impl;

import java.util.List;
import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mapper.ChatAppKnowledgeMapper;
import com.ruoyi.domain.ChatAppKnowledge;
import com.ruoyi.service.IChatAppKnowledgeService;

/**
 * 应用和知识库关联Service业务层处理
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
@Service
public class ChatAppKnowledgeServiceImpl implements IChatAppKnowledgeService 
{
    @Autowired
    private ChatAppKnowledgeMapper chatAppKnowledgeMapper;

    /**
     * 查询应用和知识库关联
     * 
     * @param id 应用和知识库关联主键
     * @return 应用和知识库关联
     */
    @Override
    public ChatAppKnowledge selectChatAppKnowledgeById(String id)
    {
        return chatAppKnowledgeMapper.selectChatAppKnowledgeById(id);
    }

    /**
     * 查询应用和知识库关联列表
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 应用和知识库关联
     */
    @Override
    public List<ChatAppKnowledge> selectChatAppKnowledgeList(ChatAppKnowledge chatAppKnowledge)
    {
        return chatAppKnowledgeMapper.selectChatAppKnowledgeList(chatAppKnowledge);
    }

    /**
     * 新增应用和知识库关联
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 结果
     */
    @Override
    public int insertChatAppKnowledge(ChatAppKnowledge chatAppKnowledge)
    {
        chatAppKnowledge.setCreateTime(DateUtils.getNowDate());
        return chatAppKnowledgeMapper.insertChatAppKnowledge(chatAppKnowledge);
    }

    /**
     * 修改应用和知识库关联
     * 
     * @param chatAppKnowledge 应用和知识库关联
     * @return 结果
     */
    @Override
    public int updateChatAppKnowledge(ChatAppKnowledge chatAppKnowledge)
    {
        chatAppKnowledge.setUpdateTime(DateUtils.getNowDate());
        return chatAppKnowledgeMapper.updateChatAppKnowledge(chatAppKnowledge);
    }

    /**
     * 批量删除应用和知识库关联
     * 
     * @param ids 需要删除的应用和知识库关联主键
     * @return 结果
     */
    @Override
    public int deleteChatAppKnowledgeByIds(String[] ids)
    {
        return chatAppKnowledgeMapper.deleteChatAppKnowledgeByIds(ids);
    }

    /**
     * 删除应用和知识库关联信息
     * 
     * @param id 应用和知识库关联主键
     * @return 结果
     */
    @Override
    public int deleteChatAppKnowledgeById(String id)
    {
        return chatAppKnowledgeMapper.deleteChatAppKnowledgeById(id);
    }
}
