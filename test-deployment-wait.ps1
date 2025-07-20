# 测试部署等待页面
Write-Host "🚀 测试部署等待页面功能" -ForegroundColor Green

# 模拟生成的文件信息
$testUrl = "https://lsx0500.github.io/core/frontend/generated/heart_20250720_133744.html"
$testFilename = "heart_20250720_133744.html"

Write-Host "📄 测试文件: $testFilename" -ForegroundColor Yellow
Write-Host "🔗 测试URL: $testUrl" -ForegroundColor Yellow

# 检查文件是否可访问
Write-Host "`n🔍 检查文件可访问性..." -ForegroundColor Cyan

try {
    $response = Invoke-WebRequest -Uri $testUrl -Method Head -TimeoutSec 10
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ 文件可以正常访问 (HTTP $($response.StatusCode))" -ForegroundColor Green
        $isAccessible = $true
    } else {
        Write-Host "❌ 文件不可访问 (HTTP $($response.StatusCode))" -ForegroundColor Red
        $isAccessible = $false
    }
} catch {
    Write-Host "❌ 文件不可访问 (错误: $($_.Exception.Message))" -ForegroundColor Red
    $isAccessible = $false
}

# 构建部署等待页面URL
$waitUrl = "deployment-wait.html?url=$([System.Web.HttpUtility]::UrlEncode($testUrl))&filename=$([System.Web.HttpUtility]::UrlEncode($testFilename))"

Write-Host "`n🌐 部署等待页面信息:" -ForegroundColor Yellow
Write-Host "📄 文件名: $testFilename" -ForegroundColor Cyan
Write-Host "🔗 文件URL: $testUrl" -ForegroundColor Cyan
Write-Host "⏳ 等待页面: $waitUrl" -ForegroundColor Cyan

# 如果文件可访问，直接显示成功
if ($isAccessible) {
    Write-Host "`n🎉 文件已部署完成！" -ForegroundColor Green
    Write-Host "✅ 可以直接访问: $testUrl" -ForegroundColor Green
} else {
    Write-Host "`n⏳ 文件正在部署中..." -ForegroundColor Yellow
    Write-Host "💡 建议等待5-10分钟后再检查" -ForegroundColor Yellow
}

# 打开部署等待页面
Write-Host "`n🚀 打开部署等待页面..." -ForegroundColor Yellow
Start-Process $waitUrl

Write-Host "`n📊 测试总结:" -ForegroundColor Green
Write-Host "✅ 部署等待页面已创建" -ForegroundColor Green
Write-Host "✅ 文件可访问性已检查" -ForegroundColor Green
if ($isAccessible) {
    Write-Host "✅ 文件已部署完成" -ForegroundColor Green
} else {
    Write-Host "⏳ 文件正在部署中" -ForegroundColor Yellow
}

Write-Host "`n🏁 测试完成！" -ForegroundColor Green 