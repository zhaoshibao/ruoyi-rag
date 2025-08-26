package com.ruoyi.service.impl;

import java.util.*;

import com.ruoyi.common.utils.DateUtils;
import com.ruoyi.domain.ChatFile;
import com.ruoyi.mapper.ChatFileMapper;
import com.ruoyi.mapper.ChatAppMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.ruoyi.service.IChatFileService;

/**
 * 知识库管理Service业务层处理
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
@Service
public class ChatFileServiceImpl implements IChatFileService {

    @Autowired
    private ChatAppMapper chatProjectMapper;
    @Autowired
    private ChatFileMapper chatFileMapper;

    /**
     * 查询文件
     *
     * @param fileId 文件主键
     * @return 文件
     */
    @Override
    public ChatFile selectChatFileByFileId(String fileId)
    {
        return chatFileMapper.selectChatFileByFileId(fileId);
    }

    /**
     * 查询文件列表(知识库id)
     *
     * @param knowledgeId 知识库id
     * @return 文件集合
     */
    @Override
    public List<ChatFile> selectChatFileByKnowledgeId(String knowledgeId)
    {
        return chatFileMapper.selectChatFileByKnowledgeId(knowledgeId);
    }

    /**
     * 查询文件列表
     *
     * @param chatFile 文件
     * @return 文件
     */
    @Override
    public List<ChatFile> selectChatFileList(ChatFile chatFile)
    {
        return chatFileMapper.selectChatFileList(chatFile);
    }



    /**
     * 新增文件
     *
     * @param chatFile 文件
     * @return 结果
     */
    @Override
    public int insertChatFile(ChatFile chatFile)
    {
        chatFile.setCreateTime(DateUtils.getNowDate());
        return chatFileMapper.insertChatFile(chatFile);
    }

    /**
     * 修改文件
     *
     * @param chatFile 文件
     * @return 结果
     */
    @Override
    public int updateChatFile(ChatFile chatFile)
    {
        chatFile.setUpdateTime(DateUtils.getNowDate());
        return chatFileMapper.updateChatFile(chatFile);
    }

    /**
     * 批量删除文件
     * 
     * @param fileIds 需要删除的文件主键
     * @return 结果
     */
    @Override
    public int deleteChatFileByFileIds(String[] fileIds)
    {
        return chatFileMapper.deleteChatFileByFileIds(fileIds);
    }



    /**
     * 删除文件信息
     * 
     * @param fileId 文件主键
     * @return 结果
     */
    @Override
    public int deleteChatFileByFileId(String fileId)
    {
        return chatFileMapper.deleteChatFileByFileId(fileId);
    }

}
