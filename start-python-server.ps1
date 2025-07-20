# Python HTTP服务器启动脚本
param(
    [int]$Port = 8000
)

Write-Host "=== 启动Python HTTP服务器 ===" -ForegroundColor Green

# Python路径
$pythonPath = "C:\Users\11507\AppData\Local\Programs\Python\Python313\python.exe"

# 检查Python是否存在
if (Test-Path $pythonPath) {
    Write-Host "✓ 找到Python: $pythonPath" -ForegroundColor Green
} else {
    Write-Host "✗ 未找到Python，请检查安装路径" -ForegroundColor Red
    exit 1
}

# 检查端口是否被占用
$portCheck = netstat -an | findstr ":$Port"
if ($portCheck) {
    Write-Host "⚠ 端口 $Port 已被占用，尝试停止现有进程..." -ForegroundColor Yellow
    try {
        $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess
        if ($process) {
            Stop-Process -Id $process -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2
        }
    } catch {
        Write-Host "无法停止占用端口的进程" -ForegroundColor Red
    }
}

# 启动Python HTTP服务器
Write-Host "启动Python HTTP服务器在端口 $Port..." -ForegroundColor Yellow
Write-Host "访问地址: http://localhost:$Port" -ForegroundColor Cyan

try {
    Start-Process -FilePath $pythonPath -ArgumentList "-m", "http.server", $Port -WindowStyle Hidden
    Write-Host "✓ Python HTTP服务器已启动" -ForegroundColor Green
    
    # 等待服务器启动
    Start-Sleep -Seconds 3
    
    # 测试服务器
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:$Port" -Method GET -TimeoutSec 5
        Write-Host "✓ 服务器测试成功 (状态码: $($response.StatusCode))" -ForegroundColor Green
    } catch {
        Write-Host "⚠ 服务器测试失败，但进程可能仍在启动中" -ForegroundColor Yellow
    }
    
} catch {
    Write-Host "✗ 启动Python HTTP服务器失败: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=== 启动完成 ===" -ForegroundColor Green 