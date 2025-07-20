# 后端服务启动脚本
Write-Host "=== 启动后端API服务 ===" -ForegroundColor Green

# 检查Java是否安装
try {
    $javaVersion = java -version 2>&1
    Write-Host "Java版本: $javaVersion" -ForegroundColor Yellow
} catch {
    Write-Host "错误: 未找到Java，请先安装Java 8或更高版本" -ForegroundColor Red
    exit 1
}

# 检查Maven是否安装
try {
    $mavenVersion = mvn -version 2>&1
    Write-Host "Maven版本: $mavenVersion" -ForegroundColor Yellow
} catch {
    Write-Host "错误: 未找到Maven，请先安装Maven" -ForegroundColor Red
    exit 1
}

# 切换到后端目录
$backendDir = "core/backend"
if (!(Test-Path $backendDir)) {
    Write-Host "错误: 后端目录不存在: $backendDir" -ForegroundColor Red
    exit 1
}

Set-Location $backendDir

# 清理并编译项目
Write-Host "正在编译项目..." -ForegroundColor Yellow
mvn clean compile

if ($LASTEXITCODE -ne 0) {
    Write-Host "编译失败！" -ForegroundColor Red
    exit 1
}

# 启动Spring Boot应用
Write-Host "正在启动后端API服务..." -ForegroundColor Yellow
Write-Host "API地址: http://localhost:8080" -ForegroundColor Green
Write-Host "健康检查: http://localhost:8080/api/generate/health" -ForegroundColor Green

mvn spring-boot:run

Write-Host "后端服务已停止" -ForegroundColor Yellow 