# lsx0500 - 个性化图案生成系统

一个基于Web的个性化图案生成系统，支持实时Git同步和自动部署。

## 🌟 特性

- **个性化定制**: 支持自定义文字、颜色和图案类型
- **实时同步**: 自动监控文件变化并同步到Git仓库
- **响应式设计**: 完美适配各种设备
- **GitHub Pages**: 可直接在GitHub Pages上运行
- **PowerShell自动化**: 完整的PowerShell脚本支持

## 🚀 快速开始

### 方法1: 直接访问GitHub Pages
访问 [https://lsx0500.github.io](https://lsx0500.github.io) 即可使用系统。

### 方法2: 本地运行

1. **克隆仓库**
   ```bash
   git clone https://github.com/lsx0500/lsx0500.github.io.git
   cd lsx0500.github.io
   ```

2. **启动系统**
   ```powershell
   # 启动完整系统（包含实时同步）
   .\start.ps1
   
   # 仅启动本地服务器（不包含实时同步）
   .\start.ps1 -NoSync
   ```

3. **访问系统**
   打开浏览器访问 `http://localhost:8000`

## 📁 项目结构

```
lsx0500.github.io/
├── index.html                 # 主页面（GitHub Pages入口）
├── start.ps1                  # 启动脚本
├── sync-realtime.ps1          # 实时同步脚本
├── scripts/
│   ├── sync-to-git.ps1        # Git同步脚本
│   ├── start-server.ps1       # HTTP服务器脚本
│   ├── clean-temp.ps1         # 清理脚本
│   └── test-generate.ps1      # 测试脚本
├── core/
│   ├── frontend/              # 前端文件
│   └── backend/               # Spring Boot后端
├── effects/                   # 图案模板
├── logs/                      # 日志文件
└── temp/                      # 临时文件
```

## 🔧 配置说明

### 实时同步配置
- **监控间隔**: 默认30秒检查一次文件变化
- **排除目录**: `.git`, `logs`, `temp`, `target`
- **自动提交**: 检测到变化时自动提交并推送到Git

### 本地服务器配置
- **端口**: 默认8000，如果被占用会自动使用8001
- **服务器**: 优先使用Python HTTP服务器，备选PowerShell服务器

## 📝 使用说明

### 生成图案
1. 选择图案类型（心形、星形、文字特效）
2. 输入自定义文字
3. 设置主色调和背景色
4. 点击"生成图案"按钮
5. 系统会自动生成HTML文件并同步到Git

### 实时同步
- 系统会自动监控项目文件变化
- 检测到变化时自动提交到Git
- 支持SSH和HTTPS两种推送方式
- 详细的日志记录在`logs/`目录

## 🛠️ 开发说明

### 添加新的图案类型
1. 在`effects/`目录下创建新的图案模板
2. 模板中使用以下占位符：
   - `{{USER_TEXT}}`: 用户输入的文字
   - `{{PRIMARY_COLOR}}`: 主色调
   - `{{BG_COLOR}}`: 背景色

### 修改同步配置
编辑`sync-realtime.ps1`文件：
- 修改`$Interval`参数调整检查间隔
- 修改排除目录列表
- 自定义提交信息格式

## 🔍 故障排除

### 常见问题

1. **Git同步失败**
   - 检查网络连接
   - 确认Git凭据配置
   - 查看`logs/realtime-sync.log`

2. **端口被占用**
   - 系统会自动选择其他可用端口
   - 或手动修改`start.ps1`中的端口配置

3. **文件权限问题**
   - 以管理员身份运行PowerShell
   - 检查文件夹权限设置

### 日志文件
- `logs/realtime-sync.log`: 实时同步日志
- `logs/git-sync.log`: Git同步日志
- `logs/server.log`: 服务器日志

## 📄 许可证

本项目采用MIT许可证。

## 🤝 贡献

欢迎提交Issue和Pull Request！

## 📞 联系方式

- GitHub: [lsx0500](https://github.com/lsx0500)
- 项目地址: [lsx0500.github.io](https://lsx0500.github.io)

---

**注意**: 这是一个演示项目，展示了如何构建一个具有实时Git同步功能的Web应用。系统会自动监控文件变化并同步到Git仓库，确保代码的版本控制和部署自动化。 