package com.ruoyi.tool;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.mapper.ChatProjectMapper;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.util.List;

/**
 * @ClassName ChatProjectTool
 * @Author zhaoshibao
 * @Version 1.0
 * @Description DateTool
 **/
@Component
@Slf4j
public class ChatProjectTool {

    @Autowired
    private ChatProjectMapper chatProjectMapper;

    @Data
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CreateChatProjectRequest {
        @ToolParam(description = "项目名称",required = false)
        private String projectName;
    }


    @Tool(description = "根据条件查询项目信息")
    public List<ChatProject> queryChatProjectByCondition(CreateChatProjectRequest createProductRequest) {

        log.info("========== 调用MCP工具：queryChatProjectByCondition() ==========");
        log.info(String.format("| 参数 createProductRequest 为： %s", createProductRequest.toString()));
        log.info("========== End ==========");
        String projectName = createProductRequest.getProjectName();

        return chatProjectMapper.selectList(Wrappers.<ChatProject>lambdaQuery()
                .like(StringUtils.hasLength(projectName),ChatProject::getProjectName, projectName));
    }



}
