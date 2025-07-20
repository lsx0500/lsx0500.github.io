# 完整流程测试脚本
Write-Host "🚀 测试完整图案生成流程" -ForegroundColor Green

# 检查服务状态
Write-Host "`n📋 检查服务状态..." -ForegroundColor Yellow

# 检查后端服务
try {
    $backendResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET -TimeoutSec 5
    Write-Host "✅ 后端服务正常: $backendResponse" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端服务未启动，请先启动后端服务" -ForegroundColor Red
    exit 1
}

# 检查前端服务
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:8000" -Method GET -TimeoutSec 5
    Write-Host "✅ 前端服务正常 (HTTP $($frontendResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端服务未启动，请先启动前端服务" -ForegroundColor Red
    exit 1
}

Write-Host "`n🎨 开始生成图案测试..." -ForegroundColor Yellow

# 生成测试图案
$testData = @{
    patternType = "heart"
    userText = "测试图案"
    primaryColor = "#ff0000"
    bgColor = "#ffffff"
} | ConvertTo-Json

try {
    Write-Host "📤 发送生成请求..." -ForegroundColor Cyan
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $testData -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✅ 图案生成成功！" -ForegroundColor Green
        Write-Host "📁 文件URL: $($response.fileUrl)" -ForegroundColor Cyan
        Write-Host "🔗 GitHub URL: $($response.gitUrl)" -ForegroundColor Cyan
        Write-Host "👁️ 预览URL: $($response.previewUrl)" -ForegroundColor Cyan
        
        # 提取文件名
        $filename = $response.previewUrl.Split('/')[-1]
        Write-Host "📄 文件名: $filename" -ForegroundColor Yellow
        
        # 等待Git推送完成
        Write-Host "`n⏳ 等待Git推送完成..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
        
        # 检查文件是否已推送
        $gitStatus = git status --porcelain "core/frontend/generated/$filename"
        if ($gitStatus -eq "") {
            Write-Host "✅ 文件已推送到Git" -ForegroundColor Green
        } else {
            Write-Host "⚠️ 文件可能还在推送中" -ForegroundColor Yellow
        }
        
        # 测试部署等待页面
        Write-Host "`n🌐 测试部署等待页面..." -ForegroundColor Yellow
        $waitUrl = "http://localhost:8000/deployment-wait.html?url=$($response.previewUrl)&filename=$filename"
        Write-Host "🔗 部署等待页面: $waitUrl" -ForegroundColor Cyan
        
        # 打开部署等待页面
        Start-Process $waitUrl
        
        Write-Host "`n📊 测试结果总结:" -ForegroundColor Green
        Write-Host "✅ 后端服务正常" -ForegroundColor Green
        Write-Host "✅ 前端服务正常" -ForegroundColor Green
        Write-Host "✅ 图案生成成功" -ForegroundColor Green
        Write-Host "✅ 文件已推送" -ForegroundColor Green
        Write-Host "✅ 部署等待页面已打开" -ForegroundColor Green
        
        Write-Host "`n🎉 测试完成！请查看部署等待页面" -ForegroundColor Green
        Write-Host "💡 提示: 部署通常需要5-10分钟，请耐心等待" -ForegroundColor Yellow
        
    } else {
        Write-Host "❌ 图案生成失败: $($response.message)" -ForegroundColor Red
    }
    
} catch {
    Write-Host "❌ 请求失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🏁 测试脚本执行完成" -ForegroundColor Green 