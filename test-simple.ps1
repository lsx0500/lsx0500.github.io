# 简单测试API
Write-Host "测试API连接..." -ForegroundColor Green

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET
    Write-Host "✓ API健康检查成功: $response" -ForegroundColor Green
} catch {
    Write-Host "✗ API健康检查失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n测试图案生成..." -ForegroundColor Green

$body = @{
    patternType = "heart"
    userText = "测试"
    primaryColor = "#ff0000"
    bgColor = "#ffffff"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✓ 图案生成成功！" -ForegroundColor Green
    Write-Host "响应: $($response | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ 图案生成失败: $($_.Exception.Message)" -ForegroundColor Red
} 