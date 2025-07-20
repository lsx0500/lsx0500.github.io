# 移动端访问启动脚本
Write-Host "📱 启动移动端访问配置" -ForegroundColor Green

# 获取本机IP地址
Write-Host "`n🔍 检测网络配置..." -ForegroundColor Yellow
$ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" -or $_.IPAddress -like "172.*" } | Select-Object -First 1).IPAddress

if (-not $ipAddress) {
    Write-Host "❌ 无法检测到局域网IP地址" -ForegroundColor Red
    Write-Host "请确保电脑连接到WiFi网络" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ 检测到IP地址: $ipAddress" -ForegroundColor Green

# 检查防火墙设置
Write-Host "`n🛡️ 检查防火墙设置..." -ForegroundColor Yellow
try {
    $firewallRule = Get-NetFirewallRule -DisplayName "Pattern Generator Backend" -ErrorAction SilentlyContinue
    if (-not $firewallRule) {
        Write-Host "📝 创建防火墙规则..." -ForegroundColor Cyan
        New-NetFirewallRule -DisplayName "Pattern Generator Backend" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow -Profile Private
        Write-Host "✅ 防火墙规则已创建" -ForegroundColor Green
    } else {
        Write-Host "✅ 防火墙规则已存在" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ 无法创建防火墙规则，可能需要管理员权限" -ForegroundColor Yellow
}

# 启动后端服务
Write-Host "`n🚀 启动后端服务..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-Command", "cd '$PWD\core\backend'; mvn spring-boot:run" -WindowStyle Hidden

# 等待后端服务启动
Write-Host "⏳ 等待后端服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# 启动前端服务
Write-Host "`n🌐 启动前端服务..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-Command", "cd '$PWD'; python -m http.server 8000" -WindowStyle Hidden

# 等待前端服务启动
Write-Host "⏳ 等待前端服务启动..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# 测试服务状态
Write-Host "`n🧪 测试服务状态..." -ForegroundColor Yellow

# 测试后端服务
try {
    $backendResponse = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET -TimeoutSec 5
    Write-Host "✅ 后端服务正常: $backendResponse" -ForegroundColor Green
} catch {
    Write-Host "❌ 后端服务启动失败" -ForegroundColor Red
}

# 测试前端服务
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:8000" -Method GET -TimeoutSec 5
    Write-Host "✅ 前端服务正常 (HTTP $($frontendResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ 前端服务启动失败" -ForegroundColor Red
}

# 显示访问信息
Write-Host "`n📱 手机访问信息:" -ForegroundColor Green
Write-Host "=" * 50 -ForegroundColor Cyan
Write-Host "🌐 电脑访问地址:" -ForegroundColor Yellow
Write-Host "   图案生成器: http://localhost:8000" -ForegroundColor White
Write-Host "   后端API: http://localhost:8080" -ForegroundColor White
Write-Host ""
Write-Host "📱 手机访问地址:" -ForegroundColor Yellow
Write-Host "   图案生成器: http://$ipAddress:8000" -ForegroundColor White
Write-Host "   后端API: http://$ipAddress:8080" -ForegroundColor White
Write-Host ""
Write-Host "🔧 管理工具:" -ForegroundColor Yellow
Write-Host "   IP检测工具: http://$ipAddress:8000/get-ip.html" -ForegroundColor White
Write-Host "=" * 50 -ForegroundColor Cyan

# 打开IP检测工具
Write-Host "`n🔍 打开IP检测工具..." -ForegroundColor Yellow
Start-Process "http://localhost:8000/get-ip.html"

Write-Host "`n💡 使用说明:" -ForegroundColor Green
Write-Host "1. 确保手机和电脑在同一个WiFi网络" -ForegroundColor White
Write-Host "2. 在手机浏览器中访问: http://$ipAddress:8000" -ForegroundColor White
Write-Host "3. 如果无法访问，请检查防火墙设置" -ForegroundColor White
Write-Host "4. 按 Ctrl+C 停止所有服务" -ForegroundColor White

Write-Host "`n🎉 移动端访问配置完成！" -ForegroundColor Green

# 保持脚本运行
try {
    while ($true) {
        Start-Sleep -Seconds 10
    }
} catch {
    Write-Host "`n🛑 服务已停止" -ForegroundColor Yellow
} 