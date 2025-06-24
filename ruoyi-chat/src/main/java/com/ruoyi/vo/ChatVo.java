package com.ruoyi.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class ChatVo {

    @Schema(description = "会话id，更新会话标题时，需要该字段")
    private Long chatId;

    @Schema(description = "项目id")
    @NotNull
    private String projectId;

    @Schema(description = "用户id，新增会话时需要该字段，更新会话标题可以不传")
    private Long userId;

    @NotNull
    @Schema(description = "会话标题")
    private String title;
}
