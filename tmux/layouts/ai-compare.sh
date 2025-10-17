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

if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 錯誤：專案目錄不存在 '$PROJECT_DIR'"
    exit 1
fi

if [[ -d "$PROJECT_DIR/.git" ]]; then
    REPO_NAME=$(basename "$PROJECT_DIR")
    SESSION_NAME="compare-${REPO_NAME}"
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

echo "🚀 建立 AI Compare session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# ───────────────────────────────────────────────────────
# Pane 0: Codex CLI (左側 50%)
# ───────────────────────────────────────────────────────

tmux select-pane -t 0 -T "🔧 Codex CLI"
tmux send-keys -t "$SESSION_NAME:0.0" "codex" C-m

# ───────────────────────────────────────────────────────
# Pane 1: Claude Code (右側 50%)
# ───────────────────────────────────────────────────────

tmux split-window -h -p 50 -t "$SESSION_NAME:0" -c "$PROJECT_DIR"
tmux select-pane -t 1 -T "🤖 Claude Code"
tmux send-keys -t "$SESSION_NAME:0.1" "claude" C-m

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
