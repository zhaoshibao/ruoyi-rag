package com.ruoyi.enums;

/**
 * 消息类型枚举
 */
public enum MessageTypeEnum {
    /**
     * 用户的提问
     */
    USER(0, "用户的提问"),
    /**
     * 用户的提问
     */
    AI(1, "AI大模型的回答内容"),

    ;
    private Integer type;
    private String desc;

    MessageTypeEnum(Integer type, String desc) {
        this.type = type;
        this.desc = desc;
    }

    public Integer getType() {
        return type;
    }
}
