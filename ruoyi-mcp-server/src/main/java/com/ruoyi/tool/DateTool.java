package com.ruoyi.tool;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;

/**
 * @ClassName DateTool
 * @Author zhaoshibao
 * @Version 1.0
 * @Description DateTool
 **/
@Component
@Slf4j
public class DateTool {

    @Tool(description = "根据城市所在的时区id来获得当前的时间")
    public String getCurrentTimeByZoneId(String cityName, String zoneId) {

        log.info("========== 调用MCP工具：getCurrentTimeByZoneId() ==========");
        log.info(String.format("========== 参数 cityName：%s ==========", cityName));
        log.info(String.format("========== 参数 zoneId：%s ==========", zoneId));

        ZoneId zone = ZoneId.of(zoneId);

        // 获取该时区对应的当前时间
        ZonedDateTime zonedDateTime = ZonedDateTime.now(zone);
        String currentTime = String.format("当前的时间是 %s",
                zonedDateTime.format(
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        return currentTime;
    }

    @Tool(description = "获得当前时间")
    public String getCurrentTime() {

        log.info("========== 调用MCP工具：getCurrentTime() ==========");

        String currentTime = String.format("当前的时间是 %s",
                LocalDateTime.now().format(
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        return currentTime;
    }

}
