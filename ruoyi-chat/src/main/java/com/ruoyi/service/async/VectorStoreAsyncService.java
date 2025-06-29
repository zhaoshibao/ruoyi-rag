package com.ruoyi.service.async;

import com.ruoyi.domain.ChatKnowledge;
import com.ruoyi.domain.ChatProject;
import com.ruoyi.service.IChatKnowledgeService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.document.Document;
import org.springframework.ai.vectorstore.filter.FilterExpressionBuilder;
import org.springframework.ai.vectorstore.qdrant.QdrantVectorStore;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 异步处理向量存储
 */
@Service
@Slf4j
public class VectorStoreAsyncService {

    @Autowired
    IChatKnowledgeService chatKnowledgeService;

    /**
     * 异步执行根据knowledgeId删除向量存储
     * @param qdrantVectorStore
     * @param knowledgeId
     * @throws Exception
     */
    @Async
    public void removeByknowledgeId(QdrantVectorStore qdrantVectorStore,String knowledgeId) throws Exception {
        qdrantVectorStore.delete(
                new FilterExpressionBuilder().eq("knowledgeId", knowledgeId).build()
        );
        log.info("异步执行根据knowledgeId删除向量存储成功");

    }

    /**
     * 异步执行新增向量存储
     * @param qdrantVectorStore
     * @param documentList
     * @throws Exception
     */
    @Async
    public void addVectorStore(String knowledgeId,QdrantVectorStore qdrantVectorStore, List<Document> documentList) throws Exception {
        qdrantVectorStore.add(documentList);
        ChatKnowledge chatKnowledge = new ChatKnowledge();
        chatKnowledge.setKnowledgeId(knowledgeId);
        chatKnowledge.setIsVector(1);
        chatKnowledgeService.updateChatKnowledge(chatKnowledge);
        log.info("异步执行新增向量存储成功");
    }
}
