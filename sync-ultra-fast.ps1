# 超高速实时Git同步脚本 - 1ms延迟
param(
    [string]$ProjectRoot = $PSScriptRoot,
    [string]$WatchPath = "$ProjectRoot/core/frontend/generated",
    [int]$CheckInterval = 1  # 1毫秒检查间隔
)

Write-Host "🚀 启动超高速实时Git同步 (1ms延迟)" -ForegroundColor Green
Write-Host "监控路径: $WatchPath" -ForegroundColor Yellow
Write-Host "检查间隔: ${CheckInterval}ms" -ForegroundColor Yellow

# 确保日志目录存在
$LogDir = "$ProjectRoot/logs"
if (!(Test-Path $LogDir)) {
    New-Item -ItemType Directory -Path $LogDir -Force | Out-Null
}

# 记录上次推送的文件列表
$LastPushedFiles = @{}

function Write-UltraLog {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage -ForegroundColor Cyan
    Add-Content -Path "$LogDir/ultra-sync.log" -Value $logMessage -Encoding UTF8
}

function Get-FileHash {
    param([string]$FilePath)
    if (Test-Path $FilePath) {
        return (Get-FileHash -Path $FilePath -Algorithm MD5).Hash
    }
    return $null
}

function Push-ToGit {
    param([string]$Reason = "Auto-sync")
    
    try {
        # 切换到项目根目录
        Set-Location $ProjectRoot
        
        # 检查是否有变化
        $status = git status --porcelain
        if ($status) {
            Write-UltraLog "检测到变化，开始推送..."
            
            # 添加所有变化
            git add .
            Write-UltraLog "已添加所有变化"
            
            # 提交
            $commitMessage = "$Reason: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss.fff')"
            git commit -m $commitMessage
            Write-UltraLog "已提交: $commitMessage"
            
            # 推送到远程
            git push origin main
            Write-UltraLog "✅ 推送成功到main分支"
            
            return $true
        } else {
            return $false
        }
    }
    catch {
        Write-UltraLog "❌ 推送失败: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

function Check-FileChanges {
    if (!(Test-Path $WatchPath)) {
        Write-UltraLog "监控路径不存在: $WatchPath" "WARN"
        return $false
    }
    
    $currentFiles = Get-ChildItem -Path $WatchPath -File -Recurse | Where-Object { $_.Name -match '\.html$' }
    $hasChanges = $false
    
    foreach ($file in $currentFiles) {
        $filePath = $file.FullName
        $relativePath = $file.FullName.Replace($ProjectRoot, "").TrimStart('\')
        $currentHash = Get-FileHash -FilePath $filePath
        
        if ($LastPushedFiles.ContainsKey($relativePath)) {
            if ($LastPushedFiles[$relativePath] -ne $currentHash) {
                Write-UltraLog "📁 文件变化: $relativePath"
                $LastPushedFiles[$relativePath] = $currentHash
                $hasChanges = $true
            }
        } else {
            Write-UltraLog "🆕 新文件: $relativePath"
            $LastPushedFiles[$relativePath] = $currentHash
            $hasChanges = $true
        }
    }
    
    return $hasChanges
}

# 初始化：记录当前文件状态
Write-UltraLog "初始化文件监控..."
$initialFiles = Get-ChildItem -Path $WatchPath -File -Recurse | Where-Object { $_.Name -match '\.html$' }
foreach ($file in $initialFiles) {
    $relativePath = $file.FullName.Replace($ProjectRoot, "").TrimStart('\')
    $LastPushedFiles[$relativePath] = Get-FileHash -FilePath $file.FullName
}
Write-UltraLog "已监控 $($LastPushedFiles.Count) 个文件"

# 主循环：每1ms检查一次
Write-UltraLog "开始超高速监控循环..."
$iteration = 0

while ($true) {
    $iteration++
    
    try {
        # 检查文件变化
        if (Check-FileChanges) {
            Write-UltraLog "🔥 检测到变化，立即推送..."
            $pushed = Push-ToGit -Reason "Ultra-fast sync"
            
            if ($pushed) {
                Write-UltraLog "⚡ 推送完成，等待部署..."
                # 等待一小段时间让GitHub处理
                Start-Sleep -Milliseconds 100
            }
        }
        
        # 每1000次迭代记录一次状态（约1秒）
        if ($iteration % 1000 -eq 0) {
            Write-UltraLog "监控运行中... (迭代: $iteration)"
        }
        
        # 1ms延迟
        Start-Sleep -Milliseconds $CheckInterval
        
    }
    catch {
        Write-UltraLog "❌ 监控错误: $($_.Exception.Message)" "ERROR"
        Start-Sleep -Milliseconds 1000  # 错误时等待1秒
    }
} 