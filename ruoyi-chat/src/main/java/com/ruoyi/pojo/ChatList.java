package com.ruoyi.pojo;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.data.annotation.Id;

import java.util.Date;

@Data
public class ChatVo {

    @Schema(description = "聊天历史id")
    private String chatId;

    @Schema(description = "项目id")
    private String projectId;

    @Schema(description = "用户在该项目中的唯一标识")
    private Long userId;

    @Schema(description = "聊天历史标题")
    private String title;

    @Schema(description = "聊天历史创建时间")
    private Date createTime;
}
