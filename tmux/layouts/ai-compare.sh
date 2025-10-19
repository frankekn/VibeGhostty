#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Compare Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════
#
# Layout Design:
# ┌────────────────┬────────────────┐
# │  Codex CLI     │  Claude Code   │
# │  50%           │  50%           │
# ├────────────────┴────────────────┤
# │  Compare/Monitor (25%)          │
# └─────────────────────────────────┘
#
# Usage:
#   ./ai-compare.sh [project_dir]
#
# ═══════════════════════════════════════════════════════

set -e

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

SESSION_NAME="ai-compare"
PROJECT_DIR="${1:-$PWD}"

# AI 工具配置（支援環境變數自訂）
AI_LEFT="${VIBE_AI_LEFT:-codex}"
AI_RIGHT="${VIBE_AI_RIGHT:-claude}"

# 確保專案目錄存在
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 錯誤：專案目錄不存在 '$PROJECT_DIR'"
    exit 1
fi

if [[ -d "$PROJECT_DIR/.git" ]]; then
    REPO_NAME=$(basename "$PROJECT_DIR")
    SESSION_NAME="compare-${REPO_NAME}"
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

# 檢查工具可用性
LEFT_AVAILABLE=false
RIGHT_AVAILABLE=false

if check_tool "$AI_LEFT"; then
    LEFT_AVAILABLE=true
fi

echo ""

if check_tool "$AI_RIGHT"; then
    RIGHT_AVAILABLE=true
fi

# 如果兩個工具都不存在，無法進行比較
if [[ "$LEFT_AVAILABLE" == false && "$RIGHT_AVAILABLE" == false ]]; then
    echo ""
    echo "❌ 錯誤：沒有可用的 AI 工具"
    echo "   比較模式需要至少一個 AI 工具"
    echo "   請至少安裝 $AI_LEFT 或 $AI_RIGHT"
    exit 1
fi

# 如果只有一個工具不存在，警告但繼續
if [[ "$LEFT_AVAILABLE" == false || "$RIGHT_AVAILABLE" == false ]]; then
    echo ""
    echo "⚠️  注意：僅有一個 AI 工具可用"
    echo "   比較功能將受限"
    echo ""
    echo "是否繼續建立 session？ [Y/n]: "
    read -r confirm
    if [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        echo "❌ 已取消"
        exit 0
    fi
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

echo "🚀 建立 AI Compare session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# ───────────────────────────────────────────────────────
# Pane 0: 左側 AI 工具 (50%)
# ───────────────────────────────────────────────────────

# 設定標題
tmux select-pane -t 0 -T "🔧 ${AI_LEFT^}"

# 啟動左側 AI 工具
if [[ "$LEFT_AVAILABLE" == true ]]; then
    tmux send-keys -t "$SESSION_NAME:0.0" "$AI_LEFT" C-m
else
    tmux send-keys -t "$SESSION_NAME:0.0" "echo '⚠️  $AI_LEFT 未安裝，請先安裝後再執行'" C-m
fi

# ───────────────────────────────────────────────────────
# Pane 1: 右側 AI 工具 (50%)
# ───────────────────────────────────────────────────────

tmux split-window -h -p 50 -t "$SESSION_NAME:0" -c "$PROJECT_DIR"

# 設定標題
tmux select-pane -t 1 -T "🤖 ${AI_RIGHT^}"

# 啟動右側 AI 工具
if [[ "$RIGHT_AVAILABLE" == true ]]; then
    tmux send-keys -t "$SESSION_NAME:0.1" "$AI_RIGHT" C-m
else
    tmux send-keys -t "$SESSION_NAME:0.1" "echo '⚠️  $AI_RIGHT 未安裝，請先安裝後再執行'" C-m
fi

# ───────────────────────────────────────────────────────
# Pane 2: Compare/Monitor (下方 25%)
# ───────────────────────────────────────────────────────

# 選擇 pane 0，在下方分割
tmux select-pane -t 0
tmux split-window -v -p 25 -t "$SESSION_NAME:0.0" -c "$PROJECT_DIR"
tmux select-pane -t 2 -T "⚖️  Compare"

# 顯示提示
tmux send-keys -t "$SESSION_NAME:0.2" "clear" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '╔════════════════════════════════════════════╗'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '║     ⚖️  Compare Pane 使用說明            ║'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '╚════════════════════════════════════════════╝'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '此模式用於比較兩個 AI 的輸出：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  📝 比較程式碼風格'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  🔍 比較解決方案品質'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  ⚡ 比較執行效能'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  🧪 執行測試驗證'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '常用指令：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  diff output1.txt output2.txt'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  git diff branch1 branch2'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  vimdiff file1 file2'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

# 回到 Codex pane
tmux select-pane -t 0

echo "✅ Compare session 建立完成！"
sleep 1

tmux attach-session -t "$SESSION_NAME"
