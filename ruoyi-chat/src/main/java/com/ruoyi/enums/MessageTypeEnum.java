package com.ruoyi.enums;

public enum AiTypeEnum {
    /**
     * openai
     */
    OPENAI("openai", "openai"),
    /**
     * ollama
     */
    OLLAMA("ollama", "ollama"),
    /**
     * 智谱ai
     */
    ZHIPUAI("zhipuai", "zhipuai"),

    /**
     * 阿里百炼
     */
    DASHSCOPE("dashscope", "dashscope"),



    ;
    private String type;
    private String desc;

    AiTypeEnum(String type, String desc) {
        this.type = type;
        this.desc = desc;
    }

    public String getType() {
        return type;
    }
}
