# 最小化API测试
Write-Host "测试API..." -ForegroundColor Green

$body = @{
    patternType = "heart"
    userText = "测试"
    primaryColor = "#ff0000"
    bgColor = "#ffffff"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✓ 成功！" -ForegroundColor Green
    Write-Host "响应: $($response | ConvertTo-Json)" -ForegroundColor Cyan
} catch {
    Write-Host "✗ 失败: $($_.Exception.Message)" -ForegroundColor Red
} 