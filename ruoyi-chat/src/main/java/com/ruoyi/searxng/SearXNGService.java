package com.ruoyi.searxng;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Arrays;
import java.util.Collections;

@Service
public class SearXNGService {
    private final RestTemplate restTemplate;
    private final String searxngHost;

    @Autowired
    public SearXNGService(RestTemplate searxngRestTemplate, String searxngHost) {
        this.restTemplate = searxngRestTemplate;
        this.searxngHost = searxngHost;
    }

    /**
     * 使用GET方法执行搜索
     *
     * @param params 搜索参数
     * @return 搜索结果
     */
    public SearXNGSearchResult searchWithGet(SearXNGSearchParams params) {
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(searxngHost + "/search")
                .queryParam("q", params.getQ())
                .queryParam("format", "json");

        // 添加可选参数
        if (params.getCategories() != null && !params.getCategories().isEmpty()) {
            builder.queryParam("categories", String.join(",", params.getCategories()));
        }
        if (params.getEngines() != null && !params.getEngines().isEmpty()) {
            builder.queryParam("engines", String.join(",", params.getEngines()));
        }
        if (params.getLanguage() != null) {
            builder.queryParam("language", params.getLanguage());
        }
        if (params.getPageno() != null) {
            builder.queryParam("pageno", params.getPageno());
        }
        if (params.getTime_range() != null) {
            builder.queryParam("time_range", params.getTime_range());
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        HttpEntity<?> entity = new HttpEntity<>(headers);

        ResponseEntity<SearXNGSearchResult> response = restTemplate.exchange(
                builder.toUriString(),
                HttpMethod.GET,
                entity,
                SearXNGSearchResult.class);

        return response.getBody();
    }

    /**
     * 使用POST方法执行搜索
     *
     * @param params 搜索参数
     * @return 搜索结果
     */
    public SearXNGSearchResult searchWithPost(SearXNGSearchParams params) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
        headers.setAccept(Collections.singletonList(MediaType.APPLICATION_JSON));

        // 构建表单数据
        UriComponentsBuilder builder = UriComponentsBuilder.newInstance()
                .queryParam("q", params.getQ())
                .queryParam("format", "json");

        // 添加可选参数
        if (params.getCategories() != null && !params.getCategories().isEmpty()) {
            builder.queryParam("categories", String.join(",", params.getCategories()));
        }
        if (params.getEngines() != null && !params.getEngines().isEmpty()) {
            builder.queryParam("engines", String.join(",", params.getEngines()));
        }
        if (params.getLanguage() != null) {
            builder.queryParam("language", params.getLanguage());
        }
        if (params.getPageno() != null) {
            builder.queryParam("pageno", params.getPageno());
        }
        if (params.getTime_range() != null) {
            builder.queryParam("time_range", params.getTime_range());
        }

        // 移除第一个'?'字符
        String formData = builder.build().toString().substring(1);

        HttpEntity<String> entity = new HttpEntity<>(formData, headers);

        ResponseEntity<SearXNGSearchResult> response = restTemplate.exchange(
                searxngHost + "/search",
                HttpMethod.POST,
                entity,
                SearXNGSearchResult.class);

        return response.getBody();
    }

    /**
     * 简化的搜索方法，使用默认参数
     *
     * @param query 搜索查询
     * @return 搜索结果
     */
    public SearXNGSearchResult search(String query) {
        SearXNGSearchParams params = new SearXNGSearchParams(query);
        return searchWithGet(params);
    }

    /**
     * 使用特定引擎进行搜索
     *
     * @param query 搜索查询
     * @param engines 要使用的搜索引擎列表
     * @return 搜索结果
     */
    public SearXNGSearchResult searchWithEngines(String query, String... engines) {
        SearXNGSearchParams params = new SearXNGSearchParams(query);
        params.setEngines(Arrays.asList(engines));
        return searchWithGet(params);
    }

    /**
     * 使用特定类别进行搜索
     *
     * @param query 搜索查询
     * @param categories 要使用的搜索类别列表
     * @return 搜索结果
     */
    public SearXNGSearchResult searchWithCategories(String query, String... categories) {
        SearXNGSearchParams params = new SearXNGSearchParams(query);
        params.setCategories(Arrays.asList(categories));
        return searchWithGet(params);
    }
}
