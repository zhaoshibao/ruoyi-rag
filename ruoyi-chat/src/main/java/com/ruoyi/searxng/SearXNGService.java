package com.ruoyi.searxng;

import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

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
     * 简化的搜索方法，使用默认参数
     *
     * @param query 搜索查询
     * @return 搜索结果
     */
    public String searchV2(String query) {
        //联网搜索提示词
        String prompt = """
                {query}
                 
                Context information is below, surrounded by ---------------------
         
                ---------------------
                {question_answer_context}
                ---------------------
         
                Given the context and provided history information and not prior knowledge,
                reply to the user comment. If the answer is not in the context, inform
                the user that you can't answer the question.
                """;
        
        // 执行搜索
        SearXNGSearchParams params = new SearXNGSearchParams(query);
        SearXNGSearchResult search = searchWithGet(params);
        List<SearXNGSearchResult.Result> searchResultList = search.getResults();
        
        // 构建搜索结果内容
        StringBuilder contextBuilder = new StringBuilder();
        if (!CollectionUtils.isEmpty(searchResultList)) {
            searchResultList.forEach(result -> {
                contextBuilder.append("标题: ").append(result.getTitle()).append("\n");
                contextBuilder.append("内容: ").append(result.getContent()).append("\n\n");
            });
        }
        
        // 替换提示词中的变量
        String questionAnswerContext = contextBuilder.toString();
        String result = prompt.replace("{query}", query)
                             .replace("{question_answer_context}", questionAnswerContext);
        
        return result;
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
