package com.ruoyi.domain;

import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.ruoyi.common.annotation.Excel;
import com.ruoyi.common.core.domain.BaseEntity;

/**
 * 项目配置对象 chat_project
 * 
 * @author lixianfeng
 * @date 2024-06-27
 */
public class ChatProject extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 项目主键 */
    private String projectId;

    /** 项目名称 */
    @Excel(name = "项目名称")
    private String projectName;

    /** 模型类型：ollama、openai */
    @Excel(name = "模型类型：ollama、openai")
    private String type;



    /** 具体模型：qwen2:7B、gpt-3.5-turbo */
    @Excel(name = "具体模型：qwen2:7B、gpt-3.5-turbo")
    private String model;


    /** 具嵌入模型 */
    @Excel(name = "嵌入模型")
    private String embeddingModel;


    /** baseUrl */
    @Excel(name = "baseUrl")
    private String baseUrl;



    /** apiKey */
    @Excel(name = "apiKey")
    private String apiKey;


    /** 系统提示词 */
    @Excel(name = "systemPrompt")
    private String systemPrompt;




    /** 是否开启pdf增强解析 */
    @Excel(name = "isPdfAnalysis")
    private Integer isPdfAnalysis;




    /** 用户Id */
    @Excel(name = "userId")
    private Long userId;

    public String getBaseUrl() {
        return baseUrl;
    }

    public void setBaseUrl(String baseUrl) {
        this.baseUrl = baseUrl;
    }

    public String getApiKey() {
        return apiKey;
    }

    public void setApiKey(String apiKey) {
        this.apiKey = apiKey;
    }

    public String getSystemPrompt() {
        return systemPrompt;
    }

    public void setSystemPrompt(String systemPrompt) {
        this.systemPrompt = systemPrompt;
    }





    public void setProjectId(String projectId)
    {
        this.projectId = projectId;
    }

    public String getProjectId()
    {
        return projectId;
    }
    public void setProjectName(String projectName) 
    {
        this.projectName = projectName;
    }

    public String getProjectName() 
    {
        return projectName;
    }
    public void setType(String type) 
    {
        this.type = type;
    }

    public String getType() 
    {
        return type;
    }
    public void setModel(String model) 
    {
        this.model = model;
    }



    public String getModel()
    {
        return model;
    }


    public String getEmbeddingModel() {
        return embeddingModel;
    }

    public void setEmbeddingModel(String embeddingModel) {
        this.embeddingModel = embeddingModel;
    }


    public Integer getPdfAnalysis() {
        return isPdfAnalysis;
    }

    public void setPdfAnalysis(Integer pdfAnalysis) {
        isPdfAnalysis = pdfAnalysis;
    }




    public Integer getIsPdfAnalysis() {
        return isPdfAnalysis;
    }

    public void setIsPdfAnalysis(Integer isPdfAnalysis) {
        this.isPdfAnalysis = isPdfAnalysis;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }


    @Override
    public String toString() {
        return "ChatProject{" +
                "projectId='" + projectId + '\'' +
                ", projectName='" + projectName + '\'' +
                ", type='" + type + '\'' +
                ", model='" + model + '\'' +
                ", embeddingModel='" + embeddingModel + '\'' +
                ", baseUrl='" + baseUrl + '\'' +
                ", apiKey='" + apiKey + '\'' +
                ", systemPrompt='" + systemPrompt + '\'' +
                ", isPdfAnalysis=" + isPdfAnalysis +
                ", userId=" + userId +
                '}';
    }


}
