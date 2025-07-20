package com.lsx0500.service;

import com.lsx0500.model.GenerateRequest;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 生成器服务类
 * 作者: lsx0500
 * 日期: 2025-01-27
 */
@Service
public class GeneratorService {
    
    private static final String PROJECT_ROOT = System.getProperty("user.dir");
    private static final String EFFECTS_DIR = PROJECT_ROOT + "/../../effects";
    private static final String GENERATED_DIR = PROJECT_ROOT + "/../../core/frontend/generated";
    
    /**
     * 生成HTML文件
     */
    public String generateHtmlFile(GenerateRequest request, String filename) {
        try {
            System.out.println("开始生成文件: " + filename);
            System.out.println("项目根目录: " + PROJECT_ROOT);
            System.out.println("特效目录: " + EFFECTS_DIR);
            System.out.println("生成目录: " + GENERATED_DIR);
            
            // 确保生成目录存在
            Path generatedPath = Paths.get(GENERATED_DIR);
            if (!Files.exists(generatedPath)) {
                Files.createDirectories(generatedPath);
                System.out.println("创建生成目录: " + GENERATED_DIR);
            }
            
            // 查找模板文件
            String templatePath = findTemplate(request.getPatternType());
            if (templatePath == null) {
                System.err.println("未找到模板文件: " + request.getPatternType());
                return null;
            }
            System.out.println("找到模板文件: " + templatePath);
            
            // 读取模板内容
            String templateContent = readFile(templatePath);
            if (templateContent == null) {
                System.err.println("无法读取模板文件: " + templatePath);
                return null;
            }
            System.out.println("模板内容长度: " + templateContent.length());
            
            // 替换模板变量
            String generatedContent = replaceTemplateVariables(templateContent, request);
            System.out.println("替换变量完成，生成内容长度: " + generatedContent.length());
            
            // 写入生成的文件
            String outputPath = GENERATED_DIR + "/" + filename;
            writeFile(outputPath, generatedContent);
            
            System.out.println("文件生成成功: " + outputPath);
            return outputPath;
            
        } catch (Exception e) {
            System.err.println("生成文件时发生异常: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 查找模板文件
     */
    private String findTemplate(String patternType) {
        System.out.println("查找模板文件，类型: " + patternType);
        
        String[] possiblePaths = {
            EFFECTS_DIR + "/" + patternType + "/" + patternType + "_01.html",
            EFFECTS_DIR + "/" + patternType + "/" + patternType + ".html",
            EFFECTS_DIR + "/" + patternType + "_01.html"
        };
        
        for (String path : possiblePaths) {
            System.out.println("检查路径: " + path);
            if (Files.exists(Paths.get(path))) {
                System.out.println("找到模板文件: " + path);
                return path;
            } else {
                System.out.println("路径不存在: " + path);
            }
        }
        
        System.out.println("未找到模板文件");
        return null;
    }
    
    /**
     * 读取文件内容
     */
    private String readFile(String filePath) {
        try {
            return Files.readString(Paths.get(filePath), StandardCharsets.UTF_8);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 写入文件内容
     */
    private void writeFile(String filePath, String content) throws IOException {
        Files.write(Paths.get(filePath), content.getBytes(StandardCharsets.UTF_8));
    }
    
    /**
     * 替换模板变量
     */
    private String replaceTemplateVariables(String template, GenerateRequest request) {
        String result = template;
        
        // 替换用户文字
        result = result.replace("{{USER_TEXT}}", request.getText());
        
        // 替换主色调
        if (request.getPrimaryColor() != null) {
            result = result.replace("{{PRIMARY_COLOR}}", request.getPrimaryColor());
        }
        
        // 替换背景色
        if (request.getBgColor() != null) {
            result = result.replace("{{BG_COLOR}}", request.getBgColor());
        }
        
        return result;
    }
    
    /**
     * 同步到Git
     */
    public void syncToGit(String filename) {
        try {
            // 构建PowerShell命令
            String scriptPath = PROJECT_ROOT + "/scripts/sync-to-git.ps1";
            String command = String.format("powershell.exe -ExecutionPolicy Bypass -File \"%s\" \"%s\" \"%s\"",
                    scriptPath, PROJECT_ROOT, filename);
            
            // 执行命令
            ProcessBuilder processBuilder = new ProcessBuilder();
            processBuilder.command("cmd", "/c", command);
            processBuilder.redirectErrorStream(true);
            
            Process process = processBuilder.start();
            
            // 读取输出
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("Git同步: " + line);
                }
            }
            
            // 等待进程完成
            int exitCode = process.waitFor();
            System.out.println("Git同步完成，退出码: " + exitCode);
            
        } catch (Exception e) {
            System.err.println("Git同步失败: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 