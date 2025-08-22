package com.ruoyi.service;

import com.alibaba.cloud.ai.dashscope.chat.DashScopeChatOptions;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.client.advisor.SimpleLoggerAdvisor;
import org.springframework.ai.chat.model.ChatModel;
import org.springframework.ai.chat.prompt.PromptTemplate;
import org.springframework.ai.document.Document;
import org.springframework.ai.image.ImageMessage;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.reader.tika.TikaDocumentReader;
import org.springframework.ai.zhipuai.ZhiPuAiChatModel;
import org.springframework.ai.zhipuai.ZhiPuAiImageModel;
import org.springframework.ai.zhipuai.ZhiPuAiImageOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * 图片服务
 */
@Service
@Slf4j
public class DocsSummaryService {
    private final ChatClient chatClient;

    public DocsSummaryService(SimpleLoggerAdvisor simpleLoggerAdvisor,
                              MessageChatMemoryAdvisor messageChatMemoryAdvisor,
                              @Qualifier("dashscopeChatModel") ChatModel chatModel,
                              @Qualifier("summarizerPromptTemplate") PromptTemplate docsSummaryPromptTemplate) {
        this.chatClient = ChatClient.builder(chatModel)
                .defaultOptions(
                        DashScopeChatOptions.builder().withModel("deepseek-r1").build()
                ).defaultSystem(
                        docsSummaryPromptTemplate.getTemplate()
                ).defaultAdvisors(
                        messageChatMemoryAdvisor,
                        simpleLoggerAdvisor
                ).build();
    }

    /**
     * Docs Summary not has chat memory.
     */
    public Flux<String> summary(MultipartFile file, String url) {

        String text = getText(url, file);
        if (!StringUtils.hasText(text)) {
            return Flux.error(new IllegalArgumentException("Invalid file content"));
        }

        return chatClient.prompt()
                .user("Summarize the document")
                .user(text)
                .stream().content();
    }
    private String getText(String url, MultipartFile file) {

        if (Objects.nonNull(file)) {

            log.debug("Reading file content form MultipartFile");
            List<Document> documents = new TikaDocumentReader(file.getResource()).get();
            return documents.stream()
                    .map(Document::getFormattedContent)
                    .collect(Collectors.joining("\n\n"));
        }

        if (StringUtils.hasText(url)) {
            log.debug("Reading file content form url");
            List<Document> documents = new TikaDocumentReader(url).get();
            return documents.stream()
                    .map(Document::getFormattedContent)
                    .collect(Collectors.joining("\n\n"));
        }

        return "";
    }


}
