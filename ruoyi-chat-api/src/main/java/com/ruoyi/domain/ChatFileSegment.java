package com.ruoyi.domain;

import com.ruoyi.common.core.domain.BaseEntity;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 文件分片对象 chat_file_segment
 * 
 * @author zhaoshibao
 * @date 2025-06-26
 */
public class ChatFileSegment extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 文件分片ID */
    private String segmentId;

    /** 文件id */
    private String fileId;

    /** 文件名 */
    private String fileName;

    /** 文件内容 */
    private String content;

    public void setSegmentId(String segmentId) 
    {
        this.segmentId = segmentId;
    }

    public String getSegmentId() 
    {
        return segmentId;
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

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    @Override
    public String toString() {
        return new ToStringBuilder(this, ToStringStyle.MULTI_LINE_STYLE)
            .append("segmentId", getSegmentId())
            .append("fileId",getFileId())
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
