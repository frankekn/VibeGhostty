#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Split Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/layout-common.sh"

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

PROJECT_DIR="$(vg_resolve_project_dir "${1:-}")"
SESSION_NAME="$(vg_session_name "ai-split" "$PROJECT_DIR" "split")"

AI_LEFT="${VIBE_AI_LEFT:-codex}"
AI_RIGHT="${VIBE_AI_RIGHT:-claude}"
AI_LEFT_LABEL="${AI_LEFT^}"
AI_RIGHT_LABEL="${AI_RIGHT^}"

# ───────────────────────────────────────────────────────
# Check Tools
# ───────────────────────────────────────────────────────

LEFT_AVAILABLE=false
if vg_check_tool "$AI_LEFT"; then
    LEFT_AVAILABLE=true
fi

echo ""

RIGHT_AVAILABLE=false
if vg_check_tool "$AI_RIGHT"; then
    RIGHT_AVAILABLE=true
fi

if [[ "$LEFT_AVAILABLE" == false && "$RIGHT_AVAILABLE" == false ]]; then
    echo ""
    echo "❌ 錯誤：沒有可用的 AI 工具"
    echo "   請至少安裝 $AI_LEFT 或 $AI_RIGHT"
    exit 1
fi

if [[ "$LEFT_AVAILABLE" == false || "$RIGHT_AVAILABLE" == false ]]; then
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

echo "🚀 建立 AI Split session: $SESSION_NAME"
echo "📁 專案目錄: $PROJECT_DIR"

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Pane 1.1: 左側 (50%)
tmux select-pane -t "${SESSION_NAME}:1.1" -T "🔧 $AI_LEFT_LABEL"

# Pane 1.2: 右側 (50%)
tmux split-window -h -p 50 -t "$SESSION_NAME:1" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.2" -T "🤖 $AI_RIGHT_LABEL"

# Pane 1.3: 底部 (25%)
tmux select-pane -t "${SESSION_NAME}:1.1"
tmux split-window -v -p 25 -t "$SESSION_NAME:1.1" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.3" -T "⚖️  Compare"

# ───────────────────────────────────────────────────────
# Step 2: 顯示 pane 使用提示
# ───────────────────────────────────────────────────────

vg_show_manual_launch "$SESSION_NAME" "1.1" "$AI_LEFT_LABEL" "$AI_LEFT" "$LEFT_AVAILABLE"
vg_show_manual_launch "$SESSION_NAME" "1.2" "$AI_RIGHT_LABEL" "$AI_RIGHT" "$RIGHT_AVAILABLE"

# ───────────────────────────────────────────────────────
# Step 3: 設定底部輔助窗格內容
# ───────────────────────────────────────────────────────

tmux send-keys -t "$SESSION_NAME:1.3" "clear" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '╔════════════════════════════════════════════╗'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '║     ⚖️  輔助窗格                      ║'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '╚════════════════════════════════════════════╝'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '50/50 並排布局，適合多種工作流程：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  💡 建議用途（可自由調整）：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     • 前端/後端分離開發'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     • 不同任務平行處理'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     • 並排比較輸出結果'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     • 同時執行多個工具'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '  🛠️  常用指令範例：'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     diff / git diff / vimdiff'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo '     npm test / pytest / cargo test'" C-m
tmux send-keys -t "$SESSION_NAME:1.3" "echo ''" C-m

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

tmux select-pane -t "${SESSION_NAME}:1.1"

echo "✅ Compare session 建立完成！"
sleep 1

tmux attach-session -t "$SESSION_NAME"

