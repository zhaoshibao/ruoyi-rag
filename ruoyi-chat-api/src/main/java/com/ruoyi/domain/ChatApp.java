package com.ruoyi.domain;

import com.ruoyi.common.core.domain.BaseEntity;

import java.util.List;

/**
 * 应用配置表
 * 
 * @author zhaoshibao
 * @date 2025-08-24
 */
public class ChatApp extends BaseEntity {
    private static final long serialVersionUID = 1L;

    /** 应用主键 */
    private String appId;

    /** 应用名称 */
    private String appName;

    /** 模型类型：ollama、openai 、zhipuai、dashscope*/
    private String type;

    /** 具体模型：qwen2:7B、gpt-3.5-turbo */
    private String model;


    /** 具嵌入模型 */
    private String embeddingModel;


    /** baseUrl */
    private String baseUrl;



    /** apiKey */
    private String apiKey;


    /** 系统提示词 */
    private String systemPrompt;




    /** 是否开启知识库搜索 */
    private Integer isKnowledgeSearch;

    /**
     * 是否开启联网搜索
     */
    private Integer isWebSearch;


    private List<String> knowledgeIds;



    /** 用户Id */
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

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Integer getIsKnowledgeSearch() {
        return isKnowledgeSearch;
    }

    public void setIsKnowledgeSearch(Integer isKnowledgeSearch) {
        this.isKnowledgeSearch = isKnowledgeSearch;
    }

    public Integer getIsWebSearch() {
        return isWebSearch;
    }

    public void setIsWebSearch(Integer isWebSearch) {
        this.isWebSearch = isWebSearch;
    }

    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getAppName() {
        return appName;
    }

    public void setAppName(String appName) {
        this.appName = appName;
    }


    public List<String> getKnowledgeIds() {
        return knowledgeIds;
    }

    public void setKnowledgeIds(List<String> knowledgeIds) {
        this.knowledgeIds = knowledgeIds;
    }

    @Override
    public String toString() {
        return "ChatApp{" +
                "appId='" + appId + '\'' +
                ", appName='" + appName + '\'' +
                ", type='" + type + '\'' +
                ", model='" + model + '\'' +
                ", embeddingModel='" + embeddingModel + '\'' +
                ", baseUrl='" + baseUrl + '\'' +
                ", apiKey='" + apiKey + '\'' +
                ", systemPrompt='" + systemPrompt + '\'' +
                ", isKnowledgeSearch=" + isKnowledgeSearch +
                ", isWebSearch=" + isWebSearch +
                ", userId=" + userId +
                '}';
    }
}
