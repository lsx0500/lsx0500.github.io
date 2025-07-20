# 测试图案生成功能
Write-Host "🎨 测试图案生成功能" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Cyan

# 检查文件是否存在
Write-Host "1. 检查关键文件:" -ForegroundColor Yellow
$files = @("index.html", "wait-deployment.html")
foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "✅ $file 存在" -ForegroundColor Green
    } else {
        Write-Host "❌ $file 不存在" -ForegroundColor Red
    }
}

# 启动本地服务器
Write-Host "`n2. 启动本地服务器:" -ForegroundColor Yellow
Write-Host "正在启动Python HTTP服务器..." -ForegroundColor Cyan

try {
    Start-Process -FilePath "python" -ArgumentList "-m", "http.server", "8000" -WindowStyle Hidden
    Write-Host "✅ 服务器已启动在 http://localhost:8000" -ForegroundColor Green
    Write-Host "请在浏览器中访问并测试图案生成功能" -ForegroundColor Cyan
} catch {
    Write-Host "❌ 启动服务器失败: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请手动运行: python -m http.server 8000" -ForegroundColor Yellow
}

Write-Host "`n3. 测试步骤:" -ForegroundColor Yellow
Write-Host "1. 打开 http://localhost:8000" -ForegroundColor Cyan
Write-Host "2. 选择心形图案，输入文字'11'" -ForegroundColor Cyan
Write-Host "3. 点击生成按钮" -ForegroundColor Cyan
Write-Host "4. 等待部署完成" -ForegroundColor Cyan
Write-Host "5. 点击查看按钮，检查图案是否正确显示" -ForegroundColor Cyan
Write-Host "6. 查看浏览器控制台的调试信息" -ForegroundColor Cyan

Write-Host "`n🎯 如果图案显示异常，请检查:" -ForegroundColor Yellow
Write-Host "- 控制台是否有错误信息" -ForegroundColor Gray
Write-Host "- URL参数是否正确传递" -ForegroundColor Gray
Write-Host "- CSS样式是否正确应用" -ForegroundColor Gray
Write-Host "- 颜色值是否正确解码" -ForegroundColor Gray

Write-Host "`n按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 