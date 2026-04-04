#!/bin/bash
# KANTAN AI 一键关闭脚本
# 作者: KANTAN AI 助手
# 描述: 关闭所有 KANTAN AI 相关进程

echo "正在关闭 KANTAN AI ..."

# 检查是否有 kantan-ai 进程
KANTAN_PIDS=$(pgrep -f "kantan-ai" 2>/dev/null)
if [ -n "$KANTAN_PIDS" ]; then
    echo "找到 KANTAN AI 进程: $KANTAN_PIDS"
    pkill -f "kantan-ai"
    echo "✓ 已发送关闭信号给 KANTAN AI"
else
    echo "✓ 未发现运行中的 KANTAN AI 进程"
fi

# 检查是否有 openclaw-gateway 进程
GATEWAY_PIDS=$(pgrep -f "openclaw-gateway" 2>/dev/null)
if [ -n "$GATEWAY_PIDS" ]; then
    echo "找到 OpenClaw Gateway 进程: $GATEWAY_PIDS"
    pkill -f "openclaw-gateway"
    echo "✓ 已发送关闭信号给 OpenClaw Gateway"
else
    echo "✓ 未发现运行中的 OpenClaw Gateway 进程"
fi

# 检查是否有 LobsterAI 遗留进程（旧版本）
LOBSTER_PIDS=$(pgrep -f "LobsterAI" 2>/dev/null)
if [ -n "$LOBSTER_PIDS" ]; then
    echo "找到 LobsterAI 旧版本进程: $LOBSTER_PIDS"
    pkill -f "LobsterAI"
    echo "✓ 已发送关闭信号给 LobsterAI 旧版本"
fi

# 等待 2 秒让进程结束
sleep 2

# 最终检查
REMAINING=$(pgrep -f "kantan-ai\|openclaw-gateway\|LobsterAI" 2>/dev/null)
if [ -n "$REMAINING" ]; then
    echo "⚠️  仍有进程未关闭，尝试强制结束..."
    pkill -9 -f "kantan-ai\|openclaw-gateway\|LobsterAI" 2>/dev/null
    sleep 1
fi

# 最终状态报告
REMAINING_FINAL=$(pgrep -f "kantan-ai\|openclaw-gateway\|LobsterAI" 2>/dev/null)
if [ -z "$REMAINING_FINAL" ]; then
    echo "========================================"
    echo "✅ KANTAN AI 已完全关闭！"
    echo "========================================"
    echo ""
    echo "提示：要重新启动 KANTAN AI，请："
    echo "1. 双击桌面上的 KANTAN AI 图标"
    echo "2. 或运行命令：/opt/KANTAN\\ AI/kantan-ai --no-sandbox --disable-gpu"
else
    echo "========================================"
    echo "⚠️  以下进程可能仍在运行："
    echo "$REMAINING_FINAL"
    echo "========================================"
    echo "可能需要手动结束："
    echo "sudo kill -9 $REMAINING_FINAL"
fi

# 保持终端窗口打开以便查看结果
read -p "按 Enter 键关闭窗口..."