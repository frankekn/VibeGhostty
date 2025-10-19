#!/usr/bin/env bats
# ═══════════════════════════════════════════════════════
# ta 命令測試套件
# VibeGhostty Project
# ═══════════════════════════════════════════════════════

load setup

# ───────────────────────────────────────────────────────
# Setup and Teardown
# ───────────────────────────────────────────────────────

setup() {
    bats_setup

    # 確保 ta 命令可用
    export PATH="$PROJECT_ROOT/tmux/bin:$PATH"
}

teardown() {
    bats_teardown
}

# ───────────────────────────────────────────────────────
# 基礎功能測試
# ───────────────────────────────────────────────────────

@test "ta -h shows help message" {
    skip_if_missing tmux

    run ta -h

    [ "$status" -eq 0 ]
    assert_output_contains "智能 Tmux Session 管理工具"
    assert_output_contains "用法"
}

@test "ta --help shows help message" {
    skip_if_missing tmux

    run ta --help

    [ "$status" -eq 0 ]
    assert_output_contains "智能 Tmux Session 管理工具"
}

@test "ta -l lists sessions when none exist" {
    skip_if_missing tmux

    run ta -l

    [ "$status" -eq 1 ]
    assert_output_contains "目前沒有任何 tmux session"
}

@test "ta -l lists existing sessions" {
    skip_if_missing tmux

    # 創建測試 session
    local test_session=$(create_test_session)

    run ta -l

    [ "$status" -eq 0 ]
    assert_output_contains "$test_session"

    cleanup_test_session "$test_session"
}

@test "ta --list works same as ta -l" {
    skip_if_missing tmux

    local test_session=$(create_test_session)

    run ta --list

    [ "$status" -eq 0 ]
    assert_output_contains "$test_session"

    cleanup_test_session "$test_session"
}

# ───────────────────────────────────────────────────────
# Session 名稱偵測測試
# ───────────────────────────────────────────────────────

@test "ta detects git repo name correctly" {
    skip_if_missing tmux
    skip_if_missing git

    # 創建測試 git repo
    local repo_path=$(create_test_git_repo "$TEST_DIR/fixtures/my-awesome-project")
    cd "$repo_path"

    # ta 應該偵測到 repo 名稱
    # 因為 session 不存在，會詢問是否建立
    run bash -c 'echo "n" | ta'

    assert_output_contains "ai-my-awesome-project"

    cleanup_test_git_repo "$repo_path"
}

@test "ta uses directory name when not in git repo" {
    skip_if_missing tmux

    # 創建非 git 目錄
    local test_dir="$TEST_DIR/fixtures/non-git-project"
    mkdir -p "$test_dir"
    cd "$test_dir"

    run bash -c 'echo "n" | ta'

    assert_output_contains "ai-non-git-project"

    rm -rf "$test_dir"
}

# ───────────────────────────────────────────────────────
# Session 連接測試
# ───────────────────────────────────────────────────────

@test "ta -n attaches to existing session" {
    skip_if_missing tmux

    # 創建測試 session
    local test_session=$(create_test_session)

    # 在非 tmux 環境中，ta -n 應該嘗試 attach
    # 我們用 --help 來測試，不實際 attach（避免測試卡住）
    run ta -n "$test_session"

    # 如果不在 tmux 中，status 可能是錯誤的（因為無法真正 attach）
    # 但至少不應該顯示 "session 不存在"
    assert_output_not_contains "不存在"

    cleanup_test_session "$test_session"
}

@test "ta -n shows error for non-existent session" {
    skip_if_missing tmux

    run ta -n "non-existent-session-name"

    [ "$status" -eq 1 ]
    assert_output_contains "不存在"
}

@test "ta --name works same as ta -n" {
    skip_if_missing tmux

    local test_session=$(create_test_session)

    run ta --name "$test_session"

    assert_output_not_contains "不存在"

    cleanup_test_session "$test_session"
}

# ───────────────────────────────────────────────────────
# 錯誤處理測試
# ───────────────────────────────────────────────────────

@test "ta fails when tmux is not installed" {
    # 暫時隱藏 tmux
    local old_path="$PATH"
    export PATH="/usr/bin:/bin"

    run ta -h

    [ "$status" -eq 1 ]
    assert_output_contains "Tmux 未安裝"

    export PATH="$old_path"
}

@test "ta shows error for unknown option" {
    skip_if_missing tmux

    run ta --unknown-option

    [ "$status" -eq 1 ]
    assert_output_contains "未知的參數"
}

@test "ta -n requires session name argument" {
    skip_if_missing tmux

    run ta -n

    [ "$status" -eq 1 ]
    assert_output_contains "請指定 session 名稱"
}

# ───────────────────────────────────────────────────────
# 輸出格式測試
# ───────────────────────────────────────────────────────

@test "ta -l shows attached sessions with green indicator" {
    skip_if_missing tmux

    # 創建 attached session（在背景）
    local test_session=$(create_test_session)

    run ta -l

    [ "$status" -eq 0 ]
    # 檢查是否有綠色標記（attached 狀態）
    # 由於是 detached session，應該是黃色 ○
    assert_output_contains "○"

    cleanup_test_session "$test_session"
}

@test "ta help output includes examples" {
    skip_if_missing tmux

    run ta -h

    [ "$status" -eq 0 ]
    assert_output_contains "使用範例"
    assert_output_contains "cd ~/projects/VibeGhostty"
}

# ───────────────────────────────────────────────────────
# 整合測試
# ───────────────────────────────────────────────────────

@test "ta workflow: list -> create prompt -> cancel" {
    skip_if_missing tmux
    skip_if_missing git

    # 1. 列出 sessions（應該沒有）
    run ta -l
    [ "$status" -eq 1 ]

    # 2. 在 git repo 中執行 ta（session 不存在）
    local repo_path=$(create_test_git_repo)
    cd "$repo_path"

    # 3. 取消建立（輸入 n）
    run bash -c 'echo "n" | ta'
    assert_output_contains "ai-test-repo"
    assert_output_contains "已取消"

    # 4. 確認沒有建立 session
    run ta -l
    [ "$status" -eq 1 ]

    cleanup_test_git_repo "$repo_path"
}
