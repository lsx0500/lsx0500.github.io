package com.lsx0500.service;

import com.lsx0500.model.GenerateRequest;
import org.springframework.stereotype.Service;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * Generator Service Class
 * Author: lsx0500
 * Date: 2025-01-27
 */
@Service
public class GeneratorService {
    
    private static final String PROJECT_ROOT = System.getProperty("user.dir");
    private static final String EFFECTS_DIR = PROJECT_ROOT + "/../../effects";
    private static final String GENERATED_DIR = PROJECT_ROOT + "/../../core/frontend/generated";
    
    /**
     * Generate HTML file
     */
    public String generateHtmlFile(GenerateRequest request, String filename) {
        try {
            System.out.println("Starting file generation: " + filename);
            System.out.println("Project root: " + PROJECT_ROOT);
            System.out.println("Effects directory: " + EFFECTS_DIR);
            System.out.println("Generated directory: " + GENERATED_DIR);
            
            // Ensure generated directory exists
            Path generatedPath = Paths.get(GENERATED_DIR);
            if (!Files.exists(generatedPath)) {
                Files.createDirectories(generatedPath);
                System.out.println("Created generated directory: " + GENERATED_DIR);
            }
            
            // Find template file
            String templatePath = findTemplate(request.getPatternType());
            if (templatePath == null) {
                System.err.println("Template file not found: " + request.getPatternType());
                return null;
            }
            System.out.println("Found template file: " + templatePath);
            
            // Read template content
            String templateContent = readFile(templatePath);
            if (templateContent == null) {
                System.err.println("Cannot read template file: " + templatePath);
                return null;
            }
            System.out.println("Template content length: " + templateContent.length());
            
            // Replace template variables
            String generatedContent = replaceTemplateVariables(templateContent, request);
            System.out.println("Variable replacement completed, generated content length: " + generatedContent.length());
            
            // Write generated file
            String outputPath = GENERATED_DIR + "/" + filename;
            writeFile(outputPath, generatedContent);
            
            System.out.println("File generated successfully: " + outputPath);
            return outputPath;
            
        } catch (Exception e) {
            System.err.println("Exception during file generation: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Find template file
     */
    private String findTemplate(String patternType) {
        System.out.println("Looking for template file, type: " + patternType);
        
        String[] possiblePaths = {
            EFFECTS_DIR + "/" + patternType + "/" + patternType + "_01.html",
            EFFECTS_DIR + "/" + patternType + "/" + patternType + ".html",
            EFFECTS_DIR + "/" + patternType + "_01.html"
        };
        
        for (String path : possiblePaths) {
            System.out.println("Checking path: " + path);
            if (Files.exists(Paths.get(path))) {
                System.out.println("Found template file: " + path);
                return path;
            } else {
                System.out.println("Path does not exist: " + path);
            }
        }
        
        System.out.println("Template file not found");
        return null;
    }
    
    /**
     * Read file content
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
     * Write file content
     */
    private void writeFile(String filePath, String content) throws IOException {
        Files.write(Paths.get(filePath), content.getBytes(StandardCharsets.UTF_8));
    }
    
    /**
     * Replace template variables
     */
    private String replaceTemplateVariables(String template, GenerateRequest request) {
        String result = template;
        
        // Replace user text
        result = result.replace("{{USER_TEXT}}", request.getText());
        
        // Replace primary color
        if (request.getPrimaryColor() != null) {
            result = result.replace("{{PRIMARY_COLOR}}", request.getPrimaryColor());
        }
        
        // Replace background color
        if (request.getBgColor() != null) {
            result = result.replace("{{BG_COLOR}}", request.getBgColor());
        }
        
        return result;
    }
    
    /**
     * Sync to Git
     */
    public void syncToGit(String filename) {
        try {
            // Build PowerShell command
            String scriptPath = PROJECT_ROOT + "/../../scripts/sync-to-git.ps1";
            String command = String.format("powershell.exe -ExecutionPolicy Bypass -File \"%s\" \"%s\" \"%s\"",
                    scriptPath, PROJECT_ROOT + "/../..", filename);
            
            // Execute command
            ProcessBuilder processBuilder = new ProcessBuilder();
            processBuilder.command("cmd", "/c", command);
            processBuilder.redirectErrorStream(true);
            
            Process process = processBuilder.start();
            
            // Read output
            try (BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream(), StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("Git sync: " + line);
                }
            }
            
            // Wait for process completion
            int exitCode = process.waitFor();
            System.out.println("Git sync completed, exit code: " + exitCode);
            
        } catch (Exception e) {
            System.err.println("Git sync failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
} 