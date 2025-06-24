package com.ruoyi.searxng;

import java.util.List;

/**
 * SearXNG搜索参数类
 */
public class SearXNGSearchParams {
    private String q; // 必需参数：搜索查询
    private List<String> categories; // 可选：搜索类别
    private List<String> engines; // 可选：搜索引擎
    private String language; // 可选：语言代码
    private Integer pageno; // 可选：页码，默认1
    private String time_range; // 可选：时间范围 [day, month, year]
    private String format = "json"; // 输出格式，必须为json以便API使用

    // 构造函数
    public SearXNGSearchParams(String query) {
        this.q = query;
    }

    // Getters and Setters
    public String getQ() {
        return q;
    }

    public void setQ(String q) {
        this.q = q;
    }

    public List<String> getCategories() {
        return categories;
    }

    public void setCategories(List<String> categories) {
        this.categories = categories;
    }

    public List<String> getEngines() {
        return engines;
    }

    public void setEngines(List<String> engines) {
        this.engines = engines;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public Integer getPageno() {
        return pageno;
    }

    public void setPageno(Integer pageno) {
        this.pageno = pageno;
    }

    public String getTime_range() {
        return time_range;
    }

    public void setTime_range(String time_range) {
        this.time_range = time_range;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }
}
