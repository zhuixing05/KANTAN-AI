#!/bin/bash

# KANTAN AI 启动脚本

cd "/home/deepin/KANTAN-AI"

# 加载nvm
export NVM_DIR="/home/deepin/.nvm"
[ -s "/home/deepin/.config/nvm/nvm.sh" ] && . "/home/deepin/.config/nvm/nvm.sh"

# 使用Node.js 24
nvm use 24

# 启动应用
npm run electron:dev
