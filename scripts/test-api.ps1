# API测试脚本
Write-Host "=== 测试后端API ===" -ForegroundColor Green

# 等待后端服务启动
Write-Host "等待后端服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 测试健康检查
Write-Host "测试健康检查..." -ForegroundColor Yellow
try {
    $healthResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET
    Write-Host "✓ 健康检查通过: $healthResponse" -ForegroundColor Green
} catch {
    Write-Host "✗ 健康检查失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请确保后端服务已启动在 http://localhost:8080" -ForegroundColor Yellow
    exit 1
}

# 测试图案生成API
Write-Host "测试图案生成API..." -ForegroundColor Yellow

$testData = @{
    patternType = "heart"
    userText = "测试图案"
    primaryColor = "#ff6b6b"
    bgColor = "#f8f9fa"
}

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body ($testData | ConvertTo-Json) -ContentType "application/json"
    
    if ($response.success) {
        Write-Host "✓ 图案生成成功！" -ForegroundColor Green
        Write-Host "预览链接: $($response.previewUrl)" -ForegroundColor Cyan
        Write-Host "GitHub链接: $($response.gitUrl)" -ForegroundColor Cyan
        Write-Host "消息: $($response.message)" -ForegroundColor Yellow
    } else {
        Write-Host "✗ 图案生成失败: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ API调用失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "API测试完成！" -ForegroundColor Green 