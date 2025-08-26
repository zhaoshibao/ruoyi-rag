package com.ruoyi.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 文件
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public class ChatFile extends BaseEntity {


    private static final long serialVersionUID = 1L;

    /** 知识库id */
    private String  knowledgeId;

    /** 文件id */
    private String fileId;

    /** 文件名 */
    private String fileName;

    /**
     * 文件格式
     */
    private String fileFormat;


    /**
     * 文件大小
     */
    private Long fileSize;

    /** 文件内容 */
    private String content;

    /** 是否向量化完成（0 否 1是） */
    private Integer isVector;

    /**
     * 是否需要分析
     */
    private Integer isPdfAnalysis;

    public String getKnowledgeId() {
        return knowledgeId;
    }

    public void setKnowledgeId(String knowledgeId) {
        this.knowledgeId = knowledgeId;
    }

    public String getFileId() {
        return fileId;
    }

    public void setFileId(String fileId) {
        this.fileId = fileId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getIsVector() {
        return isVector;
    }

    public void setIsVector(Integer isVector) {
        this.isVector = isVector;
    }

    public String getFileFormat() {
        return fileFormat;
    }

    public void setFileFormat(String fileFormat) {
        this.fileFormat = fileFormat;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public Integer getIsPdfAnalysis() {
        return isPdfAnalysis;
    }
    public void setIsPdfAnalysis(Integer isPdfAnalysis) {
        this.isPdfAnalysis = isPdfAnalysis;
    }

    @Override
    public String toString() {
        return "ChatFile{" +
                "knowledgeId='" + knowledgeId + '\'' +
                ", fileId='" + fileId + '\'' +
                ", fileName='" + fileName + '\'' +
                ", fileFormat='" + fileFormat + '\'' +
                ", fileSize=" + fileSize +
                ", content='" + content + '\'' +
                ", isVector=" + isVector +
                ", isPdfAnalysis=" + isPdfAnalysis +
                '}';
    }
}
