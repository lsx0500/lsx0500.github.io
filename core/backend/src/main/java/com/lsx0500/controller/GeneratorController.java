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
            GenerateResponse response = generatorService.generatePattern(request);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
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