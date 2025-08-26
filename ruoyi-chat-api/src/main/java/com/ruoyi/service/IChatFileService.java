package com.ruoyi.service;

import com.ruoyi.domain.ChatFile;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

/**
 * 文件Service接口
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public interface IChatFileService
{
    /**
     * 查询文件
     *
     * @param fileId 文件主键
     * @return 文件
     */
    public ChatFile selectChatFileByFileId(String fileId);

    /**
     * 查询文件列表(知识库id)
     *
     * @param knowledgeId 知识库id
     * @return 文件集合
     */
    public List<ChatFile> selectChatFileByKnowledgeId(String knowledgeId);

    /**
     * 查询文件列表
     *
     * @param chatFile 文件
     * @return 文件集合
     */
    public List<ChatFile> selectChatFileList(ChatFile chatFile);

    /**
     * 新增文件
     *
     * @param chatFile 文件
     * @return 结果
     */
    public int insertChatFile(ChatFile chatFile);

    /**
     * 修改文件
     *
     * @param chatFile 文件
     * @return 结果
     */
    public int updateChatFile(ChatFile chatFile);

    /**
     * 删除文件
     *
     * @param fileId 文件主键
     * @return 结果
     */
    public int deleteChatFileByFileId(String fileId);

    /**
     * 批量删除文件
     *
     * @param fileIds 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteChatFileByFileIds(String[] fileIds);
}
