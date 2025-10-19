#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Workspace Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════
#
# Layout Design:
# ┌─────────────────────────┬─────────────┐
# │   Codex CLI (主要)      │  Claude     │
# │   70%                   │  Code       │
# │                         │  30%        │
# │                         ├─────────────┤
# │                         │ Monitor     │
# │                         │ (Tests/Logs)│
# │                         │  30%        │
# └─────────────────────────┴─────────────┘
#
# Usage:
#   ./ai-workspace.sh [project_dir]
#
# ═══════════════════════════════════════════════════════

set -e  # 遇到錯誤立即停止

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

SESSION_NAME="ai-work"
PROJECT_DIR="${1:-$PWD}"

# 確保專案目錄存在
if [[ ! -d "$PROJECT_DIR" ]]; then
    echo "❌ 錯誤：專案目錄不存在 '$PROJECT_DIR'"
    exit 1
fi

# 如果在 git repo，使用 repo 名稱作為 session 名稱
if [[ -d "$PROJECT_DIR/.git" ]]; then
    REPO_NAME=$(basename "$PROJECT_DIR")
    SESSION_NAME="ai-${REPO_NAME}"
fi

# ───────────────────────────────────────────────────────
# Check if session already exists
# ───────────────────────────────────────────────────────

if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    echo "📌 Session '$SESSION_NAME' 已存在"
    echo "選擇操作："
    echo "  1. 連接到現有 session (attach)"
    echo "  2. 刪除並重新建立 (recreate)"
    echo "  3. 取消 (cancel)"
    read -p "請選擇 [1/2/3]: " choice

    case $choice in
        1)
            echo "🔗 連接到 session '$SESSION_NAME'..."
            tmux attach-session -t "$SESSION_NAME"
            exit 0
            ;;
        2)
            echo "🗑️  刪除現有 session..."
            tmux kill-session -t "$SESSION_NAME"
            ;;
        3|*)
            echo "❌ 已取消"
            exit 0
            ;;
    esac
fi

# ───────────────────────────────────────────────────────
# Create new session
# ───────────────────────────────────────────────────────

echo "🚀 建立 AI Workspace session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"

# 建立 session（但不立即 attach）
tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# ───────────────────────────────────────────────────────
# Setup Pane 0: Codex CLI (左側 70%)
# ───────────────────────────────────────────────────────

# 設定標題
tmux select-pane -t "${SESSION_NAME}:0.0" -T "🔧 Codex CLI"

# 啟動 Codex
tmux send-keys -t "${SESSION_NAME}:0.0" "codex" C-m

# ───────────────────────────────────────────────────────
# Create Pane 1: Claude Code (右上 30%)
# ───────────────────────────────────────────────────────

# 垂直分割右側（30% 寬度）
tmux split-window -h -p 30 -t "$SESSION_NAME:0" -c "$PROJECT_DIR"

# 設定標題
tmux select-pane -t "${SESSION_NAME}:0.1" -T "🤖 Claude Code"

# 啟動 Claude Code
tmux send-keys -t "${SESSION_NAME}:0.1" "claude" C-m

# ───────────────────────────────────────────────────────
# Create Pane 2: Monitor (右下 30%)
# ───────────────────────────────────────────────────────

# 在右側 pane 下方再分割（50% 高度）
tmux split-window -v -p 50 -t "$SESSION_NAME:0.1" -c "$PROJECT_DIR"

# 設定標題
tmux select-pane -t "${SESSION_NAME}:0.2" -T "📊 Monitor"

# 顯示提示訊息（不自動執行程式）
tmux send-keys -t "$SESSION_NAME:0.2" "clear" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '╔════════════════════════════════════╗'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '║     📊 Monitor Pane 使用說明      ║'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '╚════════════════════════════════════╝'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '此 pane 用於監控和日誌：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  🧪 執行測試：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     npm test --watch'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     pytest -v --watch'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  📋 檢視日誌：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     tail -f app.log'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     docker logs -f container'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '  🔍 系統監控：'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     htop'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '     watch -n 1 \"ps aux | grep node\"'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo '💡 按 Ctrl+Space 然後按 3 快速跳到這裡'" C-m
tmux send-keys -t "$SESSION_NAME:0.2" "echo ''" C-m

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

# 回到 Codex CLI pane（主工作區）
tmux select-pane -t "${SESSION_NAME}:0.0"

# 連接到 session
echo "✅ Session 建立完成！正在連接..."
sleep 1  # 給一點時間讓 CLI 啟動

tmux attach-session -t "$SESSION_NAME"
