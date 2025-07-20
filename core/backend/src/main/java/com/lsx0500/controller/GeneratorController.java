package com.lsx0500.controller;

import com.lsx0500.model.GenerateRequest;
import com.lsx0500.model.GenerateResponse;
import com.lsx0500.service.GeneratorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/generate")
@CrossOrigin(origins = "*")
public class GeneratorController {

    @Autowired
    private GeneratorService generatorService;

    @PostMapping("/pattern")
    public ResponseEntity<GenerateResponse> generatePattern(@RequestBody GenerateRequest request) {
        try {
            // 添加详细的请求日志
            System.out.println("收到图案生成请求:");
            System.out.println("  patternType: " + request.getPatternType());
            System.out.println("  userText: " + request.getUserText());
            System.out.println("  primaryColor: " + request.getPrimaryColor());
            System.out.println("  bgColor: " + request.getBgColor());
            
            GenerateResponse response = generatorService.generatePattern(request);
            System.out.println("图案生成成功: " + response.getPreviewUrl());
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            // 详细的错误日志
            System.err.println("图案生成失败: " + e.getMessage());
            e.printStackTrace();
            
            GenerateResponse errorResponse = new GenerateResponse();
            errorResponse.setSuccess(false);
            errorResponse.setMessage("生成失败: " + e.getMessage());
            return ResponseEntity.badRequest().body(errorResponse);
        }
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("Pattern Generator API is running!");
    }
} 