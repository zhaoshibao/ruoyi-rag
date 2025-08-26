package com.ruoyi.service.impl;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.domain.ChatAppKnowledge;
import com.ruoyi.mapper.ChatAppKnowledgeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mapper.ChatAppMapper;
import com.ruoyi.domain.ChatApp;
import com.ruoyi.service.IChatAppService;
import org.springframework.util.CollectionUtils;

/**
 * 项目配置Service业务层处理
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
@Service
public class ChatAppServiceImpl implements IChatAppService
{
    @Autowired
    private ChatAppMapper chatAppMapper;
    @Autowired
    private ChatAppKnowledgeMapper chatAppKnowledgeMapper;

    /**
     * 查询应用配置
     *
     * @param appId 应用配置主键
     * @return 应用配置
     */
    @Override
    public ChatApp selectChatAppByAppId(String appId)
    {
        ChatApp chatApp = chatAppMapper.selectChatAppByAppId(appId);
        List<ChatAppKnowledge> chatAppKnowledgeList = chatAppKnowledgeMapper.selectChatAppKnowledgeByAppId(appId);
        List<String> knowledgeIds = chatAppKnowledgeList.stream().map(ChatAppKnowledge::getKnowledgeId).collect(Collectors.toList());
        chatApp.setKnowledgeIds(knowledgeIds);
        return chatApp;
    }

    /**
     * 查询应用配置列表
     * 
     * @param chatApp 应用配置
     * @return 应用配置
     */
    @Override
    public List<ChatApp> selectChatAppList(ChatApp chatApp)
    {
        return chatAppMapper.selectChatAppList(chatApp);
    }

    /**
     * 新增应用配置
     * 
     * @param chatApp 应用配置
     * @return 结果
     */
    @Override
    public int insertChatApp(ChatApp chatApp)
    {
        String appId = UUID.randomUUID().toString();
        chatApp.setCreateTime(DateUtils.getNowDate());
        chatApp.setAppId(appId);
        int result = chatAppMapper.insertChatApp(chatApp);
        List<String> knowledgeIds = chatApp.getKnowledgeIds();
        if (!CollectionUtils.isEmpty(knowledgeIds)) {
            for (String knowledgeId : knowledgeIds) {
                 ChatAppKnowledge chatAppKnowledge = new ChatAppKnowledge();
                 chatAppKnowledge.setAppId(appId);
                 chatAppKnowledge.setKnowledgeId(knowledgeId);
                 chatAppKnowledge.setId(UUID.randomUUID().toString());
                chatAppKnowledgeMapper.insertChatAppKnowledge(chatAppKnowledge);
            }
        }

        return result;
    }

    /**
     * 修改应用配置
     * 
     * @param chatApp 应用配置
     * @return 结果
     */
    @Override
    public int updateChatApp(ChatApp chatApp)
    {
        String appId = chatApp.getAppId();
        chatApp.setUpdateTime(DateUtils.getNowDate());
        int result = chatAppMapper.updateChatApp(chatApp);
        List<String> knowledgeIds = chatApp.getKnowledgeIds();
        chatAppKnowledgeMapper.deleteChatAppKnowledgeByAppId(appId);
        if (!CollectionUtils.isEmpty(knowledgeIds)) {
            for (String knowledgeId : knowledgeIds) {
                ChatAppKnowledge chatAppKnowledge = new ChatAppKnowledge();
                chatAppKnowledge.setAppId(appId);
                chatAppKnowledge.setKnowledgeId(knowledgeId);
                chatAppKnowledge.setId(UUID.randomUUID().toString());
                chatAppKnowledgeMapper.insertChatAppKnowledge(chatAppKnowledge);
            }
        }
        return result;
    }

    /**
     * 批量删除应用配置
     * 
     * @param appIds 需要删除的应用配置主键
     * @return 结果
     */
    @Override
    public int deleteChatAppByAppIds(String[] appIds)
    {
        return chatAppMapper.deleteChatAppByAppIds(appIds);
    }

    /**
     * 删除应用配置信息
     * 
     * @param appId 应用配置主键
     * @return 结果
     */
    @Override
    public int deleteChatAppByAppId(String appId)
    {
        return chatAppMapper.deleteChatAppByAppId(appId);
    }

    /**
     * 根据应用id查询知识库id列表
     * @param appId 应用id
     * @return 知识库id列表
     */
    @Override
    public List<String> selectKnowledgeIdListByAppId(String appId) {
        List<ChatAppKnowledge> chatAppKnowledgeList = chatAppKnowledgeMapper.selectChatAppKnowledgeByAppId(appId);
        List<String> knowledgeIds = chatAppKnowledgeList.stream().map(ChatAppKnowledge::getKnowledgeId).collect(Collectors.toList());
        return knowledgeIds;
    }
}
