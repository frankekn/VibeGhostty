#!/usr/bin/env bats
# ═══════════════════════════════════════════════════════
# 布局腳本測試套件
# VibeGhostty Project
# ═══════════════════════════════════════════════════════

load setup

setup() {
    bats_setup
}

teardown() {
    bats_teardown
}

# ───────────────────────────────────────────────────────
# ai-workspace.sh 測試
# ───────────────────────────────────────────────────────

@test "ai-workspace.sh exists and is executable" {
    [ -f "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh" ]
    [ -x "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh" ]
}

@test "ai-workspace.sh has valid bash syntax" {
    run bash -n "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
    [ "$status" -eq 0 ]
}

@test "ai-workspace.sh has correct shebang" {
    local first_line=$(head -1 "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh")
    [[ "$first_line" =~ ^#!/.*bash ]]
}

@test "ai-workspace.sh mentions codex and claude" {
    grep -q "codex" "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
    grep -q "claude" "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
}

# ───────────────────────────────────────────────────────
# ai-compare.sh 測試
# ───────────────────────────────────────────────────────

@test "ai-compare.sh exists and is executable" {
    [ -f "$PROJECT_ROOT/tmux/layouts/ai-compare.sh" ]
    [ -x "$PROJECT_ROOT/tmux/layouts/ai-compare.sh" ]
}

@test "ai-compare.sh has valid bash syntax" {
    run bash -n "$PROJECT_ROOT/tmux/layouts/ai-compare.sh"
    [ "$status" -eq 0 ]
}

@test "ai-compare.sh creates 50/50 split" {
    # 檢查是否有 50% split 設定
    grep -q "\-p 50" "$PROJECT_ROOT/tmux/layouts/ai-compare.sh"
}

# ───────────────────────────────────────────────────────
# full-focus.sh 測試
# ───────────────────────────────────────────────────────

@test "full-focus.sh exists and is executable" {
    [ -f "$PROJECT_ROOT/tmux/layouts/full-focus.sh" ]
    [ -x "$PROJECT_ROOT/tmux/layouts/full-focus.sh" ]
}

@test "full-focus.sh has valid bash syntax" {
    run bash -n "$PROJECT_ROOT/tmux/layouts/full-focus.sh"
    [ "$status" -eq 0 ]
}

# ───────────────────────────────────────────────────────
# 共通測試（所有布局腳本）
# ───────────────────────────────────────────────────────

@test "all layout scripts use set -e" {
    # 確保所有腳本都有錯誤處理
    grep -q "set -e" "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
    grep -q "set -e" "$PROJECT_ROOT/tmux/layouts/ai-compare.sh"
    grep -q "set -e" "$PROJECT_ROOT/tmux/layouts/full-focus.sh"
}

@test "all layout scripts check for tmux" {
    # 確保所有腳本都與 tmux 互動
    grep -q "tmux" "$PROJECT_ROOT/tmux/layouts/ai-workspace.sh"
    grep -q "tmux" "$PROJECT_ROOT/tmux/layouts/ai-compare.sh"
    grep -q "tmux" "$PROJECT_ROOT/tmux/layouts/full-focus.sh"
}
