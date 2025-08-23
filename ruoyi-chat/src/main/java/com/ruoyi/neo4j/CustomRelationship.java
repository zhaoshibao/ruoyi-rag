//package com.ruoyi.neo4j;
//
//import lombok.Data;
//import lombok.EqualsAndHashCode;
//import lombok.ToString;
//import org.springframework.data.neo4j.core.schema.*;
//import org.springframework.data.neo4j.core.support.UUIDStringGenerator;
//
//@RelationshipProperties
//@Data
//@ToString(exclude = "target")
//@EqualsAndHashCode(exclude = "target")
//public class CustomRelationship {
//    @Id
//    @GeneratedValue
//    private Long id;
//
//    @TargetNode
//    private CustomRole target;
//
//    private String relationshipType;
//    private String description;
//}
