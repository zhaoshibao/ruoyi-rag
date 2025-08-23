//package com.ruoyi.controller;
//
//
//import com.ruoyi.common.core.controller.BaseController;
//import com.ruoyi.common.core.domain.AjaxResult;
//import com.ruoyi.service.Neo4jService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.*;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.util.Map;
//
//@RestController
//@RequestMapping("/neo4j")
//public class Neo4jController extends BaseController {
//    @Autowired
//    private Neo4jService neo4jService;
//
//    @PostMapping("/upload")
//    public AjaxResult uploadCsv(
//            @RequestParam("file") MultipartFile file,
//            @RequestParam("projectId") String projectId) {
//        try {
//            neo4jService.processCsvFile(file, projectId,"");
//            return AjaxResult.success("上传成功");
//        } catch (Exception e) {
//            return AjaxResult.error("上传失败：" + e.getMessage());
//        }
//    }
//
//    @GetMapping("/graph/{projectId}")
//    public AjaxResult getGraph(@PathVariable String projectId) {
//        Map<String, Object> graphData = neo4jService.getGraphData(projectId);
//        return success(graphData);
//    }
//
//    @GetMapping("/search")
//    public AjaxResult  search(@RequestParam String keyword,@RequestParam String projectId) {
//        Map<String, Object> searchResults = neo4jService.search(keyword, projectId);
//        return success(searchResults);
//    }
//
//    @GetMapping("/context")
//    public ResponseEntity<String> getContext(
//            @RequestParam String keyword,
//            @RequestParam String projectId) {
//        String context = neo4jService.getContextForLLM(keyword, projectId);
//        return ResponseEntity.ok(context);
//    }
//}
