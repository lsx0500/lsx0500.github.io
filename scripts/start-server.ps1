# 服务器启动脚本
# 作者: lsx0500
# 日期: 2025-01-27

param(
    [string]$ProjectRoot = $PSScriptRoot
)

# 日志函数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$ProjectRoot/logs/server-start.log" -Value $logMessage -Force
}

# 创建日志目录
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "开始启动服务器..."

# 检查Java是否安装
$javaPath = Get-Command java -ErrorAction SilentlyContinue
if (-not $javaPath) {
    Write-Log "错误: 未找到Java，请先安装Java 17或更高版本" "ERROR"
    exit 1
}

# 检查Maven是否安装
$mvnPath = Get-Command mvn -ErrorAction SilentlyContinue
if (-not $mvnPath) {
    Write-Log "错误: 未找到Maven，请先安装Maven" "ERROR"
    exit 1
}

# 切换到后端目录
Set-Location "$ProjectRoot/core/backend"

Write-Log "切换到后端目录: $ProjectRoot/core/backend"

# 检查是否需要编译
if (-not (Test-Path "target")) {
    Write-Log "开始编译项目..."
    try {
        mvn clean compile
        Write-Log "编译完成"
    } catch {
        Write-Log "编译失败: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

# 启动Spring Boot应用
Write-Log "启动Spring Boot应用..."
try {
    # 使用Maven启动
    mvn spring-boot:run
} catch {
    Write-Log "启动失败: $($_.Exception.Message)" "ERROR"
    exit 1
} 