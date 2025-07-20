# 临时文件清理脚本
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
    Add-Content -Path "$ProjectRoot/logs/clean-temp.log" -Value $logMessage -Force
}

# 创建日志目录
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "开始清理临时文件..."

# 清理temp目录中超过24小时的文件
$tempDir = "$ProjectRoot/temp"
if (Test-Path $tempDir) {
    $cutoffTime = (Get-Date).AddDays(-1)
    $oldFiles = Get-ChildItem -Path $tempDir -Recurse | Where-Object { $_.LastWriteTime -lt $cutoffTime }
    
    if ($oldFiles.Count -gt 0) {
        foreach ($file in $oldFiles) {
            try {
                Remove-Item $file.FullName -Recurse -Force
                Write-Log "已删除过期文件: $($file.Name)"
            } catch {
                Write-Log "删除文件失败: $($file.Name) - $($_.Exception.Message)" "ERROR"
            }
        }
        Write-Log "清理完成，共删除 $($oldFiles.Count) 个过期文件"
    } else {
        Write-Log "没有找到需要清理的过期文件"
    }
} else {
    Write-Log "temp目录不存在，跳过清理"
}

# 清理日志文件（保留最近7天的）
$logsDir = "$ProjectRoot/logs"
if (Test-Path $logsDir) {
    $cutoffTime = (Get-Date).AddDays(-7)
    $oldLogs = Get-ChildItem -Path $logsDir -Filter "*.log" | Where-Object { $_.LastWriteTime -lt $cutoffTime }
    
    if ($oldLogs.Count -gt 0) {
        foreach ($log in $oldLogs) {
            try {
                Remove-Item $log.FullName -Force
                Write-Log "已删除过期日志: $($log.Name)"
            } catch {
                Write-Log "删除日志失败: $($log.Name) - $($_.Exception.Message)" "ERROR"
            }
        }
        Write-Log "日志清理完成，共删除 $($oldLogs.Count) 个过期日志文件"
    } else {
        Write-Log "没有找到需要清理的过期日志文件"
    }
}

Write-Log "临时文件清理完成" 