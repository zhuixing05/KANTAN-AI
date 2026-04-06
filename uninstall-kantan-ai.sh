#!/bin/bash
# KANTAN AI 一键卸载脚本
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

# 包信息
PACKAGE_NAME="kantan-ai"
PACKAGE_VERSION="2026.4.6"

# 脚本参数
FULL_REMOVE=false
DRY_RUN=false
MANUAL_INSTALL=false
REMNANTS_FOUND=false
INSTALLED_VERSION=""

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

# 显示帮助信息
show_help() {
    echo -e "${CYAN}KANTAN AI 一键卸载脚本${NC}"
    echo ""
    echo -e "${YELLOW}用法:${NC}"
    echo "  $0 [选项]"
    echo ""
    echo -e "${YELLOW}选项:${NC}"
    echo "  -h, --help         显示此帮助信息"
    echo "  -v, --version      显示版本信息"
    echo "  -f, --full         完全卸载（包括配置文件）"
    echo "  -d, --dry-run      模拟运行，不执行实际卸载"
    echo ""
    echo -e "${YELLOW}示例:${NC}"
    echo "  $0                  # 正常卸载（保留配置文件）"
    echo "  $0 --full           # 完全卸载（删除所有文件）"
    echo "  $0 --dry-run        # 模拟卸载过程"
    echo ""
}

# 显示版本信息
show_version() {
    echo -e "${CYAN}KANTAN AI 卸载脚本${NC}"
    echo -e "版本: ${GREEN}1.0.0${NC}"
    echo -e "目标包: ${YELLOW}${PACKAGE_NAME} (${PACKAGE_VERSION})${NC}"
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
            -f|--full)
                FULL_REMOVE=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
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

# 检查是否已安装
check_installed() {
    print_step "1" "检查安装状态..."
    
    if dpkg -l | grep -q "^ii.*${PACKAGE_NAME}"; then
        INSTALLED_VERSION=$(dpkg -l | grep "^ii.*${PACKAGE_NAME}" | awk '{print $3}')
        print_message "✓ 已安装 ${PACKAGE_NAME} (${INSTALLED_VERSION})"
        return 0
    else
        print_warning "未检测到 ${PACKAGE_NAME} 安装包"
        
        # 检查是否手动安装
        if [[ -f "/opt/KANTAN AI/kantan-ai" ]]; then
            print_warning "检测到手动安装的文件"
            MANUAL_INSTALL=true
            return 0
        else
            print_error "${PACKAGE_NAME} 未安装"
            exit 1
        fi
    fi
}

# 卸载软件包
remove_package() {
    print_step "2" "卸载软件包..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_message "[模拟] 执行: apt-get remove -y ${PACKAGE_NAME}"
        return
    fi
    
    print_message "正在卸载 ${PACKAGE_NAME}..."
    
    if apt-get remove -y "${PACKAGE_NAME}"; then
        print_message "✓ 软件包卸载成功"
    else
        print_error "apt-get remove 失败"
        print_message "尝试使用 dpkg --remove..."
        
        if dpkg --remove "${PACKAGE_NAME}"; then
            print_message "✓ dpkg --remove 成功"
        else
            print_error "卸载失败，可能需要手动清理"
            return 1
        fi
    fi
    
    # 如果是完全卸载，同时删除配置文件
    if [[ "$FULL_REMOVE" == "true" ]]; then
        print_message "正在删除配置文件..."
        if apt-get purge -y "${PACKAGE_NAME}"; then
            print_message "✓ 配置文件已删除"
        fi
    fi
}

# 清理手动安装的文件
clean_manual_files() {
    print_step "3" "清理残留文件..."
    
    if [[ "$DRY_RUN" == "true" ]]; then
        print_message "[模拟] 清理以下目录和文件:"
        print_message "  /opt/KANTAN AI/"
        print_message "  ~/.config/KANTAN AI/"
        print_message "  ~/.local/share/KANTAN AI/"
        print_message "  ~/.cache/KANTAN AI/"
        print_message "  /usr/share/applications/kantan-ai.desktop"
        return
    fi
    
    # 清理安装目录
    if [[ -d "/opt/KANTAN AI" ]]; then
        print_message "删除安装目录: /opt/KANTAN AI/"
        rm -rf "/opt/KANTAN AI"
    fi
    
    # 清理配置文件
    if [[ -d "${HOME}/.config/KANTAN AI" ]]; then
        print_message "删除用户配置: ~/.config/KANTAN AI/"
        rm -rf "${HOME}/.config/KANTAN AI"
    fi
    
    # 清理数据文件
    if [[ -d "${HOME}/.local/share/KANTAN AI" ]]; then
        print_message "删除用户数据: ~/.local/share/KANTAN AI/"
        rm -rf "${HOME}/.local/share/KANTAN AI"
    fi
    
    # 清理缓存
    if [[ -d "${HOME}/.cache/KANTAN AI" ]]; then
        print_message "删除用户缓存: ~/.cache/KANTAN AI/"
        rm -rf "${HOME}/.cache/KANTAN AI"
    fi
    
    # 清理桌面图标
    DESKTOP_FILE="/usr/share/applications/kantan-ai.desktop"
    if [[ -f "$DESKTOP_FILE" ]]; then
        print_message "删除桌面图标: $DESKTOP_FILE"
        rm -f "$DESKTOP_FILE"
    fi
    
    # 清理图标缓存
    if command -v gtk-update-icon-cache >/dev/null 2>&1; then
        print_message "更新图标缓存..."
        gtk-update-icon-cache -f /usr/share/icons/hicolor 2>/dev/null || true
    fi
    
    print_message "✓ 文件清理完成"
}

# 检查残留文件
check_remnants() {
    print_step "4" "检查残留文件..."
    
    REMNANTS_FOUND=false
    
    local locations=(
        "/opt/KANTAN AI"
        "${HOME}/.config/KANTAN AI"
        "${HOME}/.local/share/KANTAN AI"
        "${HOME}/.cache/KANTAN AI"
        "/usr/share/applications/kantan-ai.desktop"
        "/usr/local/bin/kantan-ai"
        "/usr/bin/kantan-ai"
    )
    
    for location in "${locations[@]}"; do
        if [[ -e "$location" ]]; then
            print_warning "发现残留文件: $location"
            REMNANTS_FOUND=true
        fi
    done
    
    if [[ "$REMNANTS_FOUND" == "false" ]]; then
        print_message "✓ 未发现残留文件"
    else
        print_warning "发现残留文件，建议使用 --full 参数完全清理"
    fi
}

# 确认操作
confirm_operation() {
    echo ""
    echo -e "${YELLOW}即将执行以下操作:${NC}"
    echo ""
    
    if [[ "$FULL_REMOVE" == "true" ]]; then
        echo -e "  ${RED}● 完全卸载${NC}"
        echo "    - 删除软件包"
        echo "    - 删除所有配置文件"
        echo "    - 删除用户数据"
        echo "    - 删除缓存文件"
    else
        echo -e "  ${YELLOW}● 基本卸载${NC}"
        echo "    - 删除软件包"
        echo "    - 保留用户配置和数据"
    fi
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "  ${CYAN}● 模拟运行${NC}"
        echo "    - 只显示操作，不实际执行"
    fi
    
    echo ""
    
    if [[ "$DRY_RUN" != "true" ]]; then
        read -p "是否继续？(y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_message "操作已取消"
            exit 0
        fi
    fi
}

# 显示卸载完成信息
show_completion() {
    print_step "5" "卸载完成"
    
    echo ""
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}      KANTAN AI 卸载成功！${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    
    if [[ "$FULL_REMOVE" == "true" ]]; then
        echo -e "${GREEN}✓ 完全卸载完成${NC}"
        echo "  所有程序文件、配置和数据都已删除"
    else
        echo -e "${YELLOW}✓ 基本卸载完成${NC}"
        echo "  程序文件已删除，用户配置和数据保留"
    fi
    
    echo ""
    echo -e "${BLUE}已删除的内容:${NC}"
    echo "  • KANTAN AI 主程序"
    echo "  • 系统图标和菜单项"
    
    if [[ "$FULL_REMOVE" == "true" ]]; then
        echo "  • 用户配置和设置"
        echo "  • 会话数据和记忆"
        echo "  • 所有缓存文件"
    else
        echo "  • [保留] 用户配置 (~/.config/KANTAN AI)"
        echo "  • [保留] 用户数据 (~/.local/share/KANTAN AI)"
    fi
    
    echo ""
    echo -e "${BLUE}如需重新安装:${NC}"
    echo "  运行: sudo ./install-kantan-ai.sh"
    echo ""
    
    if [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${YELLOW}⚠ 这是模拟运行，实际未执行任何操作${NC}"
        echo ""
    fi
}

# 主函数
main() {
    # 解析参数
    parse_args "$@"
    
    clear
    echo -e "${GREEN}===============================================${NC}"
    echo -e "${GREEN}      KANTAN AI 一键卸载脚本${NC}"
    echo -e "${GREEN}===============================================${NC}"
    echo ""
    
    # 显示版本信息
    show_version
    
    # 检查安装状态
    check_installed
    
    # 确认操作
    confirm_operation
    
    # 切换到root权限（如果不是模拟运行）
    if [[ "$DRY_RUN" != "true" ]] && [[ $EUID -ne 0 ]]; then
        print_message "需要root权限继续卸载..."
        exec sudo bash -c "$(cat $0) $*"
        exit 0
    fi
    
    # 卸载软件包
    if [[ "$MANUAL_INSTALL" != "true" ]]; then
        remove_package
    fi
    
    # 清理文件
    clean_manual_files
    
    # 检查残留
    if [[ "$DRY_RUN" != "true" ]]; then
        check_remnants
    fi
    
    # 显示完成信息
    show_completion
}

# 运行主函数
main "$@"