# 测试手机访问配置
Write-Host "📱 测试手机访问配置" -ForegroundColor Green

# 获取IP地址
$ipAddress = "192.168.3.156"
Write-Host "🌐 检测到IP地址: $ipAddress" -ForegroundColor Yellow

# 测试前端服务
Write-Host "`n🧪 测试前端服务..." -ForegroundColor Yellow
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://$ipAddress:8000" -Method GET -TimeoutSec 5
    Write-Host "✅ 前端服务正常 (HTTP $($frontendResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端服务无法访问: $($_.Exception.Message)" -ForegroundColor Red
}

# 测试后端服务
Write-Host "`n🧪 测试后端服务..." -ForegroundColor Yellow
try {
    $backendResponse = Invoke-RestMethod -Uri "http://$ipAddress:8080/api/generate/health" -Method GET -TimeoutSec 5
    Write-Host "✅ 后端服务正常: $backendResponse" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端服务无法访问: $($_.Exception.Message)" -ForegroundColor Red
}

# 显示访问信息
Write-Host "`n📱 手机访问地址:" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "🎨 图案生成器: http://$ipAddress:8000" -ForegroundColor White
Write-Host "🔧 IP检测工具: http://$ipAddress:8000/get-ip.html" -ForegroundColor White
Write-Host "==================================================" -ForegroundColor Cyan

Write-Host "`n💡 手机使用说明:" -ForegroundColor Green
Write-Host "1. 确保手机和电脑在同一个WiFi网络" -ForegroundColor White
Write-Host "2. 在手机浏览器中访问: http://$ipAddress:8000" -ForegroundColor White
Write-Host "3. 如果显示'failed to fetch'，请检查:" -ForegroundColor White
Write-Host "   - 防火墙是否允许8080端口" -ForegroundColor White
Write-Host "   - 后端服务是否正在运行" -ForegroundColor White
Write-Host "   - 网络连接是否正常" -ForegroundColor White

Write-Host "`n🔧 故障排除:" -ForegroundColor Yellow
Write-Host "1. 检查防火墙: 确保8080端口已开放" -ForegroundColor White
Write-Host "2. 重启后端服务: cd core/backend && mvn spring-boot:run" -ForegroundColor White
Write-Host "3. 检查网络: 确保手机和电脑在同一网络" -ForegroundColor White

Write-Host "`n🏁 测试完成！" -ForegroundColor Green 