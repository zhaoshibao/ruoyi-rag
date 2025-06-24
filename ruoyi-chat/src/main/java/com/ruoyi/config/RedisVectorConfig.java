//package com.atguigu.ai.config;
//
//import org.springframework.ai.ollama.OllamaEmbeddingModel;
//import org.springframework.ai.ollama.api.OllamaApi;
//import org.springframework.ai.ollama.api.OllamaOptions;
//import org.springframework.ai.openai.OpenAiEmbeddingModel;
//import org.springframework.ai.openai.api.OpenAiApi;
//import org.springframework.ai.vectorstore.RedisVectorStore;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//@Configuration
//public class RedisVectorStoreConfig {
//
//    @Bean
//    public RedisVectorStore.RedisVectorStoreConfig ollamaRedisVectorStoreConfig(){
//        return RedisVectorStore.RedisVectorStoreConfig.builder()
//                .withURI("redis://localhost:7379")
//                .withIndexName("ollama-qwen2-index")
//                .withPrefix("ollama:qwen2:")
//                .withMetadataFields(
//                        RedisVectorStore.MetadataField.numeric("projectId") // 用于区分不同用户
//                )
//                .build();
//    }
//
//    @Bean
//    public RedisVectorStore.RedisVectorStoreConfig openaiRedisVectorStoreConfig(){
//        return RedisVectorStore.RedisVectorStoreConfig.builder()
//                .withURI("redis://localhost:7379")
//                .withIndexName("openai-gpt3-index")
//                .withPrefix("openai:gpt3:")
//                .withMetadataFields(
//                        RedisVectorStore.MetadataField.numeric("projectId") // 用于区分不同用户
//                )
//                .build();
//    }
//
//    /**
//     * 使用参数注入的方式，打包后在服务器上运行报错：
//     * Parameter 0 of method ollamaRedisVectorStore in com.atguigu.ai.config.VectorStoreConfig required a single bean, but 2 were found:
//     *         - ollamaRedisVectorStoreConfig: defined by method 'ollamaRedisVectorStoreConfig' in class path resource [com/atguigu/ai/config/VectorStoreConfig.class]
//     *         - openaiRedisVectorStoreConfig: defined by method 'openaiRedisVectorStoreConfig' in class path resource [com/atguigu/ai/config/VectorStoreConfig.class]
//     *
//     * This may be due to missing parameter name information
//     * @return
//     */
//    @Bean
////    public RedisVectorStore ollamaRedisVectorStore(RedisVectorStore.RedisVectorStoreConfig ollamaRedisVectorStoreConfig){
//    public RedisVectorStore ollamaRedisVectorStore(){
//        return new RedisVectorStore(
////                ollamaRedisVectorStoreConfig,
//                ollamaRedisVectorStoreConfig(),
//                new OllamaEmbeddingModel(new OllamaApi(), OllamaOptions.create().withModel("qwen2:7b")),
//                true
//        );
//    }
//
//    @Bean
////    public RedisVectorStore openaiRedisVectorStore(RedisVectorStore.RedisVectorStoreConfig openaiRedisVectorStoreConfig){
//    public RedisVectorStore openaiRedisVectorStore(){
//        return new RedisVectorStore(
////                openaiRedisVectorStoreConfig,
//                openaiRedisVectorStoreConfig(),
//                new OpenAiEmbeddingModel(new OpenAiApi("https://api.xty.app", "sk-XFlTUCxg0iez1QRxF400926fAcF64dBbA387232fCeF63e76")),
//                true
//        );
//    }
//
//}
