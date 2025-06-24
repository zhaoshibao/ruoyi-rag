package com.ruoyi.vo;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class QueryVo {


//    @Schema(name = "user", description = "用户的唯一标识，用户首次进入系统页面时生成一个唯一标识")
//    private String user = SystemConfig.ADMIN; // 用户的唯一标识：如果是普通用户进入系统时，暂时随机分配一个唯一标识；如果是管理员则是admin

    @Schema(name = "projectId", description = "项目id，不同项目不同本地知识库")
    @NotNull
    private String projectId;

    @Schema(name = "chatId", description = "聊天记录id，如果该id为null则不会保存会话的历史记录")
    private Long chatId;

    @Schema(name = "language", description = "语言：英文(1)、中文(0)，文件上传删除时不需要该参数")
    @NotNull
    private Integer language = 0;

    @Schema(name = "msg", description = "用户的提问内容，文件上传删除时不需要该参数")
    @NotNull
    private String msg;


    @Schema(description = "用户id")
    private Long userId;

    @Schema(description = "是否联网查询")
    private Boolean useWebSearch;


}
