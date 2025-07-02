package com.ruoyi.neo4j;

import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.RelationshipProperties;
import org.springframework.data.neo4j.core.schema.TargetNode;

@RelationshipProperties
public class Relationship {
    @Id
    @GeneratedValue
    private Long id;

    @TargetNode
    private Role target;

    private String relationshipType;
    private String description;
}
