#!/bin/bash
# run.sh - 執行 browser-use 腳本
# 用法: ./run.sh script.py

SKILL_DIR="$HOME/.nanobot/workspace/skills/browser-use"
VENV_DIR="$SKILL_DIR/.venv"
SCRIPT="${1:-grab_ticket.py}"

# 檢查虛擬環境
if [ ! -d "$VENV_DIR" ]; then
    echo "❌ 虛擬環境不存在，請先安裝："
    echo "   cd $SKILL_DIR && uv venv --python 3.11 && source .venv/bin/activate && uv pip install browser-use playwright"
    exit 1
fi

# 檢查 API Key
if [ -z "$ANTHROPIC_API_KEY" ] && [ -z "$OPENAI_API_KEY" ] && [ -z "$GEMINI_API_KEY" ]; then
    echo "⚠️  警告: 未設置 API Key"
    echo "   請設置: export ANTHROPIC_API_KEY='your-key'"
fi

# 執行腳本
cd "$SKILL_DIR"
source "$VENV_DIR/bin/activate"

if [ -f "scripts/$SCRIPT" ]; then
    python3 "scripts/$SCRIPT"
elif [ -f "$SCRIPT" ]; then
    python3 "$SCRIPT"
else
    echo "❌ 找不到腳本: $SCRIPT"
    exit 1
fi
