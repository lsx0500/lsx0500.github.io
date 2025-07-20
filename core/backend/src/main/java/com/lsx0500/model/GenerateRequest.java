package com.lsx0500.model;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;

public class GenerateRequest {
    
    @NotBlank(message = "图案类型不能为空")
    private String patternType;
    
    @NotBlank(message = "用户文字不能为空")
    private String userText;
    
    @NotNull(message = "主色调不能为空")
    private String primaryColor;
    
    @NotNull(message = "背景色不能为空")
    private String bgColor;

    // Getters and Setters
    public String getPatternType() {
        return patternType;
    }

    public void setPatternType(String patternType) {
        this.patternType = patternType;
    }

    public String getUserText() {
        return userText;
    }

    public void setUserText(String userText) {
        this.userText = userText;
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
} 