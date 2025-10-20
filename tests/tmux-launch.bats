#!/usr/bin/env bats
# ═══════════════════════════════════════════════════════
# tmux-launch 命令測試套件
# VibeGhostty Project
# ═══════════════════════════════════════════════════════

load setup

setup() {
    bats_setup
    export PATH="$PROJECT_ROOT/tmux/bin:$PATH"
}

teardown() {
    bats_teardown
}

# ───────────────────────────────────────────────────────
# 基礎功能測試
# ───────────────────────────────────────────────────────

@test "tmux-launch exists and is executable" {
    [ -x "$PROJECT_ROOT/tmux/bin/tmux-launch" ]
}

@test "tmux-launch requires tmux" {
    skip_if_missing tmux

    run tmux-launch
    # 應該顯示選單或執行，不應該立即報錯
    [ "$status" -ne 127 ]
}

# ───────────────────────────────────────────────────────
# 互動測試（需要 input）
# ───────────────────────────────────────────────────────

@test "tmux-launch with quit option" {
    skip_if_missing tmux

    # 輸入 q 退出
    run bash -c 'echo "q" | tmux-launch'

    # 應該正常退出並顯示選單
    assert_output_contains "Select"
    assert_output_contains "Goodbye"
}

# ───────────────────────────────────────────────────────
# 布局腳本存在性測試
# ───────────────────────────────────────────────────────

@test "tmux-launch can access layout scripts" {
    assert_file_exists "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
    assert_file_exists "$PROJECT_ROOT/tmux/layouts/ai-split.sh"
    assert_file_exists "$PROJECT_ROOT/tmux/layouts/full-focus.sh"
}

@test "layout scripts are executable" {
    [ -x "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh" ]
    [ -x "$PROJECT_ROOT/tmux/layouts/ai-split.sh" ]
    [ -x "$PROJECT_ROOT/tmux/layouts/full-focus.sh" ]
}
