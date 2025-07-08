package com.ruoyi.mcp.tool;

import com.vladsch.flexmark.html.HtmlRenderer;
import com.vladsch.flexmark.parser.Parser;
import com.vladsch.flexmark.util.data.MutableDataSet;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.tool.annotation.Tool;
import org.springframework.ai.tool.annotation.ToolParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Component;

/**
 * @ClassName DateTool
 * @Author zhaoshibao
 * @Version 1.0
 * @Description DateTool
 **/
@Component
@Slf4j
public class EmailTool {

    private final JavaMailSender mailSender;
    private final String from;

    @Autowired
    public EmailTool(JavaMailSender mailSender, @Value("${spring.mail.username}") String from) {
        this.mailSender = mailSender;
        this.from = from;
    }

    @Data
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EmailRequest {
        @ToolParam(description = "收件人邮箱")
        private String email;
        @ToolParam(description = "发送邮件的标题/主题")
        private String subject;
        @ToolParam(description = "发送邮件的消息/正文内容")
        private String message;

        @ToolParam(description = "邮件的内容是否为html还是markdown格式，如果是markdown格式，则为1；如果是html格式，则为2")
        private Integer contentType;
    }

    @Tool(description = "查询我的邮件/邮箱地址")
    public String getMyEmailAddress() {
        log.info("========== 调用MCP工具：getMyEmailAddress() ==========");
        return "testxd2025@163.com";
    }

    @Tool(description = "给指定邮箱发送邮件信息，email 为收件人邮箱，subject 为邮件标题，message 为邮件的内容")
    public void sendMailMessage(EmailRequest emailRequest) {

        log.info("========== 调用MCP工具：sendMailMessage() ==========");
        log.info(String.format("========== 参数 emailRequest：%s ==========", emailRequest.toString()));

        Integer contentType = emailRequest.getContentType();

        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage);

            helper.setFrom(from);
            helper.setTo(emailRequest.getEmail());
            helper.setSubject(emailRequest.getSubject());

            if (contentType == 1) {
                helper.setText(convertToHtml(emailRequest.getMessage()), true);
            } else if (contentType == 2) {
                helper.setText(emailRequest.getMessage(), true);
            } else {
                helper.setText(emailRequest.getMessage());
            }

            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
//            throw new RuntimeException(e);
            log.error("========== 发送邮件失败，报错信息：{} ==========", e.getMessage());
        }
    }

    /**
     * markdown 转 html
     * @param markdownStr
     * @return
     */
    public static String convertToHtml(String markdownStr) {

        MutableDataSet dataSet = new MutableDataSet();
        Parser parser = Parser.builder(dataSet).build();
        HtmlRenderer htmlRenderer = HtmlRenderer.builder(dataSet).build();

        return htmlRenderer.render(parser.parse(markdownStr));
    }

}
