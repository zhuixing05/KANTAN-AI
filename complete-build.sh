#!/bin/bash

# ============================================
# KANTAN AI - 完整自动化修复和打包脚本
# ============================================
# 功能：
# 1. 自动修复 electron-builder.json 配置文件
# 2. 安装必要的编译工具
# 3. 清理并重新安装依赖
# 4. 执行打包
# ============================================

cd /home/kantan/KANTAN-AI

echo "========================================"
echo "KANTAN AI 完整自动化修复和打包脚本"
echo "========================================"
echo ""

# ============================================
# 步骤1: 修复 electron-builder.json 配置文件
# ============================================
echo "[步骤] 修复 electron-builder.json 配置文件..."
echo "----------------------------------------"

python3 << 'PYTHON_EOF'
import json
import os

config_path = "/home/kantan/KANTAN-AI/electron-builder.json"

try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = json.load(f)
except Exception as e:
    print(f"读取文件失败: {e}")
    exit(1)

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
        print(f"✓ 已修复配置文件。移动了以下属性到 'entry' 对象下: {', '.join(moved_keys)}")
    else:
        print("✓ 配置文件格式正确，无需修复。")
else:
    print("✓ 未找到 linux.desktop 配置，跳过修复。")
PYTHON_EOF

echo ""

# ============================================
# 步骤2: 安装编译工具
# ============================================
echo "[步骤] 检查并安装编译工具..."
echo "----------------------------------------"

# 检查是否已安装 build-essential
if ! command -v gcc &> /dev/null; then
    echo "正在安装编译工具..."
    echo "123456" | sudo -S apt-get update
    echo "123456" | sudo -S apt-get install -y \
        build-essential \
        python3 \
        python3-pip \
        python3-distutils \
        libtool 
        nasm \
        autoconf \
        automake \
        pkg-config
    echo "✓ 编译工具安装完成"
else
    echo "✓ 编译工具已安装"
fi

echo ""

# ============================================
# 步骤3: 清理旧的构建文件
# ============================================
echo "[步骤] 清理旧的构建文件..."
echo "----------------------------------------"
rm -rf dist dist-electron release node_modules package-lock.json
echo "✓ 清理完成"
echo ""

# ============================================
# 步骤4: 安装依赖
# ============================================
echo "[步骤] 安装项目依赖..."
echo "----------------------------------------"
npm install
if [ $? -eq 0 ]; then
    echo "✓ 依赖安装成功"
else
    echo "✗ 依赖安装失败"
    exit 1
fi
echo ""

# ============================================
# 步骤5: 执行打包
# ============================================
echo "[步骤] 开始打包 Linux deb 包..."
echo "----------------------------------------"
echo "这可能需要几分钟时间，请耐心等待..."
echo ""

npm run dist:linux
BUILD_STATUS=$?

echo ""
echo "========================================"
echo "打包结果"
echo "========================================"

if [ $BUILD_STATUS -eq 0 ]; then
    echo "✓ 打包成功！"
    echo ""
    echo "生成的文件:"
    ls -lh release/
    
    if ls release/*.deb 1> /dev/null 2>&1; then
        echo ""
        echo "========================================"
        echo "deb 包路径:"
        ls release/*.deb
        echo ""
        echo "安装命令: sudo dpkg -i $(ls release/*.deb)"
        echo "========================================"
    fi
else
    echo "✗ 打包失败"
    echo ""
    echo "请检查上方的错误信息"
fi

echo ""
echo "脚本执行完毕！"