/*
package com.ruoyi.config;

import com.ruoyi.enums.SystemConstant;
import io.qdrant.client.QdrantClient;
import io.qdrant.client.grpc.Collections;
import org.springframework.ai.ollama.OllamaEmbeddingModel;
import org.springframework.ai.openai.OpenAiEmbeddingModel;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.ai.vectorstore.qdrant.autoconfigure.QdrantVectorStoreProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.concurrent.ExecutionException;

@Configuration
public class QdrantVectorConfig {



    @Autowired
    private QdrantVectorStoreProperties properties;

    @Bean
    public QdrantVectorStore openAiQdrantVectorStore(
            QdrantClient qdrantClient, OpenAiEmbeddingModel openAiEmbeddingModel
    ) throws ExecutionException, InterruptedException {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.OPENAI_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.OPENAI_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine).setSize(1536).build()).get();
        }
//        return new QdrantVectorStore(
//                qdrantClient,
//                SystemConstant.OPENAI_GPT3_QDRANT,
//                openAiEmbeddingModel,
//                properties.isInitializeSchema()
//        );
        return QdrantVectorStore.builder(qdrantClient,openAiEmbeddingModel)
                .collectionName(SystemConstant.OPENAI_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }

    @Bean
    public QdrantVectorStore ollamaQdrantVectorStore(
            QdrantClient qdrantClient, OllamaEmbeddingModel ollamaEmbeddingModel
    ) throws ExecutionException, InterruptedException {
        if (!qdrantClient.collectionExistsAsync(SystemConstant.OLLAMA_QDRANT).get()) {
            qdrantClient.createCollectionAsync(SystemConstant.OLLAMA_QDRANT,
                    Collections.VectorParams.newBuilder()
                            .setDistance(Collections.Distance.Cosine)
                            .setSize(1024)
                     .build()).get();
        }
//        return new QdrantVectorStore(
//                qdrantClient,
//                SystemConstant.OLLAMA_QWEN2_QDRANT,
//                ollamaEmbeddingModel,
//                properties.isInitializeSchema()
//        );
        return QdrantVectorStore.builder(qdrantClient,ollamaEmbeddingModel)
                .collectionName(SystemConstant.OLLAMA_QDRANT)
                .initializeSchema(properties.isInitializeSchema())
                .build();
    }

}
*/
