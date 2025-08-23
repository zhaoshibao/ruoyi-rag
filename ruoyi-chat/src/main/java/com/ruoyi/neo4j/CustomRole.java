//package com.ruoyi.neo4j;
//
//import lombok.Data;
//import org.springframework.data.neo4j.core.schema.GeneratedValue;
//import org.springframework.data.neo4j.core.schema.Id;
//import org.springframework.data.neo4j.core.schema.Node;
//import org.springframework.data.neo4j.core.schema.Relationship;
//import org.springframework.data.neo4j.core.support.UUIDStringGenerator;
//
//import java.util.Set;
//
//@Node
//@Data
//public class CustomRole {
//    @Id
//    @GeneratedValue(generatorClass = UUIDStringGenerator.class)
//    private String id;
//
//    private String name;
//    private String description;
//    private String knowledgeId; // 知识库ID，用于数据隔离
//    private String projectId; // 项目ID，用于数据隔离
//
//    @Relationship(type = "RELATES_TO")
//    private Set<CustomRelationship> relationships = new java.util.HashSet<>();
//
//}
