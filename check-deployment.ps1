# GitHub Pages部署状态检查脚本
param(
    [string]$FileName,
    [int]$MaxWaitTime = 120,  # 最大等待时间（秒）
    [int]$CheckInterval = 2   # 检查间隔（秒）
)

function Test-GitHubPagesDeployment {
    param([string]$FileName)
    
    $url = "https://lsx0500.github.io/core/frontend/generated/$FileName"
    
    try {
        $response = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 5 -UseBasicParsing
        return @{
            Available = $true
            StatusCode = $response.StatusCode
            ResponseTime = $response.BaseResponse.ResponseTime
        }
    }
    catch {
        return @{
            Available = $false
            StatusCode = $_.Exception.Response.StatusCode.value__
            Error = $_.Exception.Message
        }
    }
}

function Show-Countdown {
    param([int]$Seconds, [string]$Message)
    
    for ($i = $Seconds; $i -gt 0; $i--) {
        $minutes = [math]::Floor($i / 60)
        $secs = $i % 60
        $timeStr = "{0:D2}:{1:D2}" -f $minutes, $secs
        
        Write-Host "`r⏳ $Message - 剩余时间: $timeStr" -NoNewline -ForegroundColor Yellow
        Start-Sleep -Seconds 1
    }
    Write-Host ""
}

# 主检查逻辑
Write-Host "🔍 开始检查GitHub Pages部署状态" -ForegroundColor Green
Write-Host "文件: $FileName" -ForegroundColor Cyan
Write-Host "最大等待时间: ${MaxWaitTime}秒" -ForegroundColor Yellow

$startTime = Get-Date
$elapsedSeconds = 0

while ($elapsedSeconds -lt $MaxWaitTime) {
    $result = Test-GitHubPagesDeployment -FileName $FileName
    
    if ($result.Available) {
        Write-Host "✅ 部署成功！文件已可访问" -ForegroundColor Green
        Write-Host "URL: https://lsx0500.github.io/core/frontend/generated/$FileName" -ForegroundColor Cyan
        Write-Host "响应时间: $($result.ResponseTime)ms" -ForegroundColor Green
        return $true
    } else {
        $elapsedSeconds = [math]::Round(((Get-Date) - $startTime).TotalSeconds)
        $remainingSeconds = $MaxWaitTime - $elapsedSeconds
        
        if ($remainingSeconds -gt 0) {
            Write-Host "⏳ 部署中... (已等待 $elapsedSeconds s, 剩余 $remainingSeconds s)" -ForegroundColor Yellow
            Show-Countdown -Seconds $CheckInterval -Message "下次检查"
        }
    }
}

Write-Host "❌ 部署超时！文件在${MaxWaitTime}秒内未部署完成" -ForegroundColor Red
return $false 