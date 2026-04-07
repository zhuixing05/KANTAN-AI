# KANTAN AI Linux deb 包打包 - 完整解决方案



## 📁 生成的文件列表

### 🚀 主要脚本

1. **kantan-auto-build.sh** ⭐ (推荐使用)
   - 完整自动化修复和打包脚本
   - 包含所有必要的修复步骤

2. **auto-build.sh**
   - 功能与 kantan-auto-build.sh 相同

3. **complete-build.sh**
   - 功能与 kantan-auto-build.sh 相同

4. **fix-config-only.sh**
   - 仅修复 electron-builder.json 配置文件

5. **one-click-build.sh**
   - 一键构建脚本（简化版）

6. **启动打包工具.sh** ⭐ (交互式菜单)
   - 交互式菜单，方便选择操作

### 📚 文档

7. **打包指南.md**
   - 详细的打包说明文档
   - 包含常见问题解决方案

8. **README.md** (本文件)
   - 完整解决方案总结

## 🚀 快速开始

### 方法一：使用交互式菜单（最简单）

```bash
cd /home/kantan
chmod +x 启动打包工具.sh
./启动打包工具.sh
```

然后选择选项 `[1] 完整自动化修复和打包`

### 方法二：直接运行完整脚本

```bash
cd /home/kantan
chmod +x kantan-auto-build.sh
./kantan-auto-build.sh
```

## 📋 已修复的问题

### ✅ 问题 1: Node.js 版本过低
- **原因**：项目要求 Node.js >= 22.12.0，但系统使用的是 v18.19.1
- **解决方案**：脚本会自动升级 Node.js 到 v22

### ✅ 问题 2: node-gyp 编译失败
- **原因**：缺少编译工具（gcc, g++, make, python3等）
- **解决方案**：脚本会自动安装 build-essential 和相关工具

### ✅ 问题 3: electron-builder 配置错误
- **原因**：`linux.desktop` 配置格式过时
- **解决方案**：脚本会自动修复配置文件，将属性移动到 `entry` 对象中

## 🔧 脚本功能详解

### kantan-auto-build.sh 执行流程：

```
[步骤 1/5] 修复 electron-builder.json 配置文件
  ↓
[步骤 2/5] 检查并安装编译工具
  ↓
[步骤 3/5] 清理旧的构建文件
  ↓
[步骤 4/5] 安装项目依赖
  ↓
[步骤 5/5] 开始打包 Linux deb 包
  ↓
显示打包结果
```

## ✅ 预期结果

### 成功输出示例：
```
###############################################################################
                              打包结果
###############################################################################
✓ 打包成功！

生成的文件:
total 150M
-rw-r--r-- 1 kantan kantan 150M Apr  7 14:30 kantan-ai_2026.4.6_amd64.deb

###############################################################################
                              deb 包信息
###############################################################################

deb 包路径:
release/kantan-ai_2026.4.6_amd64.deb

安装命令: sudo dpkg -i release/kantan-ai_2026.4.6_amd64.deb
###############################################################################
```

## 📦 安装 deb 包

打包成功后，使用以下命令安装：

```bash
# 进入项目目录
cd /home/kantan/KANTAN-AI

# 安装 deb 包
sudo dpkg -i release/kantan-ai_2026.4.6_amd64.deb

# 如果遇到依赖问题，运行：
sudo apt-get install -f
```

## 🔍 常见问题

### 1. 权限问题
**错误**：`Permission denied`
**解决**：`chmod +x 脚本名.sh`

### 2. Node.js 版本过低
**错误**：`Node.js version too old`
**解决**：脚本会自动升级，或手动运行：
```bash
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -S bash -
sudo apt-get install -y nodejs
```

### 3. 编译工具缺失
**错误**：`node-gyp failed to rebuild`
**解决**：脚本会自动安装，或手动运行：
```bash
sudo apt-get install -y build-essential python3 python3-pip python3-distutils
```

### 4. 配置文件错误
**错误**：`Invalid configuration object`
**解决**：脚本会自动修复，或手动运行：
```bash
./fix-config-only.sh
```

### 5. 磁盘空间不足
**错误**：`No space left on device`
**解决**：清理磁盘空间
```bash
sudo apt-get clean
npm cache clean --force
rm -rf /home/kantan/KANTAN-AI/dist /home/kantan/KANTAN-AI/release
```

## 📊 系统要求

- **操作系统**：Debian 11 或兼容的 Linux 发行版
- **Node.js**：>= 22.12.0（脚本会自动升级）
- **磁盘空间**：至少 2GB 可用空间
- **内存**：建议 4GB 以上
- **网络**：需要访问 npm 和 apt 源

## 🎯 使用建议

### 首次打包
使用 `kantan-auto-build.sh` 或交互式菜单选项 `[1]`

### 代码更新后打包
如果只是代码更新，可以直接运行：
```bash
cd /home/kantan/KANTAN-AI
npm run dist:linux
```

### 遇到问题
重新运行 `kantan-auto-build.sh` 清理并重新构建

### 查看日志
构建日志会保存在 `build-output.log`

## 📞 获取帮助

1. 查看详细指南：`cat /home/kantan/打包指南.md`
2. 查看构建日志：`cat /home/kantan/KANTAN-AI/build-output.log`
3. 检查系统环境：运行交互式菜单选项 `[5]`

## 🎉 开始打包

现在你可以选择以下任一方式开始打包：

### 方式一：交互式菜单（推荐）
```bash
cd /home/kantan
chmod +x 启动打包工具.sh
./启动打包工具.sh
```

### 方式二：直接运行
```bash
cd /home/kantan
chmod +x kantan-auto-build.sh
./kantan-auto-build.sh
```


祝打包成功！🚀

---

如有任何问题，请查看 `打包指南.md` 获取更多帮助。
