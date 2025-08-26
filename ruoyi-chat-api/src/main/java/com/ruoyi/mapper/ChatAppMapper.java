package com.ruoyi.mapper;

import java.util.List;
import com.ruoyi.domain.ChatApp;

/**
 * 项目配置Mapper接口
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
public interface ChatAppMapper
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
     * 删除应用配置
     *
     * @param appId 应用配置主键
     * @return 结果
     */
    public int deleteChatAppByAppId(String appId);

    /**
     * 批量删除应用配置
     * 
     * @param appIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteChatAppByAppIds(String[] appIds);
}
