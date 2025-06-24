package com.ruoyi.utils;

import lombok.extern.slf4j.Slf4j;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

@Slf4j
public class FileUtil {

    /**
     * 从文件中读取文本内容
     * @param file MultipartFile
     * @return
     */
    public static String getContentFromFile(MultipartFile file){
        String contentType = file.getContentType();
        try {
            switch (contentType) {
                case "application/msword": return getContentFromWord(file);
                case "application/pdf": return getContentFromPdf(file);
                default:
                    return getContentFromText(file);
            }
        } catch (Exception e) {
            log.error("不支持的文件类型。原始文件名：{}，文件的媒体类型：{}", file.getOriginalFilename(), contentType);
            throw new RuntimeException(e);
        }
    }

    /**
     * 读取普通文本的内容
     * @param file
     * @return
     */
    public static String getContentFromText(MultipartFile file) {
        Resource resource = file.getResource();
        try {
            return resource.getContentAsString(StandardCharsets.UTF_8);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * 读取word的文本内容
     * @param file
     * @return
     */
    private static String getContentFromWord(MultipartFile file) {
        return null;
    }

    /**
     * 读取pdf的文本内容
     * @param file
     * @return
     */
    public static String getContentFromPdf(MultipartFile file) {
        return null;
    }
}
