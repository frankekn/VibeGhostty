#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Shared helpers for VibeGhostty tmux layout scripts
# 把共用邏輯集中管理，避免每個腳本重複維護
# ═══════════════════════════════════════════════════════

set -euo pipefail

# 常用工具的安裝提示
declare -A VG_INSTALL_HINTS=(
    [codex]="npm install -g @codexhq/cli"
    [claude]="從 https://claude.com/code 下載"
)

# 解析專案目錄，確保存在並回傳絕對路徑
vg_resolve_project_dir() {
    local input_dir=${1:-$PWD}

    if [[ ! -d "$input_dir" ]]; then
        echo "❌ 錯誤：專案目錄不存在 '$input_dir'" >&2
        exit 1
    fi

    (cd "$input_dir" && pwd)
}

# 依據 git repo 自動產生 session 名稱
vg_session_name() {
    local fallback="$1"
    local project_dir="$2"
    local prefix="$3"

    if [[ -d "$project_dir/.git" ]]; then
        echo "${prefix}-$(basename "$project_dir")"
    else
        echo "$fallback"
    fi
}

# 檢查工具是否存在，不存在時顯示安裝提示
vg_check_tool() {
    local tool="$1"

    if command -v "$tool" &>/dev/null; then
        return 0
    fi

    echo "⚠️  '$tool' 未安裝"
    echo "   安裝方法："

    if [[ -n "${VG_INSTALL_HINTS[$tool]:-}" ]]; then
        echo "     ${VG_INSTALL_HINTS[$tool]}"
    else
        echo "     請查閱工具文檔"
    fi

    return 1
}

# 如 session 已存在，提供 attach / recreate / cancel 選項
vg_handle_existing_session() {
    local session_name="$1"

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        return
    fi

    echo "📌 Session '$session_name' 已存在"
    echo "選擇操作："
    echo "  1. 連接到現有 session (attach)"
    echo "  2. 刪除並重新建立 (recreate)"
    echo "  3. 取消 (cancel)"
    read -p "請選擇 [1/2/3]: " choice

    case $choice in
        1)
            echo "🔗 連接到 session '$session_name'..."
            tmux attach-session -t "$session_name"
            exit 0
            ;;
        2)
            echo "🗑️  刪除現有 session..."
            tmux kill-session -t "$session_name"
            ;;
        3|*)
            echo "❌ 已取消"
            exit 0
            ;;
    esac
}

# 顯示是否要繼續的提示，輸入 n/N 則離開
vg_confirm_continue() {
    local prompt_message="$1"
    local default_choice=${2:-Y}

    local prompt_suffix="[Y/n]"
    if [[ "$default_choice" =~ ^[Nn]$ ]]; then
        prompt_suffix="[y/N]"
    fi

    read -p "$prompt_message $prompt_suffix: " confirm

    if [[ -z "$confirm" ]]; then
        confirm="$default_choice"
    fi

    if [[ "$confirm" =~ ^[Nn]$ ]]; then
        echo "❌ 已取消"
        exit 0
    fi
}

# 清理 pane 並顯示手動啟動提示或錯誤訊息
vg_show_manual_launch() {
    local session_name="$1"
    local pane_id="$2"
    local display_name="$3"
    local command_name="$4"
    local available_flag="$5"

    tmux send-keys -t "${session_name}:${pane_id}" "clear" C-m

    if [[ "$available_flag" == true ]]; then
        tmux send-keys -t "${session_name}:${pane_id}" \
            "echo '💡 請在此 pane 手動啟動 ${display_name}（輸入：${command_name}）'" C-m
    else
        tmux send-keys -t "${session_name}:${pane_id}" \
            "echo '⚠️  ${command_name} 未安裝，請先安裝後再執行'" C-m
        if [[ -n "${VG_INSTALL_HINTS[$command_name]:-}" ]]; then
            tmux send-keys -t "${session_name}:${pane_id}" \
                "echo '   安裝方法：${VG_INSTALL_HINTS[$command_name]}'" C-m
        fi
    fi

    tmux send-keys -t "${session_name}:${pane_id}" "echo ''" C-m
}
