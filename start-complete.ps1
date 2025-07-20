# 完整系统启动脚本
Write-Host "=== lsx0500 完整系统启动 ===" -ForegroundColor Green

# 1. 启动后端服务
Write-Host "`n1. 启动后端服务..." -ForegroundColor Yellow
try {
    # 停止现有的Java进程
    Get-Process | Where-Object {$_.ProcessName -like "*java*"} | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    # 启动后端
    Start-Process powershell -ArgumentList "-Command", "cd '$PWD\core\backend'; java -cp 'target/classes;target/dependency/*' com.lsx0500.GeneratorApplication" -WindowStyle Hidden
    Write-Host "✓ 后端服务启动中..." -ForegroundColor Green
} catch {
    Write-Host "✗ 后端服务启动失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 2. 启动Python HTTP服务器
Write-Host "`n2. 启动Python HTTP服务器..." -ForegroundColor Yellow
try {
    $pythonPath = "C:\Users\11507\AppData\Local\Programs\Python\Python313\python.exe"
    
    # 停止现有的HTTP服务器
    Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue | ForEach-Object {
        Stop-Process -Id $_.OwningProcess -Force -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 2
    
    # 启动Python HTTP服务器
    Start-Process -FilePath $pythonPath -ArgumentList "-m", "http.server", "8000" -WindowStyle Hidden
    Write-Host "✓ Python HTTP服务器启动中..." -ForegroundColor Green
} catch {
    Write-Host "✗ Python HTTP服务器启动失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 3. 启动实时同步
Write-Host "`n3. 启动实时同步..." -ForegroundColor Yellow
try {
    Start-Process powershell -ArgumentList "-ExecutionPolicy", "Bypass", "-File", "sync-realtime.ps1" -WindowStyle Hidden
    Write-Host "✓ 实时同步启动中..." -ForegroundColor Green
} catch {
    Write-Host "✗ 实时同步启动失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 等待服务启动
Write-Host "`n等待服务启动..." -ForegroundColor Cyan
Start-Sleep -Seconds 20

# 4. 测试服务状态
Write-Host "`n4. 测试服务状态..." -ForegroundColor Yellow

# 测试后端
try {
    $backendHealth = Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET -TimeoutSec 5
    Write-Host "✓ 后端服务正常: $backendHealth" -ForegroundColor Green
} catch {
    Write-Host "✗ 后端服务测试失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 测试前端
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://localhost:8000" -Method GET -TimeoutSec 5
    Write-Host "✓ 前端服务正常 (状态码: $($frontendResponse.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "✗ 前端服务测试失败: $($_.Exception.Message)" -ForegroundColor Red
}

# 5. 显示访问信息
Write-Host "`n=== 访问信息 ===" -ForegroundColor Green
Write-Host "前端页面: http://localhost:8000" -ForegroundColor Cyan
Write-Host "后端API: http://localhost:8080" -ForegroundColor Cyan
Write-Host "GitHub Pages: https://lsx0500.github.io" -ForegroundColor Cyan

# 6. 显示移动设备访问信息
Write-Host "`n=== 移动设备访问 ===" -ForegroundColor Green
try {
    $ipAddress = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -like "192.168.*" -or $_.IPAddress -like "10.*" -or $_.IPAddress -like "172.*"} | Select-Object -First 1).IPAddress
    if ($ipAddress) {
        Write-Host "本地IP地址: $ipAddress" -ForegroundColor Cyan
        Write-Host "移动设备访问: http://$ipAddress`:8000" -ForegroundColor Cyan
    } else {
        Write-Host "无法获取本地IP地址" -ForegroundColor Yellow
    }
} catch {
    Write-Host "获取IP地址失败" -ForegroundColor Yellow
}

Write-Host "`n=== 系统启动完成 ===" -ForegroundColor Green
Write-Host "所有服务已在后台运行，无需手动启动" -ForegroundColor Yellow 