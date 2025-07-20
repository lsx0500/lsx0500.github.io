# 个性化图案HTML生成系统 - 环境初始化脚本
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
    Add-Content -Path "$ProjectRoot/logs/env-init.log" -Value $logMessage -Force
}

# 创建日志目录
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "Starting environment initialization..."

# 检测PowerShell版本
$psVersion = $PSVersionTable.PSVersion
Write-Log "PowerShell version: $psVersion"
if ($psVersion.Major -lt 5) {
    Write-Log "Warning: PowerShell version too low, recommend upgrade to 5.1 or higher" "WARN"
}

# 检测管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Write-Log "Admin privileges: $isAdmin"

# 创建项目目录结构
$directories = @(
    "core/backend",
    "core/frontend",
    "scripts",
    "logs",
    "temp",
    "effects/heart",
    "effects/star",
    "effects/text",
    "core/frontend/generated"
)

foreach ($dir in $directories) {
    $fullPath = "$ProjectRoot/$dir"
    if (-not (Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
        Write-Log "Created directory: $dir"
    }
}

# 检测Java
$javaPath = Get-Command java -ErrorAction SilentlyContinue
if ($javaPath) {
    $javaVersion = & java -version 2>&1 | Select-String "version"
    Write-Log "Java installed: $javaVersion"
} else {
    Write-Log "Java not installed, please install Java 17 or higher" "WARN"
}

# 检测Git
$gitPath = Get-Command git -ErrorAction SilentlyContinue
if ($gitPath) {
    $gitVersion = & git --version
    Write-Log "Git installed: $gitVersion"
} else {
    Write-Log "Git not installed, please install Git" "WARN"
}

# 检测Python
$pythonPath = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonPath) {
    $pythonPath = Get-Command python3 -ErrorAction SilentlyContinue
}
if ($pythonPath) {
    $pythonVersion = & python --version 2>&1
    Write-Log "Python installed: $pythonVersion"
} else {
    Write-Log "Python not installed, please install Python 3.x" "WARN"
}

Write-Log "Environment initialization completed"
Write-Log "Project root directory: $ProjectRoot" 