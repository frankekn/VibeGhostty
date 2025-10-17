#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Full Focus Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════
#
# Layout Design:
# ┌─────────────────────────────────┐
# │  Codex CLI (100%)               │
# │                                 │
# │  專注模式 - 全屏工作            │
# │                                 │
# └─────────────────────────────────┘
#
# Usage:
#   ./full-focus.sh [project_dir] [ai_choice]
#
# Arguments:
#   project_dir - 專案目錄（選填，預設為當前目錄）
#   ai_choice   - AI 選擇：codex 或 claude（選填，預設 codex）
#
# Examples:
#   ./full-focus.sh
#   ./full-focus.sh ~/my-project
#   ./full-focus.sh ~/my-project claude
#
# ═══════════════════════════════════════════════════════

set -e

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

SESSION_NAME="ai-focus"
PROJECT_DIR="${1:-$PWD}"
AI_CHOICE="${2:-codex}"

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 錯誤：專案目錄不存在 '$PROJECT_DIR'"
    exit 1
fi

# 驗證 AI 選擇
if [[ "$AI_CHOICE" != "codex" && "$AI_CHOICE" != "claude" ]]; then
    echo "❌ 錯誤：AI 選擇必須是 'codex' 或 'claude'"
    exit 1
fi

if [[ -d "$PROJECT_DIR/.git" ]]; then
    REPO_NAME=$(basename "$PROJECT_DIR")
    SESSION_NAME="focus-${REPO_NAME}"
fi

# 設定 AI 相關資訊
if [[ "$AI_CHOICE" == "codex" ]]; then
    AI_EMOJI="🔧"
    AI_NAME="Codex CLI"
    AI_COMMAND="codex"
else
    AI_EMOJI="🤖"
    AI_NAME="Claude Code"
    AI_COMMAND="claude"
fi

# ───────────────────────────────────────────────────────
# Check existing session
# ───────────────────────────────────────────────────────

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "📌 Session '$SESSION_NAME' 已存在"
    read -p "連接到現有 session? [Y/n]: " choice
    case $choice in
        n|N)
            echo "🗑️  刪除並重新建立..."
            tmux kill-session -t "$SESSION_NAME"
            ;;
        *)
            echo "🔗 連接中..."
            tmux attach-session -t "$SESSION_NAME"
            exit 0
            ;;
    esac
fi

# ───────────────────────────────────────────────────────
# Create new session
# ───────────────────────────────────────────────────────

echo "🚀 建立 Full Focus session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"
echo "🎯 AI 工具: $AI_NAME"
echo ""
echo "💡 專注模式提示："
echo "   - 全屏專注於單一 AI 對話"
echo "   - 減少視覺干擾，提升工作效率"
echo "   - 適合深度思考和複雜問題解決"
echo "   - 按 Ctrl+Space | 可以分割視窗"
echo "   - 按 Ctrl+Space d 可以暫時離開（session 會保留）"
echo ""

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# ───────────────────────────────────────────────────────
# Setup Full Screen Pane
# ───────────────────────────────────────────────────────

tmux select-pane -t 0 -T "$AI_EMOJI $AI_NAME (Focus Mode)"

# 啟動選擇的 AI
tmux send-keys -t "$SESSION_NAME:0.0" "$AI_COMMAND" C-m

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

echo "✅ Focus session 建立完成！"
sleep 1

tmux attach-session -t "$SESSION_NAME"
