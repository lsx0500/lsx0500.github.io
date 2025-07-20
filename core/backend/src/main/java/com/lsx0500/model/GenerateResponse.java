package com.lsx0500.model;

/**
 * 生成响应模型
 * 作者: lsx0500
 * 日期: 2025-01-27
 */
public class GenerateResponse {
    private boolean success;
    private String message;
    private String filename;
    
    // 默认构造函数
    public GenerateResponse() {}
    
    // 带参数构造函数
    public GenerateResponse(boolean success, String message, String filename) {
        this.success = success;
        this.message = message;
        this.filename = filename;
    }
    
    // Getter和Setter方法
    public boolean isSuccess() {
        return success;
    }
    
    public void setSuccess(boolean success) {
        this.success = success;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public String getFilename() {
        return filename;
    }
    
    public void setFilename(String filename) {
        this.filename = filename;
    }
    
    @Override
    public String toString() {
        return "GenerateResponse{" +
                "success=" + success +
                ", message='" + message + '\'' +
                ", filename='" + filename + '\'' +
                '}';
    }
} 