package com.ruoyi.service;

import java.util.List;
import com.ruoyi.domain.ChatApp;

/**
 * 应用配置Service接口
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public interface IChatAppService
{
    /**
     * 查询应用配置
     * 
     * @param appId 应用配置主键
     * @return 应用配置
     */
    public ChatApp selectChatAppByAppId(String appId);

    /**
     * 查询应用配置列表
     *
     * @param chatApp 应用配置
     * @return 应用配置集合
     */
    public List<ChatApp> selectChatAppList(ChatApp chatApp);

    /**
     * 新增应用配置
     *
     * @param chatApp 应用配置
     * @return 结果
     */
    public int insertChatApp(ChatApp chatApp);

    /**
     * 修改应用配置
     * 
     * @param chatApp 应用配置
     * @return 结果
     */
    public int updateChatApp(ChatApp chatApp);

    /**
     * 批量删除应用配置
     * 
     * @param appIds 需要删除的应用配置主键集合
     * @return 结果
     */
    public int deleteChatAppByAppIds(String[] appIds);

    /**
     * 删除应用配置信息
     * 
     * @param appId 应用配置主键
     * @return 结果
     */
    public int deleteChatAppByAppId(String appId);

    /**
     * 根据应用id查询知识库id列表
     * @param appId 应用id
     * @return 知识库id列表
     */
    public List<String> selectKnowledgeIdListByAppId(String appId);
}
