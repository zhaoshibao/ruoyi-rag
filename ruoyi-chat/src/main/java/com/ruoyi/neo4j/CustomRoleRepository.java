package com.ruoyi.neo4j;

import org.springframework.data.neo4j.repository.Neo4jRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoleRepository extends Neo4jRepository<Role, Long> {
    List<Role> findByProjectId(String projectId);
    List<Role> findByNameContainingAndProjectId(String name, String projectId);
}