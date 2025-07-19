// 启动同步脚本
const { execSync } = require('child_process');

console.log('启动Git自动同步工具...');

try {
  // 启动sync-git.js脚本
  execSync('node sync-git.js', { stdio: 'inherit' });
  console.log('Git自动同步工具已成功启动');
} catch (error) {
  console.error('启动Git自动同步工具失败:', error.message);
}