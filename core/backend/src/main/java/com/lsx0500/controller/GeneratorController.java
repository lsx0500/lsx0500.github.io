package com.lsx0500.controller;

import com.lsx0500.model.GenerateRequest;
import com.lsx0500.model.GenerateResponse;
import com.lsx0500.service.GeneratorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * 生成器控制器
 * 作者: lsx0500
 * 日期: 2025-01-27
 */
@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class GeneratorController {
    
    @Autowired
    private GeneratorService generatorService;
    
    /**
     * 生成特效HTML文件
     */
    @PostMapping("/generate")
    public ResponseEntity<GenerateResponse> generateEffect(@RequestBody GenerateRequest request) {
        try {
            // 验证请求参数
            if (request.getText() == null || request.getText().trim().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(new GenerateResponse(false, "文字内容不能为空", null));
            }
            
            if (request.getPatternType() == null || request.getPatternType().trim().isEmpty()) {
                return ResponseEntity.badRequest()
                    .body(new GenerateResponse(false, "图案类型不能为空", null));
            }
            
            // 生成文件名
            String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
            String filename = request.getPatternType() + "_" + timestamp + ".html";
            
            // 生成HTML文件
            String generatedFilePath = generatorService.generateHtmlFile(request, filename);
            
            if (generatedFilePath != null) {
                // 同步到Git
                generatorService.syncToGit(filename);
                
                return ResponseEntity.ok(new GenerateResponse(true, "生成成功", filename));
            } else {
                return ResponseEntity.internalServerError()
                    .body(new GenerateResponse(false, "生成失败", null));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError()
                .body(new GenerateResponse(false, "服务器错误: " + e.getMessage(), null));
        }
    }
    
    /**
     * 健康检查接口
     */
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }
} 