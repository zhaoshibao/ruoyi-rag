package com.ruoyi.service.impl;

import java.util.List;
import java.util.UUID;

import com.ruoyi.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.mapper.ChatProjectMapper;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.service.IChatProjectService;

/**
 * 项目配置Service业务层处理
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
@Service
public class ChatProjectServiceImpl implements IChatProjectService 
{
    @Autowired
    private ChatProjectMapper chatProjectMapper;

    /**
     * 查询项目配置
     * 
     * @param projectId 项目配置主键
     * @return 项目配置
     */
    @Override
    public ChatProject selectChatProjectByProjectId(String projectId)
    {
        return chatProjectMapper.selectChatProjectByProjectId(projectId);
    }

    /**
     * 查询项目配置列表
     * 
     * @param chatProject 项目配置
     * @return 项目配置
     */
    @Override
    public List<ChatProject> selectChatProjectList(ChatProject chatProject)
    {
        return chatProjectMapper.selectChatProjectList(chatProject);
    }

    /**
     * 新增项目配置
     * 
     * @param chatProject 项目配置
     * @return 结果
     */
    @Override
    public int insertChatProject(ChatProject chatProject)
    {
        chatProject.setCreateTime(DateUtils.getNowDate());
        chatProject.setProjectId(UUID.randomUUID().toString());
        return chatProjectMapper.insertChatProject(chatProject);
    }

    /**
     * 修改项目配置
     * 
     * @param chatProject 项目配置
     * @return 结果
     */
    @Override
    public int updateChatProject(ChatProject chatProject)
    {
        chatProject.setUpdateTime(DateUtils.getNowDate());
        return chatProjectMapper.updateChatProject(chatProject);
    }

    /**
     * 批量删除项目配置
     * 
     * @param projectIds 需要删除的项目配置主键
     * @return 结果
     */
    @Override
    public int deleteChatProjectByProjectIds(Long[] projectIds)
    {
        return chatProjectMapper.deleteChatProjectByProjectIds(projectIds);
    }

    /**
     * 删除项目配置信息
     * 
     * @param projectId 项目配置主键
     * @return 结果
     */
    @Override
    public int deleteChatProjectByProjectId(String projectId)
    {
        return chatProjectMapper.deleteChatProjectByProjectId(projectId);
    }
}
