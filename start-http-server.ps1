# PowerShell HTTP Server
param(
    [int]$Port = 8000
)

Write-Host "Starting HTTP Server on port $Port..." -ForegroundColor Green

# 创建简单的HTTP服务器
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()

Write-Host "HTTP Server started at http://localhost:$Port" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath
        $filePath = Join-Path $PWD $localPath.TrimStart('/')
        
        if ($localPath -eq "/" -or $localPath -eq "") {
            $filePath = Join-Path $PWD "index.html"
        }
        
        if (Test-Path $filePath -PathType Leaf) {
            $content = Get-Content $filePath -Raw -Encoding UTF8
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            $response.StatusCode = 200
        } else {
            $response.StatusCode = 404
        }
        
        $response.Close()
    }
} catch {
    Write-Host "Server error: $($_.Exception.Message)" -ForegroundColor Red
} finally {
    $listener.Stop()
    Write-Host "HTTP Server stopped" -ForegroundColor Yellow
} 