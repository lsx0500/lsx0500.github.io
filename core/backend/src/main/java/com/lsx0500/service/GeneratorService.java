package com.lsx0500.service;

import com.lsx0500.model.GenerateRequest;
import com.lsx0500.model.GenerateResponse;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class GeneratorService {

    private static final String PROJECT_ROOT = System.getProperty("user.dir");
    private static final String TEMPLATES_DIR = "effects";
    private static final String OUTPUT_DIR = "core/frontend/generated";
    private static final String GITHUB_BASE_URL = "https://lsx0500.github.io";

    public GenerateResponse generatePattern(GenerateRequest request) throws IOException {
        // 调试信息
        System.out.println("当前工作目录: " + PROJECT_ROOT);
        System.out.println("模板目录: " + TEMPLATES_DIR);
        System.out.println("输出目录: " + OUTPUT_DIR);
        
        // 1. 读取模板文件
        String templateContent = readTemplate(request.getPatternType());
        
        // 2. 替换模板变量
        String generatedContent = replaceTemplateVariables(templateContent, request);
        
        // 3. 生成文件名
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String filename = request.getPatternType() + "_" + timestamp + ".html";
        
        // 4. 确保输出目录存在
        Path outputPath = Paths.get(PROJECT_ROOT, OUTPUT_DIR);
        Files.createDirectories(outputPath);
        
        // 5. 写入生成的文件
        Path filePath = outputPath.resolve(filename);
        Files.write(filePath, generatedContent.getBytes("UTF-8"));
        
        // 6. 执行Git推送
        pushToGit(filename);
        
        // 7. 构建响应
        GenerateResponse response = new GenerateResponse();
        response.setSuccess(true);
        response.setMessage("图案生成成功！");
        response.setFileUrl(GITHUB_BASE_URL + "/" + OUTPUT_DIR + "/" + filename);
        response.setGitUrl("https://github.com/lsx0500/lsx0500.github.io/blob/main/" + OUTPUT_DIR + "/" + filename);
        response.setPreviewUrl(GITHUB_BASE_URL + "/" + OUTPUT_DIR + "/" + filename);
        
        return response;
    }

    private String readTemplate(String patternType) throws IOException {
        String templatePath = TEMPLATES_DIR + "/" + patternType + "/" + patternType + "_01.html";
        Path path = Paths.get(PROJECT_ROOT, templatePath);
        
        System.out.println("尝试读取模板文件: " + path.toString());
        System.out.println("文件是否存在: " + Files.exists(path));
        
        if (!Files.exists(path)) {
            throw new IOException("模板文件不存在: " + path.toString());
        }
        
        String content = new String(Files.readAllBytes(path), "UTF-8");
        System.out.println("模板文件读取成功，内容长度: " + content.length());
        return content;
    }

    private String replaceTemplateVariables(String template, GenerateRequest request) {
        return template
                .replace("{{USER_TEXT}}", request.getUserText())
                .replace("{{PRIMARY_COLOR}}", request.getPrimaryColor())
                .replace("{{BG_COLOR}}", request.getBgColor());
    }

    private void pushToGit(String filename) throws IOException {
        try {
            // 添加文件到Git
            ProcessBuilder addProcess = new ProcessBuilder("git", "add", OUTPUT_DIR + "/" + filename);
            addProcess.directory(Paths.get(PROJECT_ROOT).toFile());
            Process addProc = addProcess.start();
            addProc.waitFor();

            // 提交更改
            ProcessBuilder commitProcess = new ProcessBuilder("git", "commit", "-m", "Auto-generate: " + filename);
            commitProcess.directory(Paths.get(PROJECT_ROOT).toFile());
            Process commitProc = commitProcess.start();
            commitProc.waitFor();

            // 推送到GitHub
            ProcessBuilder pushProcess = new ProcessBuilder("git", "push", "origin", "main");
            pushProcess.directory(Paths.get(PROJECT_ROOT).toFile());
            Process pushProc = pushProcess.start();
            pushProc.waitFor();

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new IOException("Git操作被中断", e);
        }
    }
} 