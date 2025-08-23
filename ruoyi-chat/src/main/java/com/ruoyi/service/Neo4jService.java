//package com.ruoyi.service;
//
//import com.ruoyi.neo4j.CustomRelationship;
//import com.ruoyi.neo4j.CustomRole;
//import com.ruoyi.neo4j.CustomRoleRepository;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.BufferedReader;
//import java.io.IOException;
//import java.io.InputStreamReader;
//import java.util.ArrayList;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//
//@Service
//public class Neo4jService {
//
//    @Autowired
//    private CustomRoleRepository roleRepository;
//
//    public void processCsvFile(MultipartFile file, String projectId,String knowledgeId) throws IOException {
//        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()))) {
//            String line;
//            // 跳过标题行
//            reader.readLine();
//
//            while ((line = reader.readLine()) != null) {
//                String[] data = line.split(",");
//                // 假设CSV格式：源角色,关系类型,目标角色,描述
//                createRelationship(data[0], data[1], data[2], data[3], projectId,knowledgeId);
//            }
//        }
//    }
//
//    private void createRelationship(String sourceName, String relationType,
//                                    String targetName, String description, String projectId,String knowledgeId) {
//        // 先查找source角色，如果不存在则创建
//        CustomRole source = roleRepository.findByNameContainingAndProjectId(sourceName, projectId)
//                .stream()
//                .findFirst()  // 获取第一个匹配的结果
//                .orElseGet(() -> {
//                    CustomRole c = new CustomRole();
//                    c.setName(sourceName);
//                    c.setProjectId(projectId);
//                    c.setKnowledgeId(knowledgeId);
//                    return roleRepository.save(c);
//                });
//        // 先查找target角色，如果不存在则创建
//        CustomRole target = roleRepository.findByNameContainingAndProjectId(targetName, projectId)
//                .stream()
//                .findFirst()  // 获取第一个匹配的结果
//                .orElseGet(() -> {
//                    CustomRole c = new CustomRole();
//                    c.setName(targetName);
//                    c.setProjectId(projectId);
//                    c.setKnowledgeId(knowledgeId);
//                    return roleRepository.save(c);
//                });
//        // 创建关系
//        CustomRelationship relationship = new CustomRelationship();
//        relationship.setTarget(target);
//        relationship.setRelationshipType(relationType);
//        relationship.setDescription(description);
//        // 添加关系并保存
//        source.getRelationships().add(relationship);
//        roleRepository.save(source);
//    }
//
//    public Map<String, Object> getGraphData(String projectId) {
//        List<CustomRole> characters = roleRepository.findByProjectId(projectId);
//        return convertToGraphData(characters);
//    }
//
//    public Map<String, Object> search(String keyword, String projectId) {
//        List<CustomRole> characters = roleRepository.findByNameContainingAndProjectId(keyword, projectId);
//        return convertToGraphData(characters);
//    }
//
//    private Map<String, Object> convertToGraphData(List<CustomRole> customRoleList) {
//        List<Map<String, Object>> nodes = new ArrayList<>();
//        List<Map<String, Object>> edges = new ArrayList<>();
//
//        for (CustomRole role : customRoleList) {
//            nodes.add(Map.of(
//                    "id", role.getId(),
//                    "label", role.getName()
//            ));
//
//            for (CustomRelationship rel : role.getRelationships()) {
//                edges.add(Map.of(
//                        "from", role.getId(),
//                        "to", rel.getTarget().getId(),
//                        "label", rel.getRelationshipType()
//                ));
//            }
//        }
//
//        return Map.of("nodes", nodes, "edges", edges);
//    }
//
//    public String getContextForLLM(String keyword, String projectId) {
//        List<CustomRole> customRoleList = roleRepository.findRelationshipsByNameAndProjectId(keyword, projectId);
//        StringBuilder context = new StringBuilder();
//
//        if (customRoleList.isEmpty()) {
//            return String.format("没有找到与 '%s' 相关的任何关系信息。", keyword);
//        }
//
//        CustomRole role = customRoleList.get(0);
//        context.append(role.getName()).append("的关系网络：\n\n");
//
//        // 处理所有关系
//        Map<String, List<CustomRelationship>> relationshipMap = new HashMap<>();
//        relationshipMap.put("outgoing", new ArrayList<>());
//        relationshipMap.put("incoming", new ArrayList<>());
//
//        for (CustomRelationship rel : role.getRelationships()) {
//            CustomRole otherRole = rel.getTarget();
//            if (otherRole.getId().equals(role.getId())) {
//                continue; // 跳过自引用
//            }
//            if (otherRole.getRelationships().stream()
//                    .anyMatch(r -> r.getTarget().getId().equals(role.getId()))) {
//                relationshipMap.get("incoming").add(rel);
//            } else {
//                relationshipMap.get("outgoing").add(rel);
//            }
//        }
//
//        // 显示主动关系
//        context.append("主动关系（该角色指向其他角色）：\n");
//        if (relationshipMap.get("outgoing").isEmpty()) {
//            context.append("- 没有主动建立的关系\n");
//        } else {
//            for (CustomRelationship rel : relationshipMap.get("outgoing")) {
//                context.append("- ")
//                        .append(role.getName())
//                        .append(" ")
//                        .append(rel.getRelationshipType())
//                        .append(" ")
//                        .append(rel.getTarget().getName());
//                if (rel.getDescription() != null && !rel.getDescription().isEmpty()) {
//                    context.append(": ").append(rel.getDescription());
//                }
//                context.append("\n");
//            }
//        }
//        context.append("\n");
//
//        // 显示被动关系
//        context.append("被动关系（其他角色指向该角色）：\n");
//        if (relationshipMap.get("incoming").isEmpty()) {
//            context.append("- 没有被其他角色建立的关系\n");
//        } else {
//            for (CustomRelationship rel : relationshipMap.get("incoming")) {
//                context.append("- ")
//                        .append(rel.getTarget().getName())
//                        .append(" ")
//                        .append(rel.getRelationshipType())
//                        .append(" ")
//                        .append(role.getName());
//                if (rel.getDescription() != null && !rel.getDescription().isEmpty()) {
//                    context.append(": ").append(rel.getDescription());
//                }
//                context.append("\n");
//            }
//        }
//
//        return context.toString();
//    }
//
//    /**
//     * 获取指定项目和知识库下的所有角色关系
//     * @param projectId 项目ID
//     * @param knowledgeIds 知识库ID列表
//     * @return 所有角色关系的文本描述
//     */
//    public String getAllRelationshipsContext(String projectId, List<String> knowledgeIds) {
//        if (knowledgeIds == null || knowledgeIds.isEmpty()) {
//            return "未指定知识库ID。";
//        }
//
//        List<CustomRole> allRoles = roleRepository.findAllByProjectIdAndKnowledgeIds(projectId, knowledgeIds);
//        if (allRoles.isEmpty()) {
//            return "指定的知识库中没有找到任何角色关系。";
//        }
//
//        StringBuilder context = new StringBuilder("知识库中的所有角色关系：\n\n");
//
//        for (CustomRole role : allRoles) {
//            if (!role.getRelationships().isEmpty()) {
//                context.append(role.getName()).append("的关系网络：\n");
//
//                // 处理主动关系
//                for (CustomRelationship rel : role.getRelationships()) {
//                    context.append("- ")
//                            .append(role.getName())
//                            .append(" ")
//                            .append(rel.getRelationshipType())
//                            .append(" ")
//                            .append(rel.getTarget().getName());
//                    if (rel.getDescription() != null && !rel.getDescription().isEmpty()) {
//                        context.append(": ").append(rel.getDescription());
//                    }
//                    context.append("\n");
//                }
//                context.append("\n");
//            }
//        }
//
//        return context.toString();
//    }
//}