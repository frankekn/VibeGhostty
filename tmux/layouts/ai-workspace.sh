#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# AI Workspace Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════
#
# Layout Design:
# ┌─────────────────────────┬─────────────┐
# │   主要工作區            │  輔助工具   │
# │   70%                   │  30%        │
# │                         ├─────────────┤
# │                         │ 監控/測試   │
# │                         │  30%        │
# └─────────────────────────┴─────────────┘
#
# 用途範例（可自由調整）：
# • 主工作區：AI 工具、編輯器、後端開發
# • 輔助工具：另一個 AI、前端開發、快速任務
# • 監控窗格：測試、日誌、系統監控、開發伺服器
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

# AI 工具配置（支援環境變數自訂）
AI_PRIMARY="${VIBE_AI_PRIMARY:-codex}"
AI_SECONDARY="${VIBE_AI_SECONDARY:-claude}"

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

# 檢查主要工具
PRIMARY_AVAILABLE=false
SECONDARY_AVAILABLE=false

if check_tool "$AI_PRIMARY"; then
    PRIMARY_AVAILABLE=true
fi

echo ""

if check_tool "$AI_SECONDARY"; then
    SECONDARY_AVAILABLE=true
fi

# 如果兩個工具都不存在，詢問是否繼續
if [[ "$PRIMARY_AVAILABLE" == false && "$SECONDARY_AVAILABLE" == false ]]; then
    echo ""
    echo "❌ 錯誤：沒有可用的 AI 工具"
    echo "   請至少安裝 $AI_PRIMARY 或 $AI_SECONDARY"
    exit 1
fi

# 如果只有一個工具不存在，詢問是否繼續
if [[ "$PRIMARY_AVAILABLE" == false || "$SECONDARY_AVAILABLE" == false ]]; then
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
# Setup Pane 1: 主要 AI 工具 (左側 70%)
# ───────────────────────────────────────────────────────

# 設定標題
tmux select-pane -t "${SESSION_NAME}:1.1" -T "🔧 ${AI_PRIMARY^}"

# 啟動主要 AI 工具
if [[ "$PRIMARY_AVAILABLE" == true ]]; then
    tmux send-keys -t "${SESSION_NAME}:1.1" "$AI_PRIMARY" C-m
else
    tmux send-keys -t "${SESSION_NAME}:1.1" "echo '⚠️  $AI_PRIMARY 未安裝，請先安裝後再執行'" C-m
fi

# ───────────────────────────────────────────────────────
# Create Pane 2: 輔助 AI 工具 (右上 30%)
# ───────────────────────────────────────────────────────

# 垂直分割右側（30% 寬度）
tmux split-window -h -p 30 -t "$SESSION_NAME:1" -c "$PROJECT_DIR"

# 設定標題
tmux select-pane -t "${SESSION_NAME}:1.2" -T "🤖 ${AI_SECONDARY^}"

# 啟動輔助 AI 工具
if [[ "$SECONDARY_AVAILABLE" == true ]]; then
    tmux send-keys -t "${SESSION_NAME}:1.2" "$AI_SECONDARY" C-m
else
    tmux send-keys -t "${SESSION_NAME}:1.2" "echo '⚠️  $AI_SECONDARY 未安裝，請先安裝後再執行'" C-m
fi

# ───────────────────────────────────────────────────────
# Create Pane 3: Monitor (右下 30%)
# ───────────────────────────────────────────────────────

# 在右側 pane 下方再分割（50% 高度）
tmux split-window -v -p 50 -t "$SESSION_NAME:1.2" -c "$PROJECT_DIR"

# 設定標題
tmux select-pane -t "${SESSION_NAME}:1.3" -T "📊 Monitor"

# 顯示提示訊息（不自動執行程式）
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

# 回到 Codex CLI pane（主工作區）
tmux select-pane -t "${SESSION_NAME}:1.1"

# 連接到 session
echo "✅ Session 建立完成！正在連接..."
sleep 1  # 給一點時間讓 CLI 啟動

tmux attach-session -t "$SESSION_NAME"
