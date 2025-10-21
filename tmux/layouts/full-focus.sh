#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Full Focus Layout for Tmux
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/layout-common.sh"

# ───────────────────────────────────────────────────────
# Configuration
# ───────────────────────────────────────────────────────

PROJECT_DIR="$(vg_resolve_project_dir "${1:-}")"
DEFAULT_AI="${VIBE_AI_FOCUS:-codex}"
AI_CHOICE="${2:-$DEFAULT_AI}"

if [[ "$AI_CHOICE" != "codex" && "$AI_CHOICE" != "claude" ]]; then
    echo "❌ 錯誤：AI 選擇必須是 'codex' 或 'claude'"
    echo "   使用方法: $0 [project_dir] [codex|claude]"
    echo "   或設定環境變數: export VIBE_AI_FOCUS=claude"
    exit 1
fi

SESSION_NAME="$(vg_session_name "ai-focus" "$PROJECT_DIR" "focus")"

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
# Check Tool
# ───────────────────────────────────────────────────────

echo ""

AI_AVAILABLE=false
if vg_check_tool "$AI_COMMAND"; then
    AI_AVAILABLE=true
fi

echo ""

if [[ "$AI_AVAILABLE" == false ]]; then
    echo "❌ 錯誤：選擇的 AI 工具 '$AI_COMMAND' 未安裝"
    echo "   請先安裝後再執行"
    echo ""
    vg_confirm_continue "是否仍要建立 session（僅建立空 shell）？" "N"
    echo ""
    echo "⚠️  將建立僅包含 shell 的 session"
    echo ""
fi

# ───────────────────────────────────────────────────────
# Existing session handling
# ───────────────────────────────────────────────────────

vg_handle_existing_session "$SESSION_NAME"

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

tmux select-pane -t "${SESSION_NAME}:1.1" -T "$AI_EMOJI $AI_NAME (Focus Mode)"

vg_show_manual_launch "$SESSION_NAME" "1.1" "$AI_NAME" "$AI_COMMAND" "$AI_AVAILABLE"

# ───────────────────────────────────────────────────────
# Final Setup
# ───────────────────────────────────────────────────────

echo "✅ Focus session 建立完成！"

if [[ "${VIBE_SKIP_ATTACH:-0}" == "1" ]]; then
    echo "ℹ️ 已建立 session：$SESSION_NAME（跳過自動 attach）"
    exit 0
fi

sleep 1
tmux attach-session -t "$SESSION_NAME"
