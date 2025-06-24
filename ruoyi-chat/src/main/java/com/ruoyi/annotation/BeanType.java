package com.ruoyi.annotation;

import com.ruoyi.enums.AiTypeEnum;
import org.springframework.stereotype.Service;

import java.lang.annotation.*;

@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Service
public @interface BeanType {

    AiTypeEnum value() default AiTypeEnum.OLLAMA;
}
