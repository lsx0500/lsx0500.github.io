const path = require('path');
const fs = require('fs');
const { execSync } = require('child_process');

// 要监控的目录
const watchDirs = [
  path.join(__dirname, 'views'),
  path.join(__dirname, 'public'),
  path.join(__dirname, 'effects')
];

// Git仓库目录
const repoDir = __dirname;

// 避免重复提交的标志
let isSyncing = false;
// 存储修改的文件路径
let modifiedFiles = new Set();
// 延迟定时器
let syncTimeout = null;

// 监控文件更改
watchDirs.forEach(dir => {
  if (!fs.existsSync(dir)) {
    console.warn(`目录不存在: ${dir}`);
    return;
  }

  fs.watch(dir, { recursive: true }, (eventType, filename) => {
    if (!filename) return;

    const filePath = path.join(dir, filename);
    console.log(`检测到文件${eventType}: ${filePath}`);

    // 添加到修改的文件集合
    modifiedFiles.add(filePath);

    // 清除之前的定时器，重新计时
    if (syncTimeout) clearTimeout(syncTimeout);

    // 延迟执行同步，避免频繁提交
    syncTimeout = setTimeout(() => {
      if (!isSyncing) {
        syncGit();
      }
    }, 2000);
  });
});

// 同步到Git仓库的函数
function syncGit() {
  isSyncing = true;
  try {
    // 确保在仓库目录中执行命令
    process.chdir(repoDir);

    // 检查是否有修改的文件
    const statusOutput = execSync('git status --porcelain', { encoding: 'utf-8' });
    if (!statusOutput) {
      console.log('没有检测到修改的文件');
      return;
    }

    // 只添加修改的文件
    modifiedFiles.forEach(filePath => {
      const relativePath = path.relative(repoDir, filePath);
      try {
        execSync(`git add ${relativePath}`, { stdio: 'ignore' });
        console.log(`已添加文件: ${relativePath}`);
      } catch (error) {
        console.error(`添加文件失败 ${relativePath}:`, error.message);
      }
    });

    // 清空已处理的修改文件集合
    modifiedFiles.clear();

    // 提交更改
    const commitMessage = `自动提交: ${new Date().toLocaleString()}`;
    try {
      execSync(`git commit -m '${commitMessage}'`, { stdio: 'ignore' });
      console.log('提交成功');
    } catch (error) {
      console.error('提交失败:', error.message);
    }

    // 推送到远程仓库
    try {
      execSync('git push', { stdio: 'ignore' });
      console.log('推送成功');
    } catch (error) {
      console.error('推送失败:', error.message);
    }
  } catch (error) {
    console.error('同步失败:', error.message);
  } finally {
    isSyncing = false;
  }
}