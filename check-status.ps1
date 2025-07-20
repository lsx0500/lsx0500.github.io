# 系统状态检查脚本
Write-Host "=== lsx0500 系统状态检查 ===" -ForegroundColor Cyan

# 检查Java进程
Write-Host "检查Java进程..." -ForegroundColor Yellow
$javaProcesses = Get-Process | Where-Object {$_.ProcessName -like "*java*"}
if ($javaProcesses) {
    Write-Host "✓ Java进程正在运行 (PID: $($javaProcesses.Id))" -ForegroundColor Green
} else {
    Write-Host "✗ Java进程未运行" -ForegroundColor Red
}

# 检查Python进程
Write-Host "检查Python进程..." -ForegroundColor Yellow
$pythonProcesses = Get-Process | Where-Object {$_.ProcessName -like "*python*"}
if ($pythonProcesses) {
    Write-Host "✓ Python进程正在运行 (PID: $($pythonProcesses.Id))" -ForegroundColor Green
} else {
    Write-Host "✗ Python进程未运行" -ForegroundColor Red
}

# 检查端口
Write-Host "检查端口状态..." -ForegroundColor Yellow
$port8080 = netstat -an | Select-String ":8080"
$port8000 = netstat -an | Select-String ":8000"

if ($port8080) {
    Write-Host "✓ 端口8080正在监听" -ForegroundColor Green
} else {
    Write-Host "✗ 端口8080未监听" -ForegroundColor Red
}

if ($port8000) {
    Write-Host "✓ 端口8000正在监听" -ForegroundColor Green
} else {
    Write-Host "✗ 端口8000未监听" -ForegroundColor Red
}

# 显示访问地址
Write-Host "`n=== 访问地址 ===" -ForegroundColor Cyan
Write-Host "前端页面: http://localhost:8000" -ForegroundColor Green
Write-Host "后端API: http://localhost:8080" -ForegroundColor Green
Write-Host "GitHub Pages: https://lsx0500.github.io" -ForegroundColor Green

Write-Host "`n系统状态检查完成！" -ForegroundColor Green 