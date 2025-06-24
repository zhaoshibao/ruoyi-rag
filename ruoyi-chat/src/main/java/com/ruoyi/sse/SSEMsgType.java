package com.ruoyi.sse;

/**
 * @Description: 发送SSE的消息类型
 * @Author 风间影月
 */
public enum SSEMsgType {

    MESSAGE("message", "单次发送的普通消息"),
    ADD("add", "消息追加，用于流式stream推送"),
    FINISH("finish", "消息完成"),
    CUSTOM_EVENT("customEvent", "自定义消息的类型"),
    DONE("done", "消息完成");

    public final String type;
    public final String value;

    SSEMsgType(String type, String value) {
        this.type = type;
        this.value = value;
    }

}
