#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Shared helpers for VibeGhostty tmux layout scripts
# 集中共用邏輯，避免重複維護
# ═══════════════════════════════════════════════════════

set -eo pipefail

# ───────────────────────────────────────────────────────
# Environment helpers
# ───────────────────────────────────────────────────────

vg_is_non_interactive() {
    [[ "${VIBE_NON_INTERACTIVE:-0}" == "1" ]]
}

vg_should_force_recreate() {
    [[ "${VIBE_FORCE_RECREATE:-0}" == "1" ]]
}

vg_auto_confirm_default() {
    [[ "${VIBE_ASSUME_YES:-0}" == "1" ]]
}

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

# 取得工具安裝提示
vg_install_hint() {
    case "$1" in
        codex)
            echo "npm install -g @codexhq/cli"
            return 0
            ;;
        claude)
            echo "從 https://claude.com/code 下載"
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# 取得工具顯示名稱（首字大寫）
vg_tool_label() {
    case "$1" in
        codex)
            echo "Codex"
            ;;
        claude)
            echo "Claude"
            ;;
        *)
            # 近似的首字母大寫
            local raw="$1"
            local first_char="${raw:0:1}"
            local rest="${raw:1}"
            printf "%s%s\n" "$(echo "$first_char" | tr '[:lower:]' '[:upper:]')" "$rest"
            ;;
    esac
    return 0
}

# 檢查工具是否存在，不存在時顯示安裝提示
vg_check_tool() {
    local tool="$1"
    if command -v "$tool" &>/dev/null; then
        return 0
    fi

    echo "⚠️  '$tool' 未安裝"
    local hint
    if hint=$(vg_install_hint "$tool"); then
        echo "   安裝方法："
        echo "     $hint"
    else
        echo "   安裝方法：請查閱工具文檔"
    fi

    return 1
}

# 如 session 已存在，提供 attach / recreate / cancel 選項
vg_handle_existing_session() {
    local session_name="$1"

    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        return
    fi

    if vg_should_force_recreate; then
        echo "♻️  重新建立 session：$session_name"
        tmux kill-session -t "$session_name"
        return
    fi

    if vg_is_non_interactive; then
        echo "🔗 使用現有 session：$session_name"
        tmux attach-session -t "$session_name"
        exit 0
    fi

    echo "📌 Session '$session_name' 已存在"
    echo "選擇操作："
    echo "  1. 連接現有 session (attach)"
    echo "  2. 重新建立 (recreate)"
    echo "  3. 取消"
    read -p "請選擇 [1/2/3]: " choice

    case $choice in
        1)
            echo "🔗 連接到 session '$session_name'..."
            tmux attach-session -t "$session_name"
            exit 0
            ;;
        2)
            echo "♻️  刪除並重新建立 session..."
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

    if vg_auto_confirm_default; then
        return 0
    fi

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
            "echo '💡 請在此 pane 手動執行：${command_name}'" C-m
        tmux send-keys -t "${session_name}:${pane_id}" \
            "echo '   （範例：輸入上述指令後按 Enter）'" C-m
    else
        tmux send-keys -t "${session_name}:${pane_id}" \
            "echo '⚠️  ${command_name} 未安裝，請先安裝後再執行'" C-m
        local install_hint
        if install_hint=$(vg_install_hint "$command_name"); then
            tmux send-keys -t "${session_name}:${pane_id}" \
                "echo '   安裝方法：$install_hint'" C-m
        fi
    fi

    tmux send-keys -t "${session_name}:${pane_id}" "echo ''" C-m
}
