// 个性化特效生成器 - JavaScript交互文件

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('generatorForm');
    const submitBtn = form.querySelector('.submit-btn');
    
    // 表单提交处理
    form.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        // 获取表单数据
        const formData = {
            text: document.getElementById('userText').value.trim(),
            patternType: document.getElementById('patternType').value,
            primaryColor: document.getElementById('primaryColor').value,
            bgColor: document.getElementById('bgColor').value
        };
        
        // 验证表单数据
        if (!formData.text) {
            showError('请输入文字内容');
            return;
        }
        
        if (!formData.patternType) {
            showError('请选择图案类型');
            return;
        }
        
        // 显示加载状态
        setLoadingState(true);
        
        try {
            // 发送请求到后端
            const response = await fetch('/api/generate', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(formData)
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const result = await response.json();
            
            if (result.success) {
                // 跳转到过渡页面
                const params = new URLSearchParams({
                    text: formData.text,
                    patternType: formData.patternType,
                    primaryColor: formData.primaryColor,
                    bgColor: formData.bgColor,
                    filename: result.filename
                });
                
                window.location.href = `loading.html?${params.toString()}`;
            } else {
                showError(result.message || '生成失败，请重试');
            }
            
        } catch (error) {
            console.error('请求失败:', error);
            showError('网络错误，请检查后端服务是否运行');
        } finally {
            setLoadingState(false);
        }
    });
    
    // 设置加载状态
    function setLoadingState(loading) {
        if (loading) {
            form.classList.add('loading');
            submitBtn.textContent = '生成中...';
            submitBtn.disabled = true;
        } else {
            form.classList.remove('loading');
            submitBtn.textContent = '生成特效';
            submitBtn.disabled = false;
        }
    }
    
    // 显示错误信息
    function showError(message) {
        // 移除之前的错误信息
        const existingError = form.querySelector('.error');
        if (existingError) {
            existingError.remove();
        }
        
        // 创建新的错误信息
        const errorDiv = document.createElement('div');
        errorDiv.className = 'error';
        errorDiv.textContent = message;
        
        // 插入到表单末尾
        form.appendChild(errorDiv);
        
        // 3秒后自动移除错误信息
        setTimeout(() => {
            if (errorDiv.parentNode) {
                errorDiv.remove();
            }
        }, 3000);
    }
    
    // 显示成功信息
    function showSuccess(message) {
        // 移除之前的成功信息
        const existingSuccess = form.querySelector('.success');
        if (existingSuccess) {
            existingSuccess.remove();
        }
        
        // 创建新的成功信息
        const successDiv = document.createElement('div');
        successDiv.className = 'success';
        successDiv.textContent = message;
        
        // 插入到表单末尾
        form.appendChild(successDiv);
        
        // 3秒后自动移除成功信息
        setTimeout(() => {
            if (successDiv.parentNode) {
                successDiv.remove();
            }
        }, 3000);
    }
    
    // 实时验证
    const userTextInput = document.getElementById('userText');
    userTextInput.addEventListener('input', function() {
        const value = this.value.trim();
        if (value.length > 50) {
            this.value = value.substring(0, 50);
            showError('文字内容不能超过50个字符');
        }
    });
    
    // 颜色预览
    const primaryColorInput = document.getElementById('primaryColor');
    const bgColorInput = document.getElementById('bgColor');
    
    function updateColorPreview() {
        const primaryColor = primaryColorInput.value;
        const bgColor = bgColorInput.value;
        
        // 这里可以添加颜色预览功能
        console.log('主色调:', primaryColor);
        console.log('背景色:', bgColor);
    }
    
    primaryColorInput.addEventListener('change', updateColorPreview);
    bgColorInput.addEventListener('change', updateColorPreview);
}); 