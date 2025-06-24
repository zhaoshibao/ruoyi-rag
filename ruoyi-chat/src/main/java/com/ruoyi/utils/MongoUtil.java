package com.ruoyi.utils;

import lombok.Data;
import org.springframework.stereotype.Component;

@Data
@Component
public class MongoUtil {

    private static final int partition = 100;

    /**
     * 聊天集合
     * @param projectId 项目id
     * @return
     */
    public static String getChatCollection(String projectId) {
        return "ruoyi_chat_" + projectId;
    }

    /**
     * 问答集合
     * @param chatId 聊天id
     * @return
     */
    public static String getMessageCollection(Long chatId) {
        return "ruoyi_msg_" + chatId % partition;
    }
}

