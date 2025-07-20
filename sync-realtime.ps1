# Real-time Git Sync Script
# Monitors file changes and automatically syncs to Git
# Author: lsx0500

param(
    [string]$ProjectRoot = $PWD,
    [int]$Interval = 30  # Check interval in seconds
)

# Log function
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    Write-Host $logMessage
    Add-Content -Path "$ProjectRoot/logs/realtime-sync.log" -Value $logMessage -Force
}

# Create logs directory
if (-not (Test-Path "$ProjectRoot/logs")) {
    New-Item -Path "$ProjectRoot/logs" -ItemType Directory -Force | Out-Null
}

Write-Log "Starting real-time Git sync monitoring..."
Write-Log "Project root: $ProjectRoot"
Write-Log "Check interval: $Interval seconds"

# Change to project directory
Set-Location $ProjectRoot -ErrorAction Stop

# Check if this is a Git repository
if (-not (Test-Path ".git")) {
    Write-Log "Error: Not a Git repository" "ERROR"
    exit 1
}

# Get current branch
$currentBranch = git branch --show-current
Write-Log "Current branch: $currentBranch"

# Get initial state
$lastState = Get-ChildItem -Recurse -File | Where-Object { 
    $_.FullName -notlike "*\.git\*" -and 
    $_.FullName -notlike "*\logs\*" -and
    $_.FullName -notlike "*\temp\*" -and
    $_.FullName -notlike "*\target\*"
} | ForEach-Object { 
    "$($_.FullName)|$($_.LastWriteTime)|$($_.Length)" 
} | Sort-Object

Write-Log "Initial state captured. Monitoring for changes..."

# Monitor loop
while ($true) {
    try {
        # Get current state
        $currentState = Get-ChildItem -Recurse -File | Where-Object { 
            $_.FullName -notlike "*\.git\*" -and 
            $_.FullName -notlike "*\logs\*" -and
            $_.FullName -notlike "*\temp\*" -and
            $_.FullName -notlike "*\target\*"
        } | ForEach-Object { 
            "$($_.FullName)|$($_.LastWriteTime)|$($_.Length)" 
        } | Sort-Object

        # Compare states
        if ($currentState -ne $lastState) {
            Write-Log "Changes detected. Starting sync..."
            
            # Get Git status
            $gitStatus = git status --porcelain
            
            if ($gitStatus) {
                Write-Log "Changes found:"
                $gitStatus | ForEach-Object { Write-Log "  $_" }
                
                # Add all changes
                git add -A
                Write-Log "Added all changes"
                
                # Commit with timestamp
                $commitMessage = "Auto-sync: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
                git commit -m $commitMessage
                Write-Log "Committed: $commitMessage"
                
                # Push to remote - always use main branch for GitHub Pages
                try {
                    git push origin main
                    Write-Log "Push successful to main branch"
                } catch {
                    Write-Log "Push failed, trying HTTPS..." "WARN"
                    git remote set-url origin https://github.com/lsx0500/lsx0500.github.io.git
                    git push origin main
                    
                    if ($LASTEXITCODE -eq 0) {
                        Write-Log "HTTPS push successful to main branch"
                    } else {
                        Write-Log "Push failed" "ERROR"
                    }
                }
            } else {
                Write-Log "No Git changes detected"
            }
            
            # Update last state
            $lastState = $currentState
        }
        
        # Wait for next check
        Start-Sleep -Seconds $Interval
        
    } catch {
        Write-Log "Error in monitoring loop: $($_.Exception.Message)" "ERROR"
        Start-Sleep -Seconds 10
    }
} 