package com.ruoyi.searxng;

import java.util.List;

/**
 * SearXNG搜索结果类
 */
public class SearXNGSearchResult {
    private String query;
    private Integer number_of_results;
    private List<Result> results;

    // 内部类表示单个搜索结果
    public static class Result {
        private String title;
        private String url;
        private String content;
        private List<String> engines;
        private String category;
        private String pretty_url;

        // Getters and Setters
        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public List<String> getEngines() {
            return engines;
        }

        public void setEngines(List<String> engines) {
            this.engines = engines;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public String getPretty_url() {
            return pretty_url;
        }

        public void setPretty_url(String pretty_url) {
            this.pretty_url = pretty_url;
        }
    }

    // Getters and Setters
    public String getQuery() {
        return query;
    }

    public void setQuery(String query) {
        this.query = query;
    }

    public Integer getNumber_of_results() {
        return number_of_results;
    }

    public void setNumber_of_results(Integer number_of_results) {
        this.number_of_results = number_of_results;
    }

    public List<Result> getResults() {
        return results;
    }

    public void setResults(List<Result> results) {
        this.results = results;
    }
}
