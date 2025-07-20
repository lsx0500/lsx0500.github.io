# 测试GitHub Pages部署时间
Write-Host "🚀 测试GitHub Pages部署时间" -ForegroundColor Green

# 生成一个测试文件
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$testFilename = "test_deployment_$timestamp.html"
$testContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>部署时间测试</title>
    <style>
        body { font-family: Arial; text-align: center; padding: 50px; }
        .test { color: red; font-size: 24px; }
    </style>
</head>
<body>
    <h1 class="test">部署时间测试 - $timestamp</h1>
    <p>如果看到这个页面，说明部署成功！</p>
</body>
</html>
"@

# 写入测试文件
$testFilePath = "core/frontend/generated/$testFilename"
$testContent | Out-File -FilePath $testFilePath -Encoding UTF8

Write-Host "📝 创建测试文件: $testFilename" -ForegroundColor Yellow

# 记录开始时间
$startTime = Get-Date
Write-Host "⏰ 开始时间: $startTime" -ForegroundColor Cyan

# 推送到GitHub
Write-Host "📤 推送到GitHub..." -ForegroundColor Yellow
git add $testFilePath
git commit -m "Test deployment time: $testFilename"
git push origin main

Write-Host "✅ 推送完成，开始监控部署状态..." -ForegroundColor Green

# 监控部署状态
$maxWaitTime = 300  # 5分钟最大等待时间
$checkInterval = 5   # 每5秒检查一次
$elapsedSeconds = 0
$deployed = $false

while ($elapsedSeconds -lt $maxWaitTime -and -not $deployed) {
    $elapsedSeconds = [math]::Round(((Get-Date) - $startTime).TotalSeconds)
    $remainingSeconds = $maxWaitTime - $elapsedSeconds
    
    Write-Host "⏳ 检查中... (已等待 ${elapsedSeconds}s, 剩余 ${remainingSeconds}s)" -ForegroundColor Yellow
    
    try {
        $url = "https://lsx0500.github.io/core/frontend/generated/$testFilename"
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -UseBasicParsing
        
        if ($response.StatusCode -eq 200) {
            $deployed = $true
            $totalTime = [math]::Round(((Get-Date) - $startTime).TotalSeconds)
            Write-Host "✅ 部署成功！" -ForegroundColor Green
            Write-Host "📊 总耗时: ${totalTime}秒" -ForegroundColor Cyan
            Write-Host "🌐 访问地址: $url" -ForegroundColor Cyan
            
            # 计算平均部署时间
            Write-Host "`n📈 部署时间分析:" -ForegroundColor Yellow
            if ($totalTime -le 30) {
                Write-Host "⚡ 快速部署 (< 30秒)" -ForegroundColor Green
            } elseif ($totalTime -le 60) {
                Write-Host "🚀 正常部署 (30-60秒)" -ForegroundColor Yellow
            } elseif ($totalTime -le 120) {
                Write-Host "🐌 慢速部署 (60-120秒)" -ForegroundColor Orange
            } else {
                Write-Host "🐌 超慢部署 (> 120秒)" -ForegroundColor Red
            }
            
            break
        } else {
            Write-Host "❌ HTTP状态: $($response.StatusCode)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "⏳ 部署中... (HTTP错误: $($_.Exception.Message))" -ForegroundColor Gray
    }
    
    Start-Sleep -Seconds $checkInterval
}

if (-not $deployed) {
    Write-Host "❌ 部署超时！在${maxWaitTime}秒内未完成部署" -ForegroundColor Red
}

Write-Host "`n🎉 测试完成！" -ForegroundColor Green 