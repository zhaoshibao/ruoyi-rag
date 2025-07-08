package com.ruoyi;

import com.ruoyi.mcp.tool.ChatProjectTool;
import com.ruoyi.mcp.tool.DateTool;
import com.ruoyi.mcp.tool.EmailTool;
import io.github.cdimascio.dotenv.Dotenv;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.ai.tool.ToolCallbackProvider;
import org.springframework.ai.tool.method.MethodToolCallbackProvider;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;


@MapperScan("com.ruoyi.mcp.mapper")
@SpringBootApplication
public class RuoyiMcpServerApplication {

    public static void main(String[] args) {
        // 加载.env文件
        Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();
        // 把.env文件中的变量设置到环境变量中
        dotenv.entries().forEach(entry -> System.setProperty(entry.getKey(), entry.getValue()));
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
