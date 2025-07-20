# API测试脚本
Write-Host "=== API测试 ===" -ForegroundColor Green

# 测试健康检查
Write-Host "1. 测试健康检查..." -ForegroundColor Yellow
try {
    $health = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET -TimeoutSec 5
    Write-Host "✓ 健康检查通过: $health" -ForegroundColor Green
} catch {
    Write-Host "✗ 健康检查失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 测试图案生成
Write-Host "`n2. 测试图案生成..." -ForegroundColor Yellow
try {
    $body = @{
        patternType = "heart"
        size = "medium"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10
    Write-Host "✓ 图案生成成功" -ForegroundColor Green
    Write-Host "   消息: $($response.message)" -ForegroundColor Cyan
    Write-Host "   文件: $($response.fileName)" -ForegroundColor Cyan
    Write-Host "   GitHub链接: $($response.githubUrl)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ 图案生成失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 测试完成 ===" -ForegroundColor Green 