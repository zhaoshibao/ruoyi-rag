package com.ruoyi.web.controller.system;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.List;
import java.util.Map;

import cn.hutool.core.annotation.MirroredAnnotationAttribute;
import jakarta.servlet.http.HttpServletResponse;
import net.sourceforge.tess4j.ITesseract;
import net.sourceforge.tess4j.Tesseract;
import org.springframework.ai.transformers.TransformersEmbeddingModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.ruoyi.common.annotation.Log;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.page.TableDataInfo;
import com.ruoyi.common.enums.BusinessType;
import com.ruoyi.common.utils.poi.ExcelUtil;
import com.ruoyi.system.domain.SysConfig;
import com.ruoyi.system.service.ISysConfigService;

import javax.imageio.ImageIO;

/**
 * 参数配置 信息操作处理
 * 
 * @author lixianfeng
 */
@RestController
@RequestMapping("/system/config")
public class SysConfigController extends BaseController
{
    @Autowired
    private ISysConfigService configService;

    /**
     * 获取参数配置列表
     */
    @PreAuthorize("@ss.hasPermi('system:config:list')")
    @GetMapping("/list")
    public TableDataInfo list(SysConfig config)
    {
        startPage();
        List<SysConfig> list = configService.selectConfigList(config);
        return getDataTable(list);
    }

    @Log(title = "参数管理", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('system:config:export')")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysConfig config)
    {
        List<SysConfig> list = configService.selectConfigList(config);
        ExcelUtil<SysConfig> util = new ExcelUtil<SysConfig>(SysConfig.class);
        util.exportExcel(response, list, "参数数据");
    }

    /**
     * 根据参数编号获取详细信息
     */
    @PreAuthorize("@ss.hasPermi('system:config:query')")
    @GetMapping(value = "/{configId}")
    public AjaxResult getInfo(@PathVariable Long configId)
    {
        return success(configService.selectConfigById(configId));
    }

    /**
     * 根据参数键名查询参数值
     */
    @GetMapping(value = "/configKey/{configKey}")
    public AjaxResult getConfigKey(@PathVariable String configKey)
    {
        return success(configService.selectConfigByKey(configKey));
    }

    /**
     * 新增参数配置
     */
    @PreAuthorize("@ss.hasPermi('system:config:add')")
    @Log(title = "参数管理", businessType = BusinessType.INSERT)
    @PostMapping
    public AjaxResult add(@Validated @RequestBody SysConfig config)
    {
        if (!configService.checkConfigKeyUnique(config))
        {
            return error("新增参数'" + config.getConfigName() + "'失败，参数键名已存在");
        }
        config.setCreateBy(getUsername());
        return toAjax(configService.insertConfig(config));
    }

    /**
     * 修改参数配置
     */
    @PreAuthorize("@ss.hasPermi('system:config:edit')")
    @Log(title = "参数管理", businessType = BusinessType.UPDATE)
    @PutMapping
    public AjaxResult edit(@Validated @RequestBody SysConfig config)
    {
        if (!configService.checkConfigKeyUnique(config))
        {
            return error("修改参数'" + config.getConfigName() + "'失败，参数键名已存在");
        }
        config.setUpdateBy(getUsername());
        return toAjax(configService.updateConfig(config));
    }

    /**
     * 删除参数配置
     */
    @PreAuthorize("@ss.hasPermi('system:config:remove')")
    @Log(title = "参数管理", businessType = BusinessType.DELETE)
    @DeleteMapping("/{configIds}")
    public AjaxResult remove(@PathVariable Long[] configIds)
    {
        configService.deleteConfigByIds(configIds);
        return success();
    }

    /**
     * 刷新参数缓存
     */
    @PreAuthorize("@ss.hasPermi('system:config:remove')")
    @Log(title = "参数管理", businessType = BusinessType.CLEAN)
    @DeleteMapping("/refreshCache")
    public AjaxResult refreshCache()
    {
        configService.resetConfigCache();
        return success();
    }

    public static void main(String[] args) {
        //testLocalEmbeddingModel();
        testOcrImage();
    }

    /**
     * 测试本地嵌入式模型
     */
    public static void testLocalEmbeddingModel() {
        TransformersEmbeddingModel embeddingModel= new TransformersEmbeddingModel();
        // 设置tokenizer文件路径
        embeddingModel.setTokenizerResource("classpath:/onnx/bge-small-zh-v1.5/tokenizer.json");
        // 设置Onnx模型文件路径
        embeddingModel.setModelResource("classpath:/onnx/bge-small-zh-v1.5/model.onnx");
        // 缓存位置
        embeddingModel.setResourceCacheDirectory("/tmp/onnx-cache");
        // 自动填充
        embeddingModel.setTokenizerOptions(Map.of("padding", "true"));
        // 模型输出层的名称，默认是 last_hidden_state, 需要根据所选模型设置
        embeddingModel.setModelOutputName("token_embeddings");
        try {
            embeddingModel.afterPropertiesSet();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        String text="你好，我是张三";
        long t= System.currentTimeMillis();
        // 生成文本嵌入向量
        float[] embed = embeddingModel.embed(text);
        long useTime= System.currentTimeMillis() - t;
        System.out.println("embed finish: " + text + " ,len: " + embed.length + "  UseTime：" + useTime + "ms");
        for (float f : embed)  {
            System.out.print(f);
        }
    }

    /**
     * 测试图片识别
     */
    public static void testOcrImage() {
        // 创建实例
        ITesseract instance = new Tesseract();

        // 设置识别语言

        instance.setLanguage("chi_sim");
        // instance.setLanguage("jpn");

        // 设置识别引擎

        instance.setOcrEngineMode(1);
        instance.setPageSegMode(6);

        // 读取文件
        try {
            BufferedImage image = ImageIO.read(new File("E:\\Desktop\\上传文件\\rag测试\\pdf截图.png"));

            // 识别
            //String res = instance.doOCR(new File("C:\\Users\\Lenovo\\Pictures\\联想截图\\联想截图_20230220144409.png"));
            String result = instance.doOCR(image);
            System.out.println(result);
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}
