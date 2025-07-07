package com.ruoyi.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.ai.ollama.api.OllamaApi;
import org.springframework.ai.ollama.api.OllamaOptions;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;

/**
 * 工具类，用于获取聊天模型
 */
@Slf4j
public class ChatModelUtil {
    /**
     * 获取OpenAI聊天模型
     * @param baseUrl
     * @param apiKey
     * @param model
     * @return
     */
    public static OpenAiChatModel getOpenAiChatModel(String baseUrl, String apiKey, String model) {
        var openAiApi = OpenAiApi.builder()
                .baseUrl(baseUrl)
                .apiKey(apiKey)
                .build();
        var openAiChatOptions = OpenAiChatOptions.builder()
                .model(model)
                .temperature(0.4)
                .maxTokens(200)
                .build();

       return  OpenAiChatModel.builder().openAiApi(openAiApi).defaultOptions(openAiChatOptions).build();
        //return  new OpenAiChatModel(openAiApi, openAiChatOptions);
    }


    /**
     * 获取Ollama聊天模型
     * @param baseUrl
     * @param model
     * @return
     */
    public static OllamaChatModel getOllamaChatModel(String baseUrl, String model) {
        //var ollamaApi = new OllamaApi(baseUrl);
        var ollamaApi = OllamaApi.builder().baseUrl(baseUrl).build();
        return  OllamaChatModel.builder()
                .ollamaApi(ollamaApi)
                .defaultOptions(
                        OllamaOptions.builder()
                                .model(model)
                                .temperature(0.4)
                                .build())
                .build();
    }

}
