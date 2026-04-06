#!/bin/bash
# KANTAN AI 一键安装脚本
# 适用于 Debian/Ubuntu/Deepin 系统
# 版本: 1.0.0

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 版本信息
VERSION="2026.4.6"
DEB_FILE="kantan-ai_${VERSION}_amd64.deb"
EXPECTED_MD5="196e66a907bd7d9928a900bd8ac27fa9"

# GitHub release信息（如果需要从GitHub下载）
GITHUB_REPO="netease-youdao/KantanAI"
GITHUB_TAG="v${VERSION}"
GITHUB_URL="https://github.com/${GITHUB_REPO}/releases/download/${GITHUB_TAG}/${DEB_FILE}"

# 脚本参数
USE_LOCAL=false
CHECK_ONLY=false

# 函数：打印带颜色的消息
print_message() {
    echo -e "${GREEN}[KANTAN AI]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

print_step() {
    echo -e "${BLUE}[步骤 $1]${NC} $2"
}

# 检查是否是root用户
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_warning "需要root权限来安装软件包"
        print_message "将使用sudo运行安装命令..."
        return 1
    fi
    return 0
}

# 检查系统要求
check_system() {
    print_step "1" "检查系统要求..."
    
    # 检查是否为Debian/Ubuntu/Deepin系统
    if ! command -v dpkg >/dev/null 2>&1; then
        print_error "未找到dpkg命令，这不是Debian系系统"
        exit 1
    fi
    
    # 检查架构
    ARCH=$(uname -m)
    if [[ "$ARCH" != "x86_64" ]] && [[ "$ARCH" != "amd64" ]]; then
        print_error "只支持amd64架构，当前架构: $ARCH"
        exit 1
    fi
    
    print_message "✓ 系统检查通过"
}

# 检查依赖
check_dependencies() {
    print_step "2" "检查依赖包..."
    
    # 检查curl或wget
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        print_warning "未找到curl或wget，正在安装curl..."
        apt-get update && apt-get install -y curl
    fi
    
    # 检查是否已安装旧版本
    if dpkg -l | grep -q "kantan-ai"; then
        print_message "检测到已安装的旧版本，将进行升级..."
    fi
    
    print_message "✓ 依赖检查完成"
}

# 下载安装包
# 验证文件完整性
verify_package() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        return 1
    fi
    
    print_message "验证文件完整性..."
    local calculated_md5=$(md5sum "$file" | cut -d' ' -f1)
    
    if [[ "$calculated_md5" == "$EXPECTED_MD5" ]]; then
        print_message "✓ 文件校验通过 (MD5: ${calculated_md5:0:8}...)"
        return 0
    else
        print_error "文件校验失败"
        print_error "预期MD5: $EXPECTED_MD5"
        print_error "实际MD5: $calculated_md5"
        return 1
    fi
}

# 下载安装包
download_package() {
    print_step "3" "获取安装包..."
    
    # 如果使用本地模式
    if [[ "$USE_LOCAL" == "true" ]]; then
        print_message "本地模式：只使用当前目录的安装包"
        
        # 检查当前目录
        if [[ -f "$DEB_FILE" ]]; then
            print_message "检测到本地安装包: $DEB_FILE"
            if verify_package "$DEB_FILE"; then
                return
            else
                print_error "本地文件校验失败"
                exit 1
            fi
        else
            print_error "本地模式下未找到安装包: $DEB_FILE"
            print_message "请将安装包放置到当前目录，或移除--local参数"
            exit 1
        fi
    fi
    
    # 检查是否已存在安装包
    if [[ -f "$DEB_FILE" ]]; then
        print_message "检测到本地安装包: $DEB_FILE"
        if verify_package "$DEB_FILE"; then
            print_message "使用本地安装包"
            return
        else
            print_warning "本地文件损坏，将尝试重新获取..."
            rm -f "$DEB_FILE"
        fi
    fi
    
    # 尝试从release目录复制
    if [[ -f "release/$DEB_FILE" ]]; then
        print_message "从release目录复制安装包..."
        cp "release/$DEB_FILE" .
        if verify_package "$DEB_FILE"; then
            print_message "使用release目录的安装包"
            return
        else
            print_warning "release目录文件损坏，将从GitHub下载..."
            rm -f "$DEB_FILE"
        fi
    fi
    
    # 从GitHub下载
    print_message "正在从GitHub Releases下载安装包..."
    print_message "下载地址: $GITHUB_URL"
    
    # 检查下载工具
    local download_tool=""
    if command -v curl >/dev/null 2>&1; then
        download_tool="curl -L -o '$DEB_FILE' '$GITHUB_URL'"
    elif command -v wget >/dev/null 2>&1; then
        download_tool="wget -O '$DEB_FILE' '$GITHUB_URL'"
    else
        print_error "未找到curl或wget，无法下载安装包"
        print_message "请手动下载安装包:"
        print_message "1. 访问: $GITHUB_URL"
        print_message "2. 将文件保存为: $DEB_FILE"
        print_message "3. 重新运行此脚本（可添加--local参数）"
        exit 1
    fi
    
    # 执行下载
    print_message "开始下载，请稍候..."
    if eval "$download_tool"; then
        print_message "✓ 下载完成"
    else
        print_error "下载失败"
        print_message "可能的原因："
        print_message "1. 网络连接问题"
        print_message "2. GitHub上尚未发布此版本"
        print_message ""
        print_message "解决方案："
        print_message "1. 手动下载安装包，然后使用: $0 --local"
        print_message "2. 检查网络连接后重试"
        print_message "3. 从项目仓库获取最新信息"
        exit 1
    fi
    
    # 验证下载的文件
    if verify_package "$DEB_FILE"; then
        print_message "✓ 安装包准备就绪"
    else
        print_error "下载的文件校验失败，可能下载不完整"
        print_message "请检查网络连接后重试，或手动下载"
        rm -f "$DEB_FILE"
        exit 1
    fi
}

# 安装软件包
install_package() {
    print_step "4" "安装软件包..."
    
    # 安装依赖
    print_message "安装系统依赖..."
    apt-get update
    apt-get install -y libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils libatspi2.0-0 libappindicator3-1 libsecret-1-0
    
    # 安装DEB包
    print_message "安装 KANTAN AI..."
    if dpkg -i "$DEB_FILE"; then
        print_message "✓ 安装成功"
    else
        print_warning "安装过程出现依赖问题，尝试修复..."
        apt-get install -f -y
        print_message "✓ 依赖修复完成"
    fi
}

# 清理图标缓存
clean_icon_cache() {
    print_step "5" "清理系统缓存..."
    
    # 清理图标缓存
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        print_message "更新图标缓存..."
        gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
    fi
    
    # 清理应用缓存
    print_message "清理应用缓存..."
    rm -rf ~/.cache/KANTAN\ AI 2>/dev/null || true
    
    print_message "✓ 缓存清理完成"
}

# 显示安装完成信息
show_completion() {
    print_step "6" "安装完成"
    
    echo ""
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}      KANTAN AI 安装成功！${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    echo -e "${BLUE}版本信息:${NC} $VERSION"
    echo ""
    echo -e "${BLUE}启动方式:${NC}"
    echo "  1. 在应用程序菜单中搜索 'KANTAN AI'"
    echo "  2. 终端运行: kantan-ai"
    echo "  3. 使用命令: /opt/KANTAN AI/kantan-ai"
    echo ""
    echo -e "${BLUE}重要提示:${NC}"
    echo "  • 首次启动可能需要几秒钟初始化"
    echo "  • 侧边栏新增客服二维码，点击可获取技术支持"
    echo "  • '获取API'按钮可快速访问官网获取API密钥"
    echo ""
    echo -e "${BLUE}联系方式:${NC}"
    echo "  • 官网: https://kantan-ai.com"
    echo "  • 文档: https://docs.kantan-ai.com"
    echo "  • 社区: https://community.kantan-ai.com"
    echo ""
    echo -e "${GREEN}感谢使用 KANTAN AI！${NC}"
    echo ""
}

# 显示帮助信息
show_help() {
    echo -e "${CYAN}KANTAN AI 一键安装脚本${NC}"
    echo ""
    echo -e "${YELLOW}用法:${NC}"
    echo "  $0 [选项]"
    echo ""
    echo -e "${YELLOW}选项:${NC}"
    echo "  -h, --help     显示此帮助信息"
    echo "  -v, --version  显示版本信息"
    echo "  --local        使用本地安装包（不下载）"
    echo "  --check        只检查系统要求，不安装"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  $0              # 正常安装（自动下载）"
    echo "  $0 --local      # 使用当前目录的安装包"
    echo "  $0 --check      # 只检查系统兼容性"
    echo ""
}

# 显示版本信息
show_version() {
    echo -e "${CYAN}KANTAN AI 安装脚本${NC}"
    echo -e "版本: ${GREEN}1.0.0${NC}"
    echo -e "目标应用版本: ${GREEN}${VERSION}${NC}"
    echo -e "安装包: ${YELLOW}${DEB_FILE}${NC}"
    echo -e "MD5: ${EXPECTED_MD5}"
    echo ""
}

# 参数解析
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--version)
                show_version
                exit 0
                ;;
            --local)
                USE_LOCAL=true
                shift
                ;;
            --check)
                CHECK_ONLY=true
                shift
                ;;
            *)
                print_error "未知选项: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# 主函数
main() {
    # 解析参数
    parse_args "$@"
    
    clear
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}      KANTAN AI 一键安装脚本${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    
    # 显示版本信息
    show_version
    
    # 检查系统
    check_system
    
    # 如果只检查，则退出
    if [[ "$CHECK_ONLY" == "true" ]]; then
        print_message "系统检查完成，符合安装要求"
        exit 0
    fi
    
    # 检查依赖
    check_dependencies
    
    # 下载安装包
    download_package
    
    # 切换到root权限
    if [[ $EUID -ne 0 ]]; then
        print_message "需要root权限继续安装..."
        exec sudo bash -c "$(cat $0) $*"
        exit 0
    fi
    
    # 安装软件包
    install_package
    
    # 清理缓存
    clean_icon_cache
    
    # 显示完成信息
    show_completion
    
    # 清理临时文件
    if [[ -f "$DEB_FILE" ]] && [[ ! -f "release/$DEB_FILE" ]]; then
        rm -f "$DEB_FILE"
    fi
}

# 运行主函数
main "$@"