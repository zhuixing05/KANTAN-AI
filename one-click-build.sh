#!/bin/bash

# ============================================
# KANTAN AI - 一键修复并打包脚本
# ============================================

cd /home/kantan/KANTAN-AI

echo "========================================"
echo "KANTAN AI 一键修复并打包脚本"
echo "========================================"
echo ""

# 1. 修复配置文件
echo "[1/4] 修复配置文件..."
python3 << 'PYTHON_EOF'
import json
config_path = "/home/kantan/KANTAN-AI/electron-builder.json"
try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
    if 'linux' in config and 'desktop' in config['linux']:
        desktop = config['linux']['desktop']
        keys_to_move = ['Name', 'Comment', 'Terminal', 'Type', 'Categories', 'Icon', 'Exec', 'StartupNotify']
        moved_keys = []
        if 'entry' not in desktop:
            desktop['entry'] = {}
        for key in keys_to_move:
            if key in desktop:
                desktop['entry'][key] = desktop.pop(key)
                moved_keys.append(key)
        if moved_keys:
            with open(config_path, 'w', encoding='utf-8') as f:
                json.dump(config, f, indent=2, ensure_ascii=False)
            print(f"✓ 配置文件已修复")
        else:
            print(f"✓ 配置文件无需修复")
except Exception as e:
    print(f"✗ 配置文件修复失败: {e}")
PYTHON_EOF

# 2. 安装编译工具
echo "[2/4] 检查编译工具..."
if ! command -v gcc &> /dev/null; then
    echo "安装编译工具..."
    echo "123456" | sudo -S apt-get update
    echo "123456" | sudo -S apt-get install -y build-essential python3 python3-pip python3-distutils libtool nasm autoconf automake pkg-config
fi
echo "✓ 编译工具就绪"

# 3. 清理并安装依赖
echo "[3/4] 清理并安装依赖..."
rm -rf dist dist-electron release node_modules package-lock.json
npm install
echo "✓ 依赖安装完成"

# 4. 打包
echo "[4/4] 开始打包..."
npm run dist:linux

echo ""
echo "========================================"
if [ $? -eq 0 ]; then
    echo "✓ 打包成功！"
    ls -lh release/*.deb
else
    echo "✗ 打包失败"
fi
echo "========================================"