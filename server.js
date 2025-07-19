const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// 设置模板引擎为EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// 静态文件服务
app.use(express.static(path.join(__dirname, 'public')));

// 特效文件服务
app.use('/effects', express.static(path.join(__dirname, 'effects')));

// 解析请求体
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// 路由
app.get('/', (req, res) => {
  res.render('index', { title: '首页', message: '欢迎访问我的动态网站!' });
});

app.get('/about', (req, res) => {
  res.render('about', { title: '关于我' });
});

// 处理特效制作请求
app.post('/create-effect', (req, res) => {
  const { effectType, primaryColor, secondaryColor, effectSpeed, effectSize } = req.body;
  
  // 生成唯一ID作为特效文件名称
  const effectId = Date.now().toString();
  
  // 创建特效配置对象
  const effectConfig = {
    type: effectType,
    primaryColor,
    secondaryColor,
    speed: parseInt(effectSpeed),
    size: parseInt(effectSize),
    createdAt: new Date().toISOString()
  };
  
  // 引入文件系统模块
  const fs = require('fs');
  const effectsDir = path.join(__dirname, 'effects');
  
  // 确保特效目录存在
  if (!fs.existsSync(effectsDir)) {
    fs.mkdirSync(effectsDir);
  }
  
  // 保存特效配置到文件
  const configFilePath = path.join(effectsDir, `${effectId}.json`);
  fs.writeFileSync(configFilePath, JSON.stringify(effectConfig, null, 2));
  
  // 生成特效HTML文件
  const htmlContent = generateEffectHtml(effectConfig, effectId);
  const htmlFilePath = path.join(effectsDir, `${effectId}.html`);
  fs.writeFileSync(htmlFilePath, htmlContent);
  
  // 生成访问链接
  const effectUrl = `http://localhost:${PORT}/effects/${effectId}.html`;
  
  res.render('submit', { 
    title: '特效生成成功', 
    name: '特效',
    effectUrl
  });
});

// 生成特效HTML文件内容的函数
function generateEffectHtml(config, effectId) {
  return '<!DOCTYPE html>\n<html lang="zh-CN">\n<head>\n    <meta charset="UTF-8">\n    <meta name="viewport" content="width=device-width, initial-scale=1.0">\n    <title>动态特效 #' + effectId + '</title>\n    <style>\n        body {\n            margin: 0;\n            padding: 0;\n            height: 100vh;\n            display: flex;\n            justify-content: center;\n            align-items: center;\n            background-color: #f0f0f0;\n            overflow: hidden;\n        }\n        #effect-container {\n            width: 100%;\n            height: 100%;\n            position: relative;\n        }\n    </style>\n</head>\n<body>\n    <div id="effect-container"></div>\n\n    <script>\n        // 特效配置\n        const config = JSON.parse(' + JSON.stringify(JSON.stringify(config)) + ');\n        \n        // 获取容器\n        const container = document.getElementById(\'effect-container\');\n        \n        // 根据特效类型创建不同的特效\n        if (config.type === \'particle\') {\n            createParticleEffect();\n        } else if (config.type === \'wave\') {\n            createWaveEffect();\n        } else if (config.type === \'glow\') {\n            createGlowEffect();\n        } else if (config.type === \'fade\') {\n            createFadeEffect();\n        }\n        \n        // 粒子效果\n        function createParticleEffect() {\n            // 实现粒子效果的代码\n            for (let i = 0; i < 100; i++) {\n                const particle = document.createElement(\'div\');\n                particle.style.position = \'absolute\';\n                particle.style.width = config.size / 10 + \'px\';\n                particle.style.height = config.size / 10 + \'px\';\n                particle.style.backgroundColor = i % 2 === 0 ? config.primaryColor : config.secondaryColor;\n                particle.style.borderRadius = \'50%\';\n                particle.style.left = Math.random() * 100 + \'%\';\n                particle.style.top = Math.random() * 100 + \'%\';\n                particle.style.opacity = Math.random();\n                container.appendChild(particle);\n                \n                // 动画\n                animateParticle(particle);\n            }\n            \n            function animateParticle(particle) {\n                const duration = 5000 / config.speed;\n                const startX = parseFloat(particle.style.left);\n                const startY = parseFloat(particle.style.top);\n                const endX = Math.random() * 100;\n                const endY = Math.random() * 100;\n                \n                let startTime = null;\n                function step(timestamp) {\n                    if (!startTime) startTime = timestamp;\n                    const progress = Math.min((timestamp - startTime) / duration, 1);\n                    const x = startX + progress * (endX - startX);\n                    const y = startY + progress * (endY - startY);\n                    \n                    particle.style.left = x + \'%\';\n                    particle.style.top = y + \'%\';\n                    \n                    if (progress < 1) {\n                        requestAnimationFrame(step);\n                    } else {\n                        // 重置动画\n                        animateParticle(particle);\n                    }\n                }\n                \n                requestAnimationFrame(step);\n            }\n        }\n        \n        // 波浪效果\n        function createWaveEffect() {\n            // 简化的波浪效果实现\n            const canvas = document.createElement(\'canvas\');\n            canvas.width = container.clientWidth;\n            canvas.height = container.clientHeight;\n            container.appendChild(canvas);\n            \n            const ctx = canvas.getContext(\'2d\');\n            \n            function drawWave() {\n                ctx.clearRect(0, 0, canvas.width, canvas.height);\n                \n                // 绘制波浪\n                ctx.beginPath();\n                ctx.moveTo(0, canvas.height / 2);\n                \n                for (let x = 0; x < canvas.width; x++) {\n                    const y = canvas.height / 2 + \n                        Math.sin(x * 0.01 + Date.now() * 0.001 * config.speed) * config.size;\n                    ctx.lineTo(x, y);\n                }\n                \n                ctx.lineTo(canvas.width, canvas.height);\n                ctx.lineTo(0, canvas.height);\n                ctx.closePath();\n                \n                // 创建渐变\n                const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);\n                gradient.addColorStop(0, config.primaryColor);\n                gradient.addColorStop(1, config.secondaryColor);\n                \n                ctx.fillStyle = gradient;\n                ctx.fill();\n                \n                requestAnimationFrame(drawWave);\n            }\n            \n            drawWave();\n        }\n        \n        // 发光效果\n        function createGlowEffect() {\n            const glow = document.createElement(\'div\');\n            glow.style.width = config.size * 5 + \'px\';\n            glow.style.height = config.size * 5 + \'px\';\n            glow.style.borderRadius = \'50%\';\n            glow.style.backgroundColor = config.primaryColor;\n            glow.style.boxShadow = \'0 0 \' + config.size * 2 + \'px \' + config.size + \'px \' + config.secondaryColor;\n            glow.style.position = \'absolute\';\n            glow.style.left = \'50%\';\n            glow.style.top = \'50%\';\n            glow.style.transform = \'translate(-50%, -50%)\';\n            container.appendChild(glow);\n            \n            // 动画\n            function pulse() {\n                glow.style.animation = \'none\';\n                // 触发重绘\n                void glow.offsetWidth;\n                glow.style.animation = \'pulse \' + (2 / config.speed) + \'s infinite alternate\';\n            }\n            \n            // 添加CSS动画\n            const style = document.createElement(\'style\');\n            style.textContent = \'\n                @keyframes pulse {\n                    0% {\n                        transform: translate(-50%, -50%) scale(0.8);\n                        opacity: 0.5;\n                    }\n                    100% {\n                        transform: translate(-50%, -50%) scale(1.2);\n                        opacity: 1;\n                    }\n                }\n            \';\n            document.head.appendChild(style);\n            \n            pulse();\n        }\n        \n        // 淡入淡出效果\n        function createFadeEffect() {\n            const element = document.createElement(\'div\');\n            element.style.width = \'100%\';\n            element.style.height = \'100%\';\n            element.style.backgroundColor = config.primaryColor;\n            container.appendChild(element);\n            \n            let opacity = 1;\n            let direction = -1; // -1 表示淡出，1 表示淡入\n            \n            function fade() {\n                opacity += direction * 0.01 * config.speed;\n                \n                if (opacity <= 0) {\n                    opacity = 0;\n                    direction = 1;\n                    element.style.backgroundColor = config.secondaryColor;\n                } else if (opacity >= 1) {\n                    opacity = 1;\n                    direction = -1;\n                    element.style.backgroundColor = config.primaryColor;\n                }\n                \n                element.style.opacity = opacity;\n                \n                requestAnimationFrame(fade);\n            }\n            \n            fade();\n        }\n    </script>\n</body>\n</html>';
}

// 404 页面
app.use((req, res) => {
  res.status(404).render('404', { title: '页面不存在' });
});

// 启动服务器
app.listen(PORT, () => {
  console.log(`服务器运行在 http://localhost:${PORT}`);
});