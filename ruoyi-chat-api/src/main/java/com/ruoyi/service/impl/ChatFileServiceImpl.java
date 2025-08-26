package com.ruoyi.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.mapper.ChatFileMapper;
import com.ruoyi.mapper.ChatProjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.service.IChatKnowledgeService;
import org.springframework.util.CollectionUtils;

/**
 * 知识库管理Service业务层处理
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
@Service
public class ChatKnowledgeServiceImpl implements IChatKnowledgeService {

    @Autowired
    private ChatProjectMapper chatProjectMapper;
    @Autowired
    private ChatFileMapper chatFileMapper;

    /**
     * 查询知识库管理
     * 
     * @param knowledgeId 知识库管理主键
     * @return 知识库管理
     */
    @Override
    public ChatKnowledge selectChatKnowledgeByKnowledgeId(String knowledgeId)
    {
        return chatFileMapper.selectChatKnowledgeByKnowledgeId(knowledgeId);
    }


    /**
     * 查询知识库管理列表
     * 
     * @param chatKnowledge 知识库管理
     * @return 知识库管理
     */
    @Override
    public List<ChatKnowledge> selectChatKnowledgeList(ChatKnowledge chatKnowledge) {
        List<ChatKnowledge> chatKnowledgeList = chatFileMapper.selectChatKnowledgeList(chatKnowledge);
        if (CollectionUtils.isEmpty(chatKnowledgeList)) {
            return chatKnowledgeList;
        }
        chatKnowledgeList = chatKnowledgeList.stream().map(chatKnowledge1 -> {
            String projectId = chatKnowledge1.getProjectId();
            ChatProject chatProject = chatProjectMapper.selectChatProjectByProjectId(projectId);
            chatKnowledge1.setProjectName(chatProject.getProjectName());
            return chatKnowledge1;
        }).collect(Collectors.toList());

        return chatKnowledgeList;
    }

    /**
     * 新增知识库管理
     * 
     * @param chatKnowledge 知识库管理
     * @return 结果
     */
    @Override
    public int insertChatKnowledge(ChatKnowledge chatKnowledge)
    {
        chatKnowledge.setCreateTime(DateUtils.getNowDate());
        return chatFileMapper.insertChatKnowledge(chatKnowledge);
    }

    /**
     * 修改知识库管理
     * 
     * @param chatKnowledge 知识库管理
     * @return 结果
     */
    @Override
    public int updateChatKnowledge(ChatKnowledge chatKnowledge)
    {
        chatKnowledge.setUpdateTime(DateUtils.getNowDate());
        return chatFileMapper.updateChatKnowledge(chatKnowledge);
    }

    /**
     * 批量删除知识库管理
     * 
     * @param knowledgeIds 需要删除的知识库管理主键
     * @return 结果
     */
    @Override
    public int deleteChatKnowledgeByKnowledgeIds(Long[] knowledgeIds)
    {
        return chatFileMapper.deleteChatKnowledgeByKnowledgeIds(knowledgeIds);
    }

    /**
     * 删除知识库管理信息
     * 
     * @param knowledgeId 知识库管理主键
     * @return 结果
     */
    @Override
    public int deleteChatKnowledgeByKnowledgeId(String knowledgeId)
    {
        return chatFileMapper.deleteChatKnowledgeByKnowledgeId(knowledgeId);
    }
}
