# 详细错误信息捕获
Write-Host "=== 详细错误信息捕获 ===" -ForegroundColor Green

$body = @{
    patternType = "heart"
    userText = "测试"
    primaryColor = "#ff0000"
    bgColor = "#ffffff"
} | ConvertTo-Json

Write-Host "请求数据: $body" -ForegroundColor Yellow

try {
    $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/pattern" -Method POST -Body $body -ContentType "application/json"
    Write-Host "✓ API调用成功！" -ForegroundColor Green
    Write-Host "响应: $($response | ConvertTo-Json)" -ForegroundColor Cyan
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
            Write-Host "错误响应体: $errorBody" -ForegroundColor Red
        } catch {
            Write-Host "无法读取错误响应体" -ForegroundColor Red
        }
    }
    
    # 尝试使用curl获取更详细的错误信息
    Write-Host "`n使用curl获取详细错误信息..." -ForegroundColor Yellow
    try {
        $curlOutput = curl -X POST http://localhost:8080/api/generate/pattern -H "Content-Type: application/json" -d $body 2>&1
        Write-Host "Curl输出: $curlOutput" -ForegroundColor Cyan
    } catch {
        Write-Host "Curl也失败了" -ForegroundColor Red
    }
} 