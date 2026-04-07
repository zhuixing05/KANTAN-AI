#!/bin/bash

# ============================================
# KANTAN AI - 配置文件修复脚本
# ============================================

cd /home/kantan/KANTAN-AI

echo "========================================"
echo "修复 electron-builder.json 配置文件"
echo "========================================"
echo ""

python3 << 'PYTHON_EOF'
import json
import os

config_path = "/home/kantan/KANTAN-AI/electron-builder.json"

print(f"正在读取配置文件: {config_path}")

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
        print(f"✓ 已保存修改后的配置文件。")
    else:
        print("✓ 配置文件格式正确，无需修复。")
    
    print("")
    print("修复后的 linux.desktop 配置预览:")
    print(json.dumps(config.get('linux', {}).get('desktop', {}), indent=2))
else:
    print("✓ 未找到 linux.desktop 配置，跳过修复。")
PYTHON_EOF

echo ""
echo "========================================"
echo "配置文件修复完成！"
echo "========================================"