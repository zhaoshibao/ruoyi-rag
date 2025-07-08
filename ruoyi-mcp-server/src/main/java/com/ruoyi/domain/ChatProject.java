package com.ruoyi.domain;

import lombok.Data;
import lombok.ToString;

/**
 * 项目配置对象 chat_project
 * 
 * @author zhaoshibao
 * @date 2025-07-08
 */
@Data
@ToString
public class ChatProject {
    private static final long serialVersionUID = 1L;

    /** 项目主键 */
    private String projectId;

    /** 项目名称 */
    private String projectName;

    /** 模型类型：ollama、openai */
    private String type;



    /** 具体模型：qwen2:7B、gpt-3.5-turbo */
    private String model;


    /** 具嵌入模型 */
    private String embeddingModel;


    /** baseUrl */
    private String baseUrl;



    /** 系统提示词 */
    private String systemPrompt;



    /** 是否开启pdf增强解析 */
    private Integer isPdfAnalysis;







}
