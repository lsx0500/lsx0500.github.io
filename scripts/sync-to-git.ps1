# Git Sync Script - Auto commit and push generated files
# Author: lsx0500
# Date: 2025-01-27

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectRoot,
    
    [Parameter(Mandatory=$true)]
    [string]$filename,
    
    [string]$commitMessage = ""
)

# Log function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$ProjectRoot/logs/git-sync.log" -Value $logMessage -Force
}

# Create logs directory
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "Starting Git sync operation..."

# Change to project directory
Set-Location "$ProjectRoot" -ErrorAction Stop

# Check Git repository status
if (-not (Test-Path ".git")) {
    Write-Log "Error: Current directory is not a Git repository" "ERROR"
    exit 1
}

# Add generated file
$generatedFile = "core/frontend/generated/$filename"
if (Test-Path $generatedFile) {
    git add $generatedFile
    Write-Log "Added file: $generatedFile"
} else {
    Write-Log "Warning: File not found: $generatedFile" "WARN"
}

# Add all changes (including deleted files)
git add -A
Write-Log "Added all changes"

# Generate commit message
if ([string]::IsNullOrEmpty($commitMessage)) {
    $commitMessage = "Auto-generate: $filename at $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

# Commit changes
try {
    git commit -m $commitMessage
    Write-Log "Committed changes: $commitMessage"
} catch {
    Write-Log "Commit failed: $($_.Exception.Message)" "ERROR"
    exit 1
}

# Push to remote repository
Write-Log "Starting push to remote repository..."
try {
    git push origin main
    Write-Log "Push successful"
} catch {
    Write-Log "Push failed, trying HTTPS protocol..." "WARN"
    
    # Try HTTPS protocol
    git remote set-url origin https://github.com/lsx0500/lsx0500.github.io.git
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Log "HTTPS push successful"
    } else {
        Write-Log "Push failed: $($_.Exception.Message)" "ERROR"
        exit 1
    }
}

Write-Log "Git sync operation completed" 