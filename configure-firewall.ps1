# 防火墙配置脚本
Write-Host "=== 配置防火墙规则 ===" -ForegroundColor Green

Write-Host "`n注意: 此脚本需要管理员权限运行" -ForegroundColor Yellow
Write-Host "请以管理员身份运行PowerShell，然后执行此脚本" -ForegroundColor Yellow

Write-Host "`n配置Python HTTP服务器防火墙规则..." -ForegroundColor Cyan
try {
    netsh advfirewall firewall add rule name="Python HTTP Server" dir=in action=allow protocol=TCP localport=8000
    Write-Host "✓ Python HTTP服务器防火墙规则已添加" -ForegroundColor Green
} catch {
    Write-Host "✗ 添加Python防火墙规则失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n配置Java后端服务器防火墙规则..." -ForegroundColor Cyan
try {
    netsh advfirewall firewall add rule name="Java Backend Server" dir=in action=allow protocol=TCP localport=8080
    Write-Host "✓ Java后端服务器防火墙规则已添加" -ForegroundColor Green
} catch {
    Write-Host "✗ 添加Java防火墙规则失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 防火墙配置完成 ===" -ForegroundColor Green
Write-Host "现在移动设备应该可以访问您的服务了" -ForegroundColor Cyan 