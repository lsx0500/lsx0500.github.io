# 测试超高速部署系统
Write-Host "🚀 测试超高速部署系统" -ForegroundColor Green

# 测试API调用
$requestBody = @{
    patternType = "heart"
    userText = "测试超高速部署"
    primaryColor = "#ff0000"
    bgColor = "#ffffff"
} | ConvertTo-Json

Write-Host "📡 发送生成请求..." -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $requestBody -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✅ 图案生成成功！" -ForegroundColor Green
        Write-Host "文件URL: $($response.fileUrl)" -ForegroundColor Cyan
        Write-Host "预览URL: $($response.previewUrl)" -ForegroundColor Cyan
        Write-Host "GitHub URL: $($response.gitUrl)" -ForegroundColor Cyan
        
        # 获取文件名
        $filename = $response.previewUrl.Split('/')[-1]
        Write-Host "文件名: $filename" -ForegroundColor Yellow
        
        # 等待5秒让超高速同步推送文件
        Write-Host "⏳ 等待超高速同步推送文件..." -ForegroundColor Yellow
        Start-Sleep -Seconds 5
        
        # 检查文件是否已推送
        Write-Host "🔍 检查文件是否已推送到GitHub..." -ForegroundColor Yellow
        $gitStatus = git status --porcelain
        if ($gitStatus) {
            Write-Host "📁 检测到未提交的更改:" -ForegroundColor Yellow
            Write-Host $gitStatus -ForegroundColor Gray
        } else {
            Write-Host "✅ 所有文件已推送" -ForegroundColor Green
        }
        
        # 测试部署检查脚本
        Write-Host "🔍 启动部署状态检查..." -ForegroundColor Yellow
        & ".\check-deployment.ps1" -FileName $filename -MaxWaitTime 30
        
    } else {
        Write-Host "❌ 生成失败: $($response.message)" -ForegroundColor Red
    }
}
catch {
    Write-Host "❌ 请求失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 测试完成！" -ForegroundColor Green 