#!/usr/bin/env bats
# ═══════════════════════════════════════════════════════
# install.sh 測試套件
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
# 腳本存在性和權限測試
# ───────────────────────────────────────────────────────

@test "install.sh exists and is executable" {
    [ -f "$PROJECT_ROOT/tmux/install.sh" ]
    [ -x "$PROJECT_ROOT/tmux/install.sh" ]
}

@test "install.sh has valid bash shebang" {
    local first_line=$(head -1 "$PROJECT_ROOT/tmux/install.sh")
    [[ "$first_line" =~ ^#!/.*bash ]]
}

# ───────────────────────────────────────────────────────
# 語法檢查
# ───────────────────────────────────────────────────────

@test "install.sh has valid bash syntax" {
    run bash -n "$PROJECT_ROOT/tmux/install.sh"
    [ "$status" -eq 0 ]
}

# ───────────────────────────────────────────────────────
# 功能測試（Dry-run 或 Mock）
# ───────────────────────────────────────────────────────

@test "install.sh checks for tmux" {
    # 檢查腳本內容是否包含 tmux 檢查
    grep -q "tmux" "$PROJECT_ROOT/tmux/install.sh"
}

@test "install.sh mentions AI tools" {
    # 檢查是否提及 AI 工具
    grep -q -E "(codex|claude)" "$PROJECT_ROOT/tmux/install.sh"
}

# ───────────────────────────────────────────────────────
# 文件複製目標檢查
# ───────────────────────────────────────────────────────

@test "install.sh references correct paths" {
    # 檢查是否引用了正確的目標路徑
    grep -q ".tmux.conf" "$PROJECT_ROOT/tmux/install.sh"
    grep -q ".local/bin" "$PROJECT_ROOT/tmux/install.sh"
}
