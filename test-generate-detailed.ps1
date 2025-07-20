# 详细测试图案生成API
Write-Host "=== 详细测试图案生成API ===" -ForegroundColor Green

$body = @{
    patternType = "heart"
    userText = "测试图案"
    primaryColor = "#ff6b6b"
    bgColor = "#f8f9fa"
} | ConvertTo-Json

Write-Host "请求数据: $body" -ForegroundColor Yellow

try {
    Write-Host "发送API请求..." -ForegroundColor Cyan
    
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json"
    
    Write-Host "✓ API调用成功！" -ForegroundColor Green
    Write-Host "响应数据: $($response | ConvertTo-Json -Depth 3)" -ForegroundColor Cyan
    
    if ($response.success) {
        Write-Host "✓ 图案生成成功！" -ForegroundColor Green
        Write-Host "预览链接: $($response.previewUrl)" -ForegroundColor Cyan
        Write-Host "GitHub链接: $($response.gitUrl)" -ForegroundColor Cyan
        Write-Host "消息: $($response.message)" -ForegroundColor Yellow
    } else {
        Write-Host "✗ 图案生成失败: $($response.message)" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ API调用失败" -ForegroundColor Red
    Write-Host "错误类型: $($_.Exception.GetType().Name)" -ForegroundColor Red
    Write-Host "错误消息: $($_.Exception.Message)" -ForegroundColor Red
    
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode
        Write-Host "HTTP状态码: $statusCode" -ForegroundColor Red
        
        try {
            $errorResponse = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($errorResponse)
            $errorBody = $reader.ReadToEnd()
            Write-Host "错误响应: $errorBody" -ForegroundColor Red
        } catch {
            Write-Host "无法读取错误响应" -ForegroundColor Red
        }
    }
} 