package com.ruoyi;

import com.ruoyi.tool.ChatProjectTool;
import com.ruoyi.tool.DateTool;
import com.ruoyi.tool.EmailTool;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.context.annotation.Bean;


@MapperScan("com.ruoyi.mapper")
@SpringBootApplication
public class RuoyiMcpServerApplication {

    public static void main(String[] args) {
        SpringApplication.run(RuoyiMcpServerApplication.class, args);
    }


    /**
     * 注册MCP工具
     */
    @Bean
    public ToolCallbackProvider registMCPTools(DateTool dateTool, EmailTool emailTool, ChatProjectTool chatProjectTool) {
        return MethodToolCallbackProvider.builder()
                .toolObjects(dateTool, emailTool, chatProjectTool)
                .build();
    }

}
