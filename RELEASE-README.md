# KANTAN AI v2026.4.6 发布说明

## 版本信息
- **版本号**: 2026.4.6
- **发布日期**: 2026年4月6日
- **系统要求**: Linux (Debian/Ubuntu/Deepin) amd64
- **安装包大小**: ~200MB

## 新特性与优化

### 🎨 界面改进
1. **侧边栏布局优化**
   - 新增客服二维码，点击可获取技术支持
   - 客服图片单独一行显示，避免挤压
   - "登录"按钮改为"获取API"，更符合产品定位
   - 获取API和设置按钮水平排列，布局更美观

2. **关于页面更新**
   - 更新联系邮箱：`support@kantan-ai.com`
   - 更新用户手册链接：`https://docs.kantan-ai.com`
   - 更新用户社区链接：`https://community.kantan-ai.com`
   - 更新服务条款链接：`https://kantan-ai.com/terms`

3. **Logo显示优化**
   - 桌面图标保持高清晰度显示
   - 应用内Logo路径统一优化

### 🔗 功能优化
1. **获取API功能**
   - 未登录时点击"获取API"直接访问官网
   - 已登录用户保持原有用户菜单功能
   - 支持中英文显示："获取API" / "Get API"

2. **客服支持**
   - 侧边栏新增客服二维码
   - 点击客服图片直接访问 `https://aikantan.com/`
   - 图片尺寸优化，显示更清晰

## 安装方式

### 方法一：一键安装脚本（推荐）
```bash
# 下载安装脚本
curl -O https://raw.githubusercontent.com/your-repo/kantan-ai/main/install-kantan-ai.sh

# 赋予执行权限
chmod +x install-kantan-ai.sh

# 运行安装脚本
sudo ./install-kantan-ai.sh
```

### 方法二：手动安装
```bash
# 下载DEB安装包
wget https://your-domain.com/releases/kantan-ai_2026.4.6_amd64.deb

# 安装依赖
sudo apt-get update
sudo apt-get install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 \
    xdg-utils libatspi2.0-0 libappindicator3-1 libsecret-1-0

# 安装KANTAN AI
sudo dpkg -i kantan-ai_2026.4.6_amd64.deb

# 修复依赖问题（如有）
sudo apt-get install -f -y
```

### 方法三：从源码构建
```bash
# 克隆项目
git clone https://github.com/your-repo/kantan-ai.git
cd kantan-ai

# 安装依赖
npm install

# 构建前端
npm run build

# 构建技能包
npm run build:skills

# 编译Electron主进程
npm run compile:electron

# 生成安装包
npm run dist:linux
```

## 启动方式

### 图形界面
1. 在应用程序菜单中搜索 "KANTAN AI"
2. 点击图标启动应用

### 命令行
```bash
# 方式一：使用全局命令
kantan-ai

# 方式二：直接执行
/opt/KANTAN AI/kantan-ai
```

## 使用说明

### 首次使用
1. 启动应用后，点击侧边栏"获取API"按钮获取API密钥
2. 进入设置页面配置模型提供商（OpenAI、DeepSeek、Anthropic等）
3. 开始使用Cowork模式进行工作

### 主要功能
- **Cowork模式**: 本地执行任务，支持文件操作、命令执行
- **技能管理**: 内置多种生产力技能（文档生成、网页搜索等）
- **定时任务**: 创建周期性任务，自动执行日常工作
- **IM集成**: 支持Telegram、Discord、钉钉、飞书远程控制
- **记忆功能**: 自动学习用户偏好，越用越智能

## 系统要求

### 最低配置
- **操作系统**: Ubuntu 20.04+ / Debian 11+ / Deepin 20+
- **处理器**: 双核CPU
- **内存**: 4GB RAM
- **存储**: 2GB可用空间
- **网络**: 用于API调用和IM集成

### 推荐配置
- **操作系统**: Ubuntu 22.04+ / Debian 12+ / Deepin 23+
- **处理器**: 四核CPU
- **内存**: 8GB RAM
- **存储**: 5GB可用空间
- **显卡**: 集成显卡即可

## 常见问题

### Q1: 安装后图标不显示
```bash
# 清理图标缓存
sudo rm -rf ~/.cache/KANTAN\ AI
# 重启应用
```

### Q2: 缺少依赖包
```bash
# 修复依赖
sudo apt-get install -f -y
```

### Q3: 启动缓慢
首次启动需要初始化环境，可能需要30-60秒，后续启动会变快。

### Q4: API密钥获取
点击侧边栏"获取API"按钮或访问：https://aikantan.com/

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
├── app_config.json       # 应用配置
├── skills/              # 技能配置
└── logs/                # 日志文件
```

### 数据文件
```
~/.local/share/KANTAN AI/
├── sessions/            # 会话数据
├── memory/              # 记忆数据
└── cache/               # 缓存文件
```

## 技术支持

### 官方渠道
- **官方网站**: https://kantan-ai.com
- **用户手册**: https://docs.kantan-ai.com
- **用户社区**: https://community.kantan-ai.com
- **客服支持**: 应用内侧边栏客服二维码

### 问题反馈
1. GitHub Issues: https://github.com/your-repo/kantan-ai/issues
2. 社区论坛: https://community.kantan-ai.com/forum
3. 邮箱联系: support@kantan-ai.com

## 更新日志

### v2026.4.6 (2026-04-06)
- ✅ 侧边栏新增客服二维码
- ✅ "登录"按钮改为"获取API"
- ✅ 界面布局优化，避免元素挤压
- ✅ 关于页面信息更新
- ✅ 桌面图标显示优化
- ✅ 中英文翻译更新
- ✅ 一键安装脚本
- ✅ 一键卸载脚本

### v2026.4.1 (2026-04-01)
- 初始发布版本
- 基础Cowork功能
- IM集成支持
- 技能管理系统

## 卸载说明

### 使用卸载脚本
```bash
# 下载卸载脚本
curl -O https://raw.githubusercontent.com/netease-youdao/KantanAI/main/uninstall-kantan-ai.sh
chmod +x uninstall-kantan-ai.sh
sudo ./uninstall-kantan-ai.sh

# 选项说明
# sudo ./uninstall-kantan-ai.sh --full    # 完全卸载，删除所有配置
# sudo ./uninstall-kantan-ai.sh --dry-run # 模拟运行，不实际删除
```

### 手动卸载
```bash
# 基本卸载
sudo apt-get remove -y kantan-ai

# 完全卸载（包括配置）
sudo apt-get purge -y kantan-ai

# 清理残留文件
sudo rm -rf /opt/KANTAN\ AI
rm -rf ~/.config/KANTAN\ AI
rm -rf ~/.local/share/KANTAN\ AI
rm -rf ~/.cache/KANTAN\ AI
sudo rm -f /usr/share/applications/kantan-ai.desktop
```

## 许可证
MIT License - 详见 [LICENSE](LICENSE) 文件

---

**注意**: 本软件仍在积极开发中，如有问题请及时反馈。
感谢您使用 KANTAN AI！