# 自动化测试脚本 - 模拟用户输入并验证生成流程
# 作者: lsx0500
# 日期: 2025-01-27

param(
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent)
)

# 日志函数
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$ProjectRoot/logs/test-results.log" -Value $logMessage -Force
}

# 创建日志目录
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "Starting automated testing..."

# 测试数据
$testCases = @(
    @{
        text = "I love you"
        patternType = "heart"
        primaryColor = "#ff69b4"
        bgColor = "#000000"
    },
    @{
        text = "Happy Birthday"
        patternType = "star"
        primaryColor = "#ffd700"
        bgColor = "#000000"
    },
    @{
        text = "Happy New Year"
        patternType = "heart"
        primaryColor = "#ff0000"
        bgColor = "#000000"
    }
)

$successCount = 0
$totalCount = $testCases.Count

foreach ($testCase in $testCases) {
    Write-Log "Test case: $($testCase.text) - $($testCase.patternType)"
    
    try {
        # 构建curl命令
        $jsonData = @{
            text = $testCase.text
            patternType = $testCase.patternType
            primaryColor = $testCase.primaryColor
            bgColor = $testCase.bgColor
        } | ConvertTo-Json
        
        # 发送POST请求
        $response = Invoke-RestMethod -Uri "http://localhost:8080/api/generate" `
            -Method POST `
            -ContentType "application/json" `
            -Body $jsonData `
            -ErrorAction Stop
        
        if ($response.success) {
            Write-Log "Test passed: $($response.filename)" "SUCCESS"
            $successCount++
            
            # 验证文件是否生成
            $generatedFile = "$ProjectRoot/core/frontend/generated/$($response.filename)"
            if (Test-Path $generatedFile) {
                Write-Log "File generation verification passed: $generatedFile" "SUCCESS"
            } else {
                Write-Log "File generation verification failed: $generatedFile" "ERROR"
            }
        } else {
            Write-Log "Test failed: $($response.message)" "ERROR"
        }
        
    } catch {
        Write-Log "Test exception: $($_.Exception.Message)" "ERROR"
    }
    
    # 等待一段时间再进行下一个测试
    Start-Sleep -Seconds 2
}

# 测试结果统计
$successRate = [math]::Round(($successCount / $totalCount) * 100, 2)
Write-Log "Test completed: Success $successCount/$totalCount, Success rate: $successRate%"

# 测试本地删除文件同步
Write-Log "Starting local file deletion sync test..."
try {
    $latestFile = Get-ChildItem "$ProjectRoot/core/frontend/generated" | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 1
    
    if ($latestFile) {
        $testDeleteFile = "$ProjectRoot/core/frontend/generated/test_delete.html"
        Copy-Item $latestFile.FullName $testDeleteFile
        
        # 删除文件
        Remove-Item $testDeleteFile -Force
        
        # 执行Git同步
        & "$ProjectRoot/scripts/sync-to-git.ps1" $ProjectRoot "test_delete.html" "测试删除文件"
        
        Write-Log "Local file deletion sync test completed" "SUCCESS"
    } else {
        Write-Log "No files found for testing" "WARN"
    }
} catch {
    Write-Log "Local file deletion sync test failed: $($_.Exception.Message)" "ERROR"
}

Write-Log "Automated testing completed" 