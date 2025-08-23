package com.ruoyi.component;

import com.ruoyi.enums.SystemConstant;
import com.ruoyi.utils.EmbeddingModelUtil;
import io.qdrant.client.QdrantClient;
import io.qdrant.client.grpc.Collections;
import org.springframework.ai.document.MetadataMode;
import org.springframework.ai.ollama.OllamaEmbeddingModel;
import org.springframework.ai.ollama.api.OllamaApi;
import org.springframework.ai.ollama.api.OllamaOptions;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.ai.openai.OpenAiEmbeddingOptions;
import org.springframework.ai.openai.api.OpenAiApi;
import org.springframework.ai.retry.RetryUtils;
import org.springframework.ai.transformers.TransformersEmbeddingModel;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.ai.vectorstore.qdrant.autoconfigure.QdrantVectorStoreProperties;
import org.springframework.ai.zhipuai.ZhiPuAiEmbeddingModel;
import org.springframework.ai.zhipuai.ZhiPuAiEmbeddingOptions;
import org.springframework.ai.zhipuai.api.ZhiPuAiApi;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * Qdrant向量存储组件
 */
@Component
public class QdrantVectorStoreComponet {

    @Autowired
    private QdrantClient qdrantClient;

    @Autowired
    private QdrantVectorStoreProperties properties;
    /**
     * 获取Ollama Qdrant向量存储组件
     * @param baseUrl
     * @param embeddingmodel
     * @return
     * @throws Exception
     */
    public QdrantVectorStore getOllamaQdrantVectorStore (String baseUrl, String embeddingmodel ) throws Exception {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.OLLAMA_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.OLLAMA_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine)
                            .setSize(512)
                            .build()).get();
        }
//       var ollamaApi = OllamaApi.builder().baseUrl(baseUrl).build();
//        var embeddingModel = OllamaEmbeddingModel.builder()
//                .ollamaApi(ollamaApi).defaultOptions(
//                OllamaOptions.builder().model(embeddingmodel).build()).build();

        TransformersEmbeddingModel localEmbeddingModel = EmbeddingModelUtil.getLocalEmbeddingModel();
        return QdrantVectorStore.builder(qdrantClient,localEmbeddingModel)
                .collectionName(SystemConstant.OLLAMA_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }

    /**
     * 获取OpenAi Qdrant向量存储组件
     * @param baseUrl
     * @param apiKey
     * @param embeddingmodel
     * @return
     * @throws Exception
     */
    public QdrantVectorStore getOpenAiQdrantVectorStore(String baseUrl, String apiKey, String embeddingmodel) throws Exception  {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.OPENAI_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.OPENAI_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine)
                            .setSize(512)
                            .build()).get();
        }
//        var openAiApi = OpenAiApi.builder()
//                .baseUrl(baseUrl)
//                .apiKey(apiKey)
//                .build();

//        var embeddingModel = new OpenAiEmbeddingModel(
//                openAiApi,
//                MetadataMode.EMBED,
//                OpenAiEmbeddingOptions.builder()
//                        .model(embeddingmodel)
//                        .build(),
//                RetryUtils.DEFAULT_RETRY_TEMPLATE);

        TransformersEmbeddingModel localEmbeddingModel = EmbeddingModelUtil.getLocalEmbeddingModel();
        return QdrantVectorStore.builder(qdrantClient,localEmbeddingModel)
                .collectionName(SystemConstant.OPENAI_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }



    /**
     * 获取智普AI 向量存储组件
     * @param baseUrl
     * @param embeddingmodel
     * @return
     * @throws Exception
     */
    public QdrantVectorStore getZhiPuAiQdrantVectorStore (String baseUrl, String apiKey, String embeddingmodel) throws Exception {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.ZHIPUAI_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.ZHIPUAI_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine)
                            .setSize(512)
                            .build()).get();
        }
//        var zhiPuAiApi = new ZhiPuAiApi(baseUrl,apiKey);
//
//        var embeddingModel = new ZhiPuAiEmbeddingModel(
//                zhiPuAiApi,
//                MetadataMode.EMBED,
//                ZhiPuAiEmbeddingOptions.builder()
//                        .model(embeddingmodel)
//                        .build(),
//                RetryUtils.DEFAULT_RETRY_TEMPLATE);
        TransformersEmbeddingModel localEmbeddingModel = EmbeddingModelUtil.getLocalEmbeddingModel();
        return QdrantVectorStore.builder(qdrantClient,localEmbeddingModel)
                .collectionName(SystemConstant.ZHIPUAI_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }

    /**
     * 获取阿里百炼 向量存储组件
     * @param baseUrl
     * @param embeddingmodel
     * @return
     * @throws Exception
     */
    public QdrantVectorStore getDashScopeQdrantVectorStore (String baseUrl, String apiKey, String embeddingmodel) throws Exception {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.DASHSCOPE_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.DASHSCOPE_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine)
                            .setSize(512)
                            .build()).get();
        }
        TransformersEmbeddingModel localEmbeddingModel = EmbeddingModelUtil.getLocalEmbeddingModel();
        return QdrantVectorStore.builder(qdrantClient,localEmbeddingModel)
                .collectionName(SystemConstant.DASHSCOPE_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }

}
