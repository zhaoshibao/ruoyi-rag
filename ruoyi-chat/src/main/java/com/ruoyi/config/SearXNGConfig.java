package com.ruoyi.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

@Configuration
public class SearXNGConfig {
    @Value("${searxng.host:http://localhost:8080}")
    private String searxngHost;

    @Value("${searxng.timeout:5000}")
    private int timeout;

    @Bean
    public RestTemplate searxngRestTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(timeout);
        factory.setReadTimeout(timeout);
        return new RestTemplate(factory);
    }

    @Bean
    public String searxngHost() {
        return searxngHost;
    }
}
