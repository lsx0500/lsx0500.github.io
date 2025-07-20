package com.lsx0500.model;

/**
 * 生成请求模型
 * 作者: lsx0500
 * 日期: 2025-01-27
 */
public class GenerateRequest {
    private String text;
    private String patternType;
    private String primaryColor;
    private String bgColor;
    
    // 默认构造函数
    public GenerateRequest() {}
    
    // 带参数构造函数
    public GenerateRequest(String text, String patternType, String primaryColor, String bgColor) {
        this.text = text;
        this.patternType = patternType;
        this.primaryColor = primaryColor;
        this.bgColor = bgColor;
    }
    
    // Getter和Setter方法
    public String getText() {
        return text;
    }
    
    public void setText(String text) {
        this.text = text;
    }
    
    public String getPatternType() {
        return patternType;
    }
    
    public void setPatternType(String patternType) {
        this.patternType = patternType;
    }
    
    public String getPrimaryColor() {
        return primaryColor;
    }
    
    public void setPrimaryColor(String primaryColor) {
        this.primaryColor = primaryColor;
    }
    
    public String getBgColor() {
        return bgColor;
    }
    
    public void setBgColor(String bgColor) {
        this.bgColor = bgColor;
    }
    
    @Override
    public String toString() {
        return "GenerateRequest{" +
                "text='" + text + '\'' +
                ", patternType='" + patternType + '\'' +
                ", primaryColor='" + primaryColor + '\'' +
                ", bgColor='" + bgColor + '\'' +
                '}';
    }
} 