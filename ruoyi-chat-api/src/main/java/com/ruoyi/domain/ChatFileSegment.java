package com.ruoyi.domain;

import com.ruoyi.common.annotation.Excel;

/**
 * 文件分片对象 chat_file_segment
 * 
 * @author zhaoshibao
 * @date 2025-06-26
 */
public class ChatFileSegment extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 文件分片ID */
    private String segmentId;

    /** 知识库id */
    @Excel(name = "知识库id")
    private String knowledgeId;

    /** 文件名 */
    @Excel(name = "文件名")
    private String fileName;

    /** 文件内容 */
    @Excel(name = "文件内容")
    private String content;

    public void setSegmentId(String segmentId) 
    {
        this.segmentId = segmentId;
    }

    public String getSegmentId() 
    {
        return segmentId;
    }
    public void setKnowledgeId(String knowledgeId) 
    {
        this.knowledgeId = knowledgeId;
    }

    public String getKnowledgeId() 
    {
        return knowledgeId;
    }
    public void setFileName(String fileName) 
    {
        this.fileName = fileName;
    }

    public String getFileName() 
    {
        return fileName;
    }
    public void setContent(String content) 
    {
        this.content = content;
    }

    public String getContent() 
    {
        return content;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this,ToStringStyle.MULTI_LINE_STYLE)
            .append("segmentId", getSegmentId())
            .append("knowledgeId", getKnowledgeId())
            .append("fileName", getFileName())
            .append("content", getContent())
            .append("createBy", getCreateBy())
            .append("createTime", getCreateTime())
            .append("updateBy", getUpdateBy())
            .append("updateTime", getUpdateTime())
            .append("remark", getRemark())
            .toString();
    }
}
