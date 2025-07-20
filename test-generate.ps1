# 测试图案生成API
Write-Host "测试图案生成API..." -ForegroundColor Green

$body = @{
    patternType = "heart"
    userText = "测试图案"
    primaryColor = "#ff6b6b"
    bgColor = "#f8f9fa"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json"
    
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