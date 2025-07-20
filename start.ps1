# lsx0500 个性化图案生成器 - 完整系统启动脚本
Write-Host "=== lsx0500 Pattern Generator System ===" -ForegroundColor Cyan
Write-Host "Starting system..." -ForegroundColor Yellow

# 检查必要工具
Write-Host "检查系统环境..." -ForegroundColor Yellow

# 检查Java
try {
    $javaVersion = java -version 2>&1
    Write-Host "✓ Java已安装" -ForegroundColor Green
} catch {
    Write-Host "✗ 未找到Java，请安装Java 8或更高版本" -ForegroundColor Red
    exit 1
}

# 检查Maven
try {
    $mavenVersion = mvn -version 2>&1
    Write-Host "✓ Maven已安装" -ForegroundColor Green
} catch {
    Write-Host "✗ 未找到Maven，请安装Maven" -ForegroundColor Red
    exit 1
}

# 检查Python
try {
    $pythonVersion = python --version 2>&1
    Write-Host "✓ Python已安装" -ForegroundColor Green
} catch {
    Write-Host "✗ 未找到Python，请安装Python" -ForegroundColor Red
    exit 1
}

# 检查Git
try {
    $gitVersion = git --version 2>&1
    Write-Host "✓ Git已安装" -ForegroundColor Green
} catch {
    Write-Host "✗ 未找到Git，请安装Git" -ForegroundColor Red
    exit 1
}

Write-Host "所有必要工具检查完成！" -ForegroundColor Green

# 启动实时Git同步
Write-Host "Starting real-time Git sync..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-ExecutionPolicy", "Bypass", "-File", "sync-realtime.ps1", "-Interval", "30" -WindowStyle Hidden
Write-Host "Real-time sync started in background" -ForegroundColor Green

# 启动后端API服务
Write-Host "Starting backend API service..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-ExecutionPolicy", "Bypass", "-File", "scripts/start-backend.ps1" -WindowStyle Normal
Write-Host "Backend API service started" -ForegroundColor Green

# 等待后端服务启动
Write-Host "Waiting for backend service to start..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

# 启动前端HTTP服务器
Write-Host "Starting local HTTP server..." -ForegroundColor Yellow
Write-Host "Starting Python HTTP server on port 8000..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-Command", "python -m http.server 8000" -WindowStyle Hidden
Write-Host "Server started at: http://localhost:8000" -ForegroundColor Green

Write-Host "System is ready!" -ForegroundColor Green
Write-Host "Access your system at: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Backend API at: http://localhost:8080" -ForegroundColor Cyan
Write-Host "GitHub Pages: https://lsx0500.github.io" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop all services" -ForegroundColor Yellow

# 保持脚本运行
try {
    while ($true) {
        Start-Sleep -Seconds 1
    }
} catch {
    Write-Host "`nStopping all services..." -ForegroundColor Yellow
    # 这里可以添加停止服务的逻辑
    Write-Host "All services stopped" -ForegroundColor Green
} 