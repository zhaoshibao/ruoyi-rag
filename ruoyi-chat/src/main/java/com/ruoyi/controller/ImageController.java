package com.ruoyi.controller;

import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.service.ImageService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Tag(name = "AI图片服务")
@RequestMapping("ai/image")
public class ImageController extends BaseController {
    @Autowired
    private ImageService imageService;

    /**
     * 文本生成图片
     * @param response
     * @param prompt
     * @param style
     * @param resolution
     * @return
     */
    @GetMapping("/text2image")
    public void text2Image(
            HttpServletResponse response,
            @Validated @RequestParam("prompt") String prompt,
            @RequestParam(value = "style", required = false, defaultValue = "") String style,
            @RequestParam(value = "resolution", required = false, defaultValue = "1080*1080") String resolution
    ) {

         imageService.text2Image(prompt, resolution, style, response);
    }
}
