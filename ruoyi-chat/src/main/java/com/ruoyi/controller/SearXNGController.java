package com.ruoyi.controller;

import com.ruoyi.searxng.SearXNGSearchParams;
import com.ruoyi.searxng.SearXNGSearchResult;
import com.ruoyi.searxng.SearXNGService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/searxng")
public class SearXNGController {

    @Autowired
    private SearXNGService searxngService;


    /**
     * 简单搜索接口
     */
    @GetMapping("/search")
    public SearXNGSearchResult search(@RequestParam String query) {
        return searxngService.search(query);
    }

    /**
     * 高级搜索接口
     */
    @PostMapping("/search/advanced")
    public SearXNGSearchResult advancedSearch(@RequestBody SearXNGSearchParams params) {
        return searxngService.searchWithGet(params);
    }

    /**
     * 使用特定引擎搜索
     */
    @GetMapping("/search/engines")
    public SearXNGSearchResult searchWithEngines(
            @RequestParam String query,
            @RequestParam List<String> engines) {
        return searxngService.searchWithEngines(query, engines.toArray(new String[0]));
    }

    /**
     * 使用特定类别搜索
     */
    @GetMapping("/search/categories")
    public SearXNGSearchResult searchWithCategories(
            @RequestParam String query,
            @RequestParam List<String> categories) {
        return searxngService.searchWithCategories(query, categories.toArray(new String[0]));
    }
}
