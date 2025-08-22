package com.ruoyi.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.service.DocsSummaryService;
import com.ruoyi.service.ImageService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import reactor.core.publisher.Flux;

@RestController
@Tag(name = "AI摘要服务")
@RequestMapping("ai/summarizer")
public class SummarizerController extends BaseController {
    @Autowired
    private DocsSummaryService docsSummaryService;

    /**
     * 生成摘要
     * @param response
     * @param file
     * @param url
     * @return
     */
    @PostMapping("/genSummary")
    public Flux<String> genSummary(
            HttpServletResponse response,
            @RequestParam(value = "file", required = false) MultipartFile file,
            @RequestParam(value = "url", required = false) String url
    ) {

        if (file == null && (url == null || url.isEmpty())) {
            return Flux.just("Either 'file' or 'url' must be provided.");
        }

        response.setCharacterEncoding("UTF-8");
        return docsSummaryService.summary(file, url);
    }
}
