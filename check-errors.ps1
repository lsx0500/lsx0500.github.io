# Error Check Script
# Checks for common issues in the project
# Author: lsx0500

param(
    [string]$ProjectRoot = $PWD
)

Write-Host "=== Error Check Report ===" -ForegroundColor Green
Write-Host "Project Root: $ProjectRoot" -ForegroundColor Yellow

# Function to check file existence
function Test-FileExists {
    param([string]$Path, [string]$Description)
    if (Test-Path $Path) {
        Write-Host "OK $Description: $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR $Description: $Path (NOT FOUND)" -ForegroundColor Red
        return $false
    }
}

# Function to check directory existence
function Test-DirectoryExists {
    param([string]$Path, [string]$Description)
    if (Test-Path $Path) {
        Write-Host "OK $Description: $Path" -ForegroundColor Green
        return $true
    } else {
        Write-Host "ERROR $Description: $Path (NOT FOUND)" -ForegroundColor Red
        return $false
    }
}

# 1. Check Git repository
Write-Host "`n1. Git Repository Check:" -ForegroundColor Cyan
$gitExists = Test-Path ".git"
if ($gitExists) {
    Write-Host "✅ Git repository found" -ForegroundColor Green
    
    # Check current branch
    $currentBranch = git branch --show-current
    Write-Host "   Current branch: $currentBranch" -ForegroundColor Yellow
    
    # Check remote
    $remote = git remote get-url origin
    if ($remote) {
        Write-Host "   Remote URL: $remote" -ForegroundColor Yellow
    } else {
        Write-Host "   ❌ No remote configured" -ForegroundColor Red
    }
} else {
    Write-Host "❌ Git repository not found" -ForegroundColor Red
}

# 2. Check essential files
Write-Host "`n2. Essential Files Check:" -ForegroundColor Cyan
$filesToCheck = @(
    @{Path="index.html"; Description="Main page"},
    @{Path="README.md"; Description="README file"},
    @{Path="start.ps1"; Description="Start script"},
    @{Path="sync-realtime.ps1"; Description="Real-time sync script"},
    @{Path="scripts/sync-to-git.ps1"; Description="Git sync script"},
    @{Path="scripts/start-server.ps1"; Description="Server script"}
)

$fileErrors = 0
foreach ($file in $filesToCheck) {
    if (-not (Test-FileExists $file.Path $file.Description)) {
        $fileErrors++
    }
}

# 3. Check directories
Write-Host "`n3. Directory Structure Check:" -ForegroundColor Cyan
$dirsToCheck = @(
    @{Path="core"; Description="Core directory"},
    @{Path="core/frontend"; Description="Frontend directory"},
    @{Path="core/backend"; Description="Backend directory"},
    @{Path="effects"; Description="Effects directory"},
    @{Path="scripts"; Description="Scripts directory"},
    @{Path="logs"; Description="Logs directory"},
    @{Path="temp"; Description="Temp directory"}
)

$dirErrors = 0
foreach ($dir in $dirsToCheck) {
    if (-not (Test-DirectoryExists $dir.Path $dir.Description)) {
        $dirErrors++
    }
}

# 4. Check template files
Write-Host "`n4. Template Files Check:" -ForegroundColor Cyan
$templatesToCheck = @(
    @{Path="effects/heart/heart_01.html"; Description="Heart template"},
    @{Path="effects/star/star_01.html"; Description="Star template"},
    @{Path="effects/text/text_01.html"; Description="Text template"}
)

$templateErrors = 0
foreach ($template in $templatesToCheck) {
    if (-not (Test-FileExists $template.Path $template.Description)) {
        $templateErrors++
    }
}

# 5. Check PowerShell execution policy
Write-Host "`n5. PowerShell Configuration Check:" -ForegroundColor Cyan
$executionPolicy = Get-ExecutionPolicy
Write-Host "   Execution Policy: $executionPolicy" -ForegroundColor Yellow

if ($executionPolicy -eq "Restricted") {
    Write-Host "   ⚠️  Execution policy is restricted. Scripts may not run." -ForegroundColor Yellow
}

# 6. Check Java environment (if backend exists)
Write-Host "`n6. Java Environment Check:" -ForegroundColor Cyan
if (Test-Path "core/backend") {
    try {
        $javaVersion = java -version 2>&1 | Select-String "version"
        if ($javaVersion) {
            Write-Host "   ✅ Java found: $javaVersion" -ForegroundColor Green
        } else {
            Write-Host "   ❌ Java not found" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ❌ Java not found" -ForegroundColor Red
    }
} else {
    Write-Host "   ⏭️  Backend directory not found, skipping Java check" -ForegroundColor Yellow
}

# 7. Check port availability
Write-Host "`n7. Port Availability Check:" -ForegroundColor Cyan
$portsToCheck = @(8000, 8001, 8080)
foreach ($port in $portsToCheck) {
    $portInUse = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
    if ($portInUse) {
        Write-Host "   ⚠️  Port $port is in use" -ForegroundColor Yellow
    } else {
        Write-Host "   ✅ Port $port is available" -ForegroundColor Green
    }
}

# Summary
Write-Host "`n=== Summary ===" -ForegroundColor Green
$totalErrors = $fileErrors + $dirErrors + $templateErrors

if ($totalErrors -eq 0) {
    Write-Host "✅ No critical errors found!" -ForegroundColor Green
} else {
    Write-Host "❌ Found $totalErrors critical errors:" -ForegroundColor Red
    Write-Host "   - File errors: $fileErrors" -ForegroundColor Red
    Write-Host "   - Directory errors: $dirErrors" -ForegroundColor Red
    Write-Host "   - Template errors: $templateErrors" -ForegroundColor Red
}

Write-Host "`nRecommendations:" -ForegroundColor Cyan
if ($totalErrors -gt 0) {
    Write-Host "1. Fix missing files and directories" -ForegroundColor Yellow
}
if ($executionPolicy -eq "Restricted") {
    Write-Host "2. Set execution policy: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
}
if (-not $gitExists) {
    Write-Host "3. Initialize Git repository: git init" -ForegroundColor Yellow
}

Write-Host "`nError check completed!" -ForegroundColor Green 