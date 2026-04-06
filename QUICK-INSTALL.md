# KANTAN AI 快速安装指南

## 一键安装（推荐）

```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/netease-youdao/KantanAI/main/install-kantan-ai.sh

# 赋予执行权限
chmod +x install-kantan-ai.sh

# 运行安装
sudo ./install-kantan-ai.sh
```

## 手动安装

### 如果已有DEB安装包
```bash
# 安装依赖
sudo apt-get update
sudo apt-get install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 \
    xdg-utils libatspi2.0-0 libappindicator3-1 libsecret-1-0

# 安装KANTAN AI
sudo dpkg -i kantan-ai_*.deb

# 修复依赖（如有需要）
sudo apt-get install -f -y
```

### 从源码构建
```bash
# 克隆项目
git clone https://github.com/netease-youdao/KantanAI.git
cd KantanAI

# 安装并构建
npm install
npm run build
npm run build:skills
npm run compile:electron
npm run dist:linux
```

## 安装脚本使用说明

### 基本用法
```bash
# 正常安装（自动下载最新版）
sudo ./install-kantan-ai.sh

# 使用本地安装包
sudo ./install-kantan-ai.sh --local

# 只检查系统兼容性
./install-kantan-ai.sh --check

# 显示帮助信息
./install-kantan-ai.sh --help

# 显示版本信息
./install-kantan-ai.sh --version
```

### 脚本特性
- ✅ 自动检测系统兼容性
- ✅ 自动安装系统依赖
- ✅ 文件完整性校验（MD5）
- ✅ 支持本地和远程安装包
- ✅ 详细的错误提示和解决建议
- ✅ 安装后自动清理缓存

## 启动应用

### 图形界面
- 在应用程序菜单搜索 "KANTAN AI"
- 点击图标启动

### 命令行
```bash
kantan-ai
# 或
/opt/KANTAN AI/kantan-ai
```

## v2026.4.6 新特性

1. **界面优化**
   - 侧边栏新增客服二维码
   - "登录"按钮改为"获取API"
   - 布局更美观，避免元素挤压

2. **功能改进**
   - 点击"获取API"直接访问官网获取API密钥
   - 关于页面联系方式更新
   - 中英文翻译优化

3. **Bug修复**
   - 桌面图标显示优化
   - 图片路径统一处理

## 问题解决

### 常见问题
```bash
# 图标不显示
rm -rf ~/.cache/KANTAN\ AI

# 启动缓慢（首次）
# 首次启动需要初始化，请等待30-60秒

# 依赖缺失
sudo apt-get install -f -y
```

### 获取帮助
- 应用内：点击侧边栏客服二维码
- 官网：https://kantan-ai.com
- 文档：https://docs.kantan-ai.com
- 社区：https://community.kantan-ai.com

## 文件位置

### 安装目录
```
/opt/KANTAN AI/
├── kantan-ai              # 主程序
├── resources/             # 资源文件
└── cfmind/               # OpenClaw运行时
```

### 配置文件
```
~/.config/KANTAN AI/
├── app_config.json       # 应用设置
├── skills/              # 技能配置
└── logs/                # 运行日志
```

## 卸载应用

### 使用卸载脚本（推荐）
```bash
# 下载卸载脚本
curl -O https://raw.githubusercontent.com/netease-youdao/KantanAI/main/uninstall-kantan-ai.sh

# 赋予执行权限
chmod +x uninstall-kantan-ai.sh

# 运行卸载
sudo ./uninstall-kantan-ai.sh
```

### 卸载脚本使用说明
```bash
# 基本卸载（保留配置文件）
sudo ./uninstall-kantan-ai.sh

# 完全卸载（删除所有文件）
sudo ./uninstall-kantan-ai.sh --full

# 模拟运行（不实际执行）
./uninstall-kantan-ai.sh --dry-run

# 显示帮助信息
./uninstall-kantan-ai.sh --help

# 显示版本信息
./uninstall-kantan-ai.sh --version
```

### 手动卸载
```bash
# 卸载软件包
sudo apt-get remove -y kantan-ai

# 完全卸载（包括配置文件）
sudo apt-get purge -y kantan-ai

# 清理残留文件（可选）
sudo rm -rf /opt/KANTAN\ AI
rm -rf ~/.config/KANTAN\ AI
rm -rf ~/.local/share/KANTAN\ AI
rm -rf ~/.cache/KANTAN\ AI
sudo rm -f /usr/share/applications/kantan-ai.desktop
```

---
*安装脚本版本: 1.0.0 | 应用版本: 2026.4.6 | 卸载脚本版本: 1.0.0*