package com.ruoyi.domain;

import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 文件
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
public class ChatFile extends BaseEntity {


    private static final long serialVersionUID = 1L;

    /** $column.columnComment */
    private String  knowledgeId;



    /** 用户id */
    private Long userId;

    /** 项目id */
    private String projectId;


    /** 项目名称 */
    private String projectName;
    /** 文件名 */
    private String fileName;

    /** 文件内容 */
    private String content;



    /** 是否向量化完成（0 否 1是） */
    private Integer isVector;


    /** 是否开启知识图谱（0 否 1是） */
    private Integer isKnowledgeGraph;

    public void setKnowledgeId(String knowledgeId)
    {
        this.knowledgeId = knowledgeId;
    }

    public String getKnowledgeId()
    {
        return knowledgeId;
    }
    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }
    public void setProjectId(String projectId)
    {
        this.projectId = projectId;
    }

    public String getProjectId()
    {
        return projectId;
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


    public Integer getIsVector() {
        return isVector;
    }

    public void setIsVector(Integer isVector) {
        this.isVector = isVector;
    }

    public Integer getIsKnowledgeGraph() {
        return isKnowledgeGraph;
    }

    public void setIsKnowledgeGraph(Integer isKnowledgeGraph) {
        this.isKnowledgeGraph = isKnowledgeGraph;
    }



    public String getProjectName() {
        return projectName;
    }

    public void setProjectName(String projectName) {
        this.projectName = projectName;
    }

    @Override
    public String toString() {
        return "ChatKnowledge{" +
                "knowledgeId='" + knowledgeId + '\'' +
                ", userId=" + userId +
                ", projectId='" + projectId + '\'' +
                ", projectName='" + projectName + '\'' +
                ", fileName='" + fileName + '\'' +
                ", content='" + content + '\'' +
                ", isVector=" + isVector +
                ", isKnowledgeGraph=" + isKnowledgeGraph +
                '}';
    }
}
