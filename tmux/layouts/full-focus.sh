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

# AI 工具配置（支援環境變數自訂，參數優先於環境變數）
DEFAULT_AI="${VIBE_AI_FOCUS:-codex}"
AI_CHOICE="${2:-$DEFAULT_AI}"

# 確保專案目錄存在
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 錯誤：專案目錄不存在 '$PROJECT_DIR'"
    exit 1
fi

# 驗證 AI 選擇
if [[ "$AI_CHOICE" != "codex" && "$AI_CHOICE" != "claude" ]]; then
    echo "❌ 錯誤：AI 選擇必須是 'codex' 或 'claude'"
    echo "   使用方法: $0 [project_dir] [codex|claude]"
    echo "   或設定環境變數: export VIBE_AI_FOCUS=claude"
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
# Check Tools
# ───────────────────────────────────────────────────────

check_tool() {
    local tool="$1"
    if ! command -v "$tool" &>/dev/null; then
        echo "⚠️  警告：'$tool' 未安裝"
        echo "   安裝方法："
        case "$tool" in
            codex)
                echo "     npm install -g @codexhq/cli"
                ;;
            claude)
                echo "     從 https://claude.com/code 下載"
                ;;
            *)
                echo "     請查閱工具文檔"
                ;;
        esac
        return 1
    fi
    return 0
}

# 檢查選擇的 AI 工具是否可用
echo ""
AI_AVAILABLE=false

if check_tool "$AI_COMMAND"; then
    AI_AVAILABLE=true
fi

echo ""

# 如果工具不存在，詢問是否繼續
if [[ "$AI_AVAILABLE" == false ]]; then
    echo "❌ 錯誤：選擇的 AI 工具 '$AI_COMMAND' 未安裝"
    echo "   請先安裝後再執行"
    echo ""
    echo "是否仍要建立 session（僅建立空 shell）？ [y/N]: "
    read -r confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "❌ 已取消"
        exit 0
    fi
    echo ""
    echo "⚠️  將建立僅包含 shell 的 session"
fi

echo ""

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

# 啟動選擇的 AI（或顯示錯誤訊息）
if [[ "$AI_AVAILABLE" == true ]]; then
    tmux send-keys -t "$SESSION_NAME:0.0" "$AI_COMMAND" C-m
else
    tmux send-keys -t "$SESSION_NAME:0.0" "echo '⚠️  $AI_COMMAND 未安裝，請先安裝後再執行'" C-m
    tmux send-keys -t "$SESSION_NAME:0.0" "echo '   安裝方法請參考上方提示'" C-m
fi

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

echo "✅ Focus session 建立完成！"
sleep 1

tmux attach-session -t "$SESSION_NAME"
