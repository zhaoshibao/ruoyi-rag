package com.ruoyi.pojo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;

@Data
@Document
public class Message {

    @Id
    private Long id;

    @Schema(description = "聊天历史id")
    private Long chatId;

    @Schema(description = "问答类型：0-用户的提问  1-AI大模型的回答内容")
    private Integer type;

    @Schema(description = "具体内容")
    private String content;

    @Schema(description = "问答时间")
    private Date createTime;
}
