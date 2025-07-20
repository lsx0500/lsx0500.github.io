# Start Script - Launch real-time sync and local server
# Author: lsx0500

param(
    [string]$ProjectRoot = $PWD,
    [switch]$NoSync = $false
)

Write-Host "=== lsx0500 Pattern Generator System ===" -ForegroundColor Green
Write-Host "Starting system..." -ForegroundColor Yellow

# Create necessary directories
$directories = @("logs", "temp", "core/frontend/generated")
foreach ($dir in $directories) {
    if (-not (Test-Path "$ProjectRoot/$dir")) {
        New-Item -Path "$ProjectRoot/$dir" -ItemType Directory -Force | Out-Null
        Write-Host "Created directory: $dir" -ForegroundColor Cyan
    }
}

# Start real-time sync in background (if not disabled)
if (-not $NoSync) {
    Write-Host "Starting real-time Git sync..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-File", "$ProjectRoot/sync-realtime.ps1", "-ProjectRoot", $ProjectRoot -WindowStyle Minimized
    Write-Host "Real-time sync started in background" -ForegroundColor Green
}

# Start local HTTP server
Write-Host "Starting local HTTP server..." -ForegroundColor Yellow
$port = 8000

# Check if port is available
$portInUse = Get-NetTCPConnection -LocalPort $port -ErrorAction SilentlyContinue
if ($portInUse) {
    $port = 8001
    Write-Host "Port 8000 in use, using port $port" -ForegroundColor Yellow
}

# Start Python HTTP server if available
try {
    python --version | Out-Null
    Write-Host "Starting Python HTTP server on port $port..." -ForegroundColor Green
    Start-Process PowerShell -ArgumentList "-Command", "cd '$ProjectRoot'; python -m http.server $port" -WindowStyle Minimized
    Write-Host "Server started at: http://localhost:$port" -ForegroundColor Green
} catch {
    # Fallback to PowerShell HTTP server
    Write-Host "Python not found, using PowerShell HTTP server..." -ForegroundColor Yellow
    Start-Process PowerShell -ArgumentList "-File", "$ProjectRoot/scripts/start-server.ps1", "-Port", $port -WindowStyle Minimized
    Write-Host "Server started at: http://localhost:$port" -ForegroundColor Green
}

Write-Host "`nSystem is ready!" -ForegroundColor Green
Write-Host "Access your system at: http://localhost:$port" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop all services" -ForegroundColor Yellow

# Keep script running
try {
    while ($true) {
        Start-Sleep -Seconds 10
    }
} catch {
    Write-Host "`nStopping services..." -ForegroundColor Yellow
    
    # Stop background processes
    Get-Process | Where-Object { 
        $_.ProcessName -eq "powershell" -and 
        $_.MainWindowTitle -like "*http*" -or 
        $_.MainWindowTitle -like "*sync*" 
    } | Stop-Process -Force
    
    Write-Host "Services stopped" -ForegroundColor Green
} 