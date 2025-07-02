package com.ruoyi.neo4j;

import lombok.Data;
import org.springframework.data.neo4j.core.schema.GeneratedValue;
import org.springframework.data.neo4j.core.schema.Id;
import org.springframework.data.neo4j.core.schema.Node;
import org.springframework.data.neo4j.core.schema.Relationship;

import java.util.Set;

@Node
@Data
public class Role {
    @Id
    @GeneratedValue
    private Long id;

    private String name;
    private String description;
    private String projectId; // 项目ID，用于数据隔离

    @Relationship(type = "RELATES_TO")
    private Set<Relationship> relationships;

}
