#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Split Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════
#
# Layout Design:
# ┌────────────────┬────────────────┐
# │  左側窗格      │  右側窗格      │
# │  50%           │  50%           │
# ├────────────────┴────────────────┤
# │  輔助窗格 (25%)                 │
# └─────────────────────────────────┘
#
# 用途範例（可自由調整）：
# • 前端/後端分離：左側前端開發，右側後端 API
# • 多工具協作：左側 AI 工具，右側編輯器
# • 並排比較：左右窗格執行不同工具比較輸出
# • 輔助窗格：測試執行、日誌監控、指令輸入
#
# Usage:
#   ./ai-split.sh [project_dir]
#
# ═══════════════════════════════════════════════════════

set -e

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

SESSION_NAME="ai-split"
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
    SESSION_NAME="split-${REPO_NAME}"
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
# Step 1: 創建所有 pane（先不啟動程式）
# ───────────────────────────────────────────────────────

# Pane 1.1: 左側 (50%)
tmux select-pane -t "${SESSION_NAME}:1.1" -T "🔧 ${AI_LEFT^}"

# Pane 1.2: 右側 (50%) - 水平分割
tmux split-window -h -p 50 -t "$SESSION_NAME:1" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.2" -T "🤖 ${AI_RIGHT^}"

# Pane 1.3: 底部 (25%) - 垂直分割左側
tmux select-pane -t "${SESSION_NAME}:1.1"
tmux split-window -v -p 25 -t "$SESSION_NAME:1.1" -c "$PROJECT_DIR"
tmux select-pane -t "${SESSION_NAME}:1.3" -T "⚖️  Compare"

# ───────────────────────────────────────────────────────
# Step 2: 啟動程式（所有 pane 已就位，大小固定）
# ───────────────────────────────────────────────────────

# 啟動左側 AI 工具 (pane 1.1)
if [[ "$LEFT_AVAILABLE" == true ]]; then
    tmux send-keys -t "${SESSION_NAME}:1.1" "$AI_LEFT" C-m
else
    tmux send-keys -t "${SESSION_NAME}:1.1" "echo '⚠️  $AI_LEFT 未安裝，請先安裝後再執行'" C-m
fi

# 啟動右側 AI 工具 (pane 1.2)
if [[ "$RIGHT_AVAILABLE" == true ]]; then
    tmux send-keys -t "${SESSION_NAME}:1.2" "$AI_RIGHT" C-m
else
    tmux send-keys -t "${SESSION_NAME}:1.2" "echo '⚠️  $AI_RIGHT 未安裝，請先安裝後再執行'" C-m
fi

# ───────────────────────────────────────────────────────
# Step 3: 設定底部輔助窗格內容
# ───────────────────────────────────────────────────────

# 顯示提示
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

# 回到 Codex pane
tmux select-pane -t "${SESSION_NAME}:1.1"

echo "✅ Compare session 建立完成！"
sleep 1

tmux attach-session -t "$SESSION_NAME"
