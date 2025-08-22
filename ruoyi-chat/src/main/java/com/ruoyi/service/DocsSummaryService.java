package com.ruoyi.service;

import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.ai.image.ImageGeneration;
import org.springframework.ai.image.ImageMessage;
import org.springframework.ai.image.ImagePrompt;
import org.springframework.ai.image.ImageResponse;
import org.springframework.ai.zhipuai.ZhiPuAiImageModel;
import org.springframework.ai.zhipuai.ZhiPuAiImageOptions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;

/**
 * 图片服务
 */
@Service
@Slf4j
public class ImageService {
    @Autowired
    private ZhiPuAiImageModel zhiPuAiImageModel;
    public void text2Image(String prompt, String resolution, String style, HttpServletResponse response) {


        ImageResponse imageResponse = this.zhiPuAiImageModel.call(
                new ImagePrompt(new ImageMessage(prompt)
                        , ZhiPuAiImageOptions.builder()
                        .build()
                ));


        String imageUrl = imageResponse.getResult().getOutput().getUrl();

        log.info("imageUrl:{}", imageUrl);

        try {
            URL url = URI.create(imageUrl).toURL();
            InputStream in = url.openStream();

            response.setHeader("Content-Security-Policy", "img-src 'self' data:;");
            response.setHeader("Content-Type", MediaType.IMAGE_PNG_VALUE);
            response.getOutputStream().write(in.readAllBytes());
            response.getOutputStream().flush();
        }
        catch (IOException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
