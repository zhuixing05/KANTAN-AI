#!/bin/bash

###############################################################################
# KANTAN AI - 打包工具启动器
###############################################################################
# 这是一个交互式菜单，帮助你选择合适的打包操作
###############################################################################

clear

echo ""
echo "###############################################################################"
echo "                    KANTAN AI 打包工具启动器"
echo "###############################################################################"
echo ""
echo "请选择要执行的操作:"
echo ""
echo "  [1] 完整自动化修复和打包 (推荐)"
echo "      - 修复配置文件"
echo "      - 安装编译工具"
echo "      - 清理并重新安装依赖"
echo "      - 执行打包"
echo ""
echo "  [2] 仅修复配置文件"
echo "      - 只修复 electron-builder.json 配置"
echo ""
echo "  [3] 一键构建 (简化版)"
echo "      - 快速构建，输出简洁"
echo ""
echo "  [4] 查看打包指南"
echo "      - 显示详细的打包说明文档"
echo ""
echo "  [5] 检查系统环境"
echo "      - 检查 Node.js、npm、编译工具等"
echo ""
echo "  [6] 清理构建文件"
echo "      - 删除 dist、release、node_modules 等"
echo ""
echo "  [0] 退出"
echo ""
echo "###############################################################################"
echo ""

read -p "请输入选项 [0-6]: " choice

case $choice in
    1)
        echo ""
        echo "正在执行完整自动化修复和打包..."
        echo ""
        cd /home/kantan
        chmod +x kantan-auto-build.sh
        ./kantan-auto-build.sh
        ;;
    
    2)
        echo ""
        echo "正在修复配置文件..."
        echo ""
        cd /home/kantan
        chmod +x fix-config-only.sh
        ./fix-config-only.sh
        ;;
    
    3)
        echo ""
        echo "正在执行一键构建..."
        echo ""
        cd /home/kantan
        chmod +x one-click-build.sh
        ./one-click-build.sh
        ;;
    
    4)
        echo ""
        echo "========================================"
        echo "打包指南"
        echo "========================================"
        echo ""
        cat /home/kantan/打包指南.md
        ;;
    
    5)
        echo ""
        echo "========================================"
        echo "系统环境检查"
        echo "========================================"
        echo ""
        
        echo "1. Node.js 版本:"
        node --version 2>&1 || echo "Node.js 未安装"
        echo ""
        
        echo "2. NPM 版本:"
        npm --version 2>&1 || echo "NPM 未安装"
        echo ""
        
        echo "3. 编译工具:"
        if command -v gcc &> /dev/null; then
            echo "✓ GCC 已安装: $(gcc --version | head -n1)"
        else
            echo "✗ GCC 未安装"
        fi
        
        if command -v make &> /dev/null; then
            echo "✓ Make 已安装: $(make --version | head -n1)"
        else
            echo "✗ Make 未安装"
        fi
        echo ""
        
        echo "4. Python 版本:"
        python3 --version 2>&1 || echo "Python3 未安装"
        echo ""
        
        echo "5. 磁盘空间:"
        df -h /home/kantan | tail -n1
        echo ""
        
        echo "6. 项目目录:"
        if [ -d "/home/kantan/KANTAN-AI" ]; then
            echo "✓ 项目目录存在"
            cd /home/kantan/KANTAN-AI
            echo "  - package.json: $([ -f package.json ] && echo '存在' || echo '不存在')"
            echo "  - node_modules: $([ -d node_modules ] && echo '存在' || echo '不存在')"
            echo "  - dist: $([ -d dist ] && echo '存在' || echo '不存在')"
            echo "  - release: $([ -d release ] && echo '存在' || echo '不存在')"
        else
            echo "✗ 项目目录不存在"
        fi
        echo ""
        ;;
    
    6)
        echo ""
        echo "正在清理构建文件..."
        echo ""
        cd /home/kantan/KANTAN-AI
        rm -rf dist dist-electron release node_modules package-lock.json
        echo "✓ 清理完成"
        echo ""
        echo "已删除的目录/文件:"
        echo "  - dist"
        echo "  - dist-electron"
        echo "  - release"
        echo "  - node_modules"
        echo "  - package-lock.json"
        echo ""
        ;;
    
    0)
        echo ""
        echo "退出打包工具"
        echo ""
        exit 0
        ;;
    
    *)
        echo ""
        echo "无效选项，请重新运行脚本"
        echo ""
        ;;
esac

echo ""
echo "按任意键退出..."
read -n1