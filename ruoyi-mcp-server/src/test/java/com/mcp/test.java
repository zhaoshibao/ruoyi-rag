package com.mcp;

import com.ruoyi.RuoyiMcpServerApplication;
import com.ruoyi.mcp.mapper.ChatProjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

/**
 * @ClassName test
 * @Author zhaoshibao
 * @Version 1.0
 * @Description DateTool
 **/
@SpringBootTest(classes = RuoyiMcpServerApplication.class)
public class test {

    @Autowired
    private ChatProjectMapper chatProjectMapper;

    @org.junit.jupiter.api.Test
    public void test() {
        System.out.println(chatProjectMapper.selectById("121abc"));
    }
}
