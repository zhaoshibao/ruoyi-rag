package com.ruoyi.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class MessageVo {

    @Schema(description = "聊天历史id")
    @NotNull
    private Long chatId;

    @Schema(description = "具体内容")
    @NotNull
    private String content;
}
