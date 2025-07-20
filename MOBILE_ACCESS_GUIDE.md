# 📱 手机访问图案生成器指南

## 🚨 问题描述
手机访问图案生成器时显示 "failed to fetch" 错误，这是因为手机无法访问电脑的 `localhost:8080` 后端服务。

## 🔧 解决方案

### 1. 检查网络配置
确保手机和电脑在同一个WiFi网络中。

### 2. 获取电脑IP地址
```powershell
# 在电脑上运行以下命令获取IP地址
ipconfig | findstr "IPv4"
```

你的电脑IP地址是: **192.168.3.156**

### 3. 启动服务（重要！）

#### 方法一：使用启动脚本
```powershell
# 以管理员身份运行PowerShell，然后执行：
.\start-mobile.ps1
```

#### 方法二：手动启动
```powershell
# 1. 启动后端服务（监听所有网络接口）
cd core/backend
mvn spring-boot:run

# 2. 启动前端服务（监听所有网络接口）
python -m http.server 8000 --bind 0.0.0.0
```

### 4. 配置防火墙
如果无法访问，需要开放端口：

```powershell
# 以管理员身份运行
New-NetFirewallRule -DisplayName "Pattern Generator Frontend" -Direction Inbound -Protocol TCP -LocalPort 8000 -Action Allow -Profile Private
New-NetFirewallRule -DisplayName "Pattern Generator Backend" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow -Profile Private
```

### 5. 手机访问地址

#### 图案生成器主页
```
http://192.168.3.156:8000
```

#### IP检测工具
```
http://192.168.3.156:8000/get-ip.html
```

## 🧪 测试步骤

### 1. 测试电脑本地访问
```powershell
# 测试前端服务
Invoke-WebRequest -Uri "http://localhost:8000" -Method GET

# 测试后端服务
Invoke-RestMethod -Uri "http://localhost:8080/api/generate/health" -Method GET
```

### 2. 测试手机访问
在手机浏览器中访问：
```
http://192.168.3.156:8000
```

### 3. 测试后端API
在手机浏览器中访问：
```
http://192.168.3.156:8080/api/generate/health
```

## 🔍 故障排除

### 问题1：无法连接到服务器
**解决方案：**
1. 检查防火墙设置
2. 确保服务正在运行
3. 检查网络连接

### 问题2：显示 "failed to fetch"
**解决方案：**
1. 确保后端服务正在运行
2. 检查IP地址是否正确
3. 确保手机和电脑在同一网络

### 问题3：端口被占用
**解决方案：**
```powershell
# 查看端口占用
netstat -ano | findstr ":8000"
netstat -ano | findstr ":8080"

# 结束占用进程
taskkill /PID <进程ID> /F
```

## 📋 完整启动步骤

### 步骤1：以管理员身份运行PowerShell

### 步骤2：启动服务
```powershell
# 进入项目目录
cd "D:\代码\git\test-clone\lsx0500.github.io"

# 启动后端服务
Start-Process powershell -ArgumentList "-Command", "cd '$PWD\core\backend'; mvn spring-boot:run" -WindowStyle Hidden

# 等待后端启动
Start-Sleep -Seconds 10

# 启动前端服务
Start-Process powershell -ArgumentList "-Command", "cd '$PWD'; python -m http.server 8000 --bind 0.0.0.0" -WindowStyle Hidden

# 等待前端启动
Start-Sleep -Seconds 5
```

### 步骤3：测试服务
```powershell
# 测试前端
Invoke-WebRequest -Uri "http://192.168.3.156:8000" -Method GET

# 测试后端
Invoke-RestMethod -Uri "http://192.168.3.156:8080/api/generate/health" -Method GET
```

### 步骤4：手机访问
在手机浏览器中访问：
```
http://192.168.3.156:8000
```

## 🎯 成功标志

当手机可以正常访问时，你应该看到：
1. ✅ 图案生成器页面正常加载
2. ✅ 可以填写表单并生成图案
3. ✅ 生成图案后显示部署等待页面
4. ✅ 8分钟后可以查看生成的图案

## 📞 如果仍有问题

1. **检查网络连接**：确保手机和电脑在同一WiFi
2. **重启服务**：关闭所有服务后重新启动
3. **检查防火墙**：确保8000和8080端口已开放
4. **使用IP检测工具**：访问 `http://192.168.3.156:8000/get-ip.html`

## 🎉 成功后的使用

手机成功访问后，你可以：
1. 在手机上生成各种图案
2. 等待8分钟部署完成
3. 查看生成的动画效果
4. 分享给朋友使用

现在手机应该可以正常使用图案生成器了！ 