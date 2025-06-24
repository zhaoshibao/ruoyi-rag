package com.ruoyi.enums;

public enum AiTypeEnum {
    OPENAI("openai", "openai"),
    OLLAMA("ollama", "ollama"),
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
