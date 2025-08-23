//package com.ruoyi.neo4j;
//
//import org.springframework.data.neo4j.repository.Neo4jRepository;
//import org.springframework.data.neo4j.repository.query.Query;
//import org.springframework.stereotype.Repository;
//
//import java.util.List;
//
//@Repository
//public interface CustomRoleRepository extends Neo4jRepository<CustomRole, String> {
//    /**
//     * 根据项目ID查找角色及其关系
//     */
//    @Query("""
//        MATCH (c:CustomRole) WHERE c.projectId = $projectId
//        OPTIONAL MATCH (c)-[r:RELATES_TO]->(t:CustomRole)
//        RETURN c, collect(r), collect(t)
//    """)
//    List<CustomRole> findByProjectId(String projectId);
//
//    /**
//     * 根据名称和项目ID查找角色及其关系
//     */
//    @Query("""
//        MATCH (c:CustomRole)
//        WHERE c.name CONTAINS $name AND c.projectId = $projectId
//        OPTIONAL MATCH (c)-[r:RELATES_TO]->(t:CustomRole)
//        RETURN c, collect(r), collect(t)
//    """)
//    List<CustomRole> findByNameContainingAndProjectId(String name, String projectId);
//
//    /**
//     * 根据名称和项目ID查找角色及其关系(分别展示主动关系和被动关系)
//     * 使用无向关系模式 (c)-[r:RELATES_TO]-(other)同时获取入向和出向关系
//     * 主动关系：该角色指向其他角色的关系
//     *  被动关系：其他角色指向该角色的关系
//     */
//    @Query("""
//        MATCH (c:CustomRole)
//        WHERE c.name CONTAINS $name AND c.projectId = $projectId
//        OPTIONAL MATCH (c)-[r:RELATES_TO]-(other:CustomRole)
//        RETURN c, collect(r), collect(other)
//    """)
//    List<CustomRole> findRelationshipsByNameAndProjectId(String name, String projectId);
//
//    /**
//     * 根据项目ID和知识库ID查找所有角色及其关系
//     */
//    @Query("""
//        MATCH (c:CustomRole)
//        WHERE c.projectId = $projectId AND c.knowledgeId IN $knowledgeIds
//        OPTIONAL MATCH (c)-[r:RELATES_TO]-(other:CustomRole)
//        RETURN c, collect(r), collect(other)
//    """)
//    List<CustomRole> findAllByProjectIdAndKnowledgeIds(String projectId, List<String> knowledgeIds);
//}