#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Workspace Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/layout-common.sh"

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

PROJECT_DIR="$(vg_resolve_project_dir "${1:-}")"
SESSION_NAME="$(vg_session_name "ai-work" "$PROJECT_DIR" "ai")"

AI_PRIMARY="${VIBE_AI_PRIMARY:-codex}"
AI_SECONDARY="${VIBE_AI_SECONDARY:-claude}"
AI_PRIMARY_LABEL="${AI_PRIMARY^}"
AI_SECONDARY_LABEL="${AI_SECONDARY^}"

# ───────────────────────────────────────────────────────
# Check Tools
# ───────────────────────────────────────────────────────

PRIMARY_AVAILABLE=false
if vg_check_tool "$AI_PRIMARY"; then
    PRIMARY_AVAILABLE=true
fi

echo ""

SECONDARY_AVAILABLE=false
if vg_check_tool "$AI_SECONDARY"; then
    SECONDARY_AVAILABLE=true
fi

# 如果兩個工具都不存在，直接結束
if [[ "$PRIMARY_AVAILABLE" == false && "$SECONDARY_AVAILABLE" == false ]]; then
    echo ""
    echo "❌ 錯誤：沒有可用的 AI 工具"
    echo "   請至少安裝 $AI_PRIMARY 或 $AI_SECONDARY"
    exit 1
fi

# 如果只有一個工具不存在，詢問是否繼續
if [[ "$PRIMARY_AVAILABLE" == false || "$SECONDARY_AVAILABLE" == false ]]; then
    echo ""
    vg_confirm_continue "是否繼續建立 session？"
fi

echo ""

# ───────────────────────────────────────────────────────
# Existing session handling
# ───────────────────────────────────────────────────────

vg_handle_existing_session "$SESSION_NAME"

# ───────────────────────────────────────────────────────
# Create new session and panes
# ───────────────────────────────────────────────────────

echo "🚀 建立 AI Workspace session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Pane 1.1: 主要工作區 (左側 70%)
tmux select-pane -t "${SESSION_NAME}:1.1" -T "🔧 $AI_PRIMARY_LABEL"

# Pane 1.2: 輔助工具 (右上 30%)
tmux split-window -h -p 30 -t "$SESSION_NAME:1" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.2" -T "🤖 $AI_SECONDARY_LABEL"

# Pane 1.3: 監控窗格 (右下 30%)
tmux split-window -v -p 50 -t "$SESSION_NAME:1.2" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.3" -T "📊 Monitor"

# ───────────────────────────────────────────────────────
# Step 2: 顯示 pane 使用提示
# ───────────────────────────────────────────────────────

vg_show_manual_launch "$SESSION_NAME" "1.1" "$AI_PRIMARY_LABEL" "$AI_PRIMARY" "$PRIMARY_AVAILABLE"
vg_show_manual_launch "$SESSION_NAME" "1.2" "$AI_SECONDARY_LABEL" "$AI_SECONDARY" "$SECONDARY_AVAILABLE"

# ───────────────────────────────────────────────────────
# Step 3: 設定監控窗格內容
# ───────────────────────────────────────────────────────

tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '╔════════════════════════════════════╗'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '║     📊 輔助窗格               ║'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '╚════════════════════════════════════╝'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '此窗格用途由您自由決定，例如：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  🧪 測試監控：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     npm test --watch / pytest -v'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  📋 日誌追蹤：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     tail -f app.log / docker logs -f'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  🔍 系統監控：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     htop / watch ps'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  ⚡ 快速指令：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     git status / npm run dev'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '💡 Ctrl+Space 3 快速跳轉到此窗格'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

tmux select-pane -t "${SESSION_NAME}:1.1"

echo "✅ Session 建立完成！正在連接..."
sleep 1

tmux attach-session -t "$SESSION_NAME"

