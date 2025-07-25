package com.ruoyi.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.ollama.OllamaChatModel;
import org.springframework.ai.ollama.api.OllamaApi;
import org.springframework.ai.ollama.api.OllamaOptions;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.ai.openai.OpenAiChatOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.ai.tool.ToolCallback;
import org.springframework.ai.transformers.TransformersEmbeddingModel;
import org.springframework.ai.zhipuai.ZhiPuAiChatModel;
import org.springframework.ai.zhipuai.ZhiPuAiChatOptions;
import org.springframework.ai.zhipuai.api.ZhiPuAiApi;

import java.util.Map;

/**
 * 工具类，用于获取嵌入式模型
 */
@Slf4j
public class EmbeddingModelUtil {
    /**
     * 获取本地嵌入式模型
     * @return
     * @throws Exception
     */
   public static TransformersEmbeddingModel getLocalEmbeddingModel() throws Exception {
       TransformersEmbeddingModel embeddingModel = new TransformersEmbeddingModel();
       // 设置tokenizer文件路径
       embeddingModel.setTokenizerResource("classpath:/onnx/bge-small-zh-v1.5/tokenizer.json");
       // 设置Onnx模型文件路径
       embeddingModel.setModelResource("classpath:/onnx/bge-small-zh-v1.5/model.onnx");
       // 缓存位置
       embeddingModel.setResourceCacheDirectory("/tmp/onnx-cache");
       // 自动填充
       embeddingModel.setTokenizerOptions(Map.of("padding", "true"));
       // 模型输出层的名称，默认是 last_hidden_state, 需要根据所选模型设置
       embeddingModel.setModelOutputName("token_embeddings");
       embeddingModel.afterPropertiesSet();
       return embeddingModel;
   }


}
