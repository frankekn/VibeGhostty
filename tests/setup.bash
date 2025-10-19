#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Bats Test Setup - 共用測試函數
# VibeGhostty Project
# ═══════════════════════════════════════════════════════

# 測試專用路徑
TEST_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")" && pwd)"
PROJECT_ROOT="$(cd "$TEST_DIR/.." && pwd)"

# 測試專用 tmux session 名稱
TEST_SESSION_PREFIX="vibe-test"

# ───────────────────────────────────────────────────────
# Helper Functions
# ───────────────────────────────────────────────────────

# 創建測試用 tmux session
create_test_session() {
    local session_name="${1:-${TEST_SESSION_PREFIX}-$$}"
    tmux new-session -d -s "$session_name"
    echo "$session_name"
}

# 清理測試用 tmux session
cleanup_test_session() {
    local session_name="$1"
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux kill-session -t "$session_name"
    fi
}

# 清理所有測試 sessions
cleanup_all_test_sessions() {
    tmux list-sessions -F "#{session_name}" 2>/dev/null | \
        grep "^${TEST_SESSION_PREFIX}" | \
        xargs -I {} tmux kill-session -t {} 2>/dev/null || true
}

# 檢查命令是否存在
command_exists() {
    command -v "$1" &>/dev/null
}

# 跳過測試（如果依賴不存在）
skip_if_missing() {
    local cmd="$1"
    local reason="${2:-$cmd is not installed}"

    if ! command_exists "$cmd"; then
        skip "$reason"
    fi
}

# ───────────────────────────────────────────────────────
# Setup and Teardown Helpers
# ───────────────────────────────────────────────────────

# 測試前設置
bats_setup() {
    # 確保測試環境乾淨
    cleanup_all_test_sessions

    # 設定測試用環境變數
    export VIBE_TEST_MODE=1
    export VIBE_HOME="$TEST_DIR/fixtures/.vibe"
    export VIBE_LAYOUTS="$TEST_DIR/fixtures/layouts"

    # 創建測試目錄
    mkdir -p "$VIBE_HOME" "$VIBE_LAYOUTS"
}

# 測試後清理
bats_teardown() {
    # 清理測試 sessions
    cleanup_all_test_sessions

    # 清理測試文件
    rm -rf "$TEST_DIR/fixtures/.vibe" 2>/dev/null || true
}

# ───────────────────────────────────────────────────────
# Assertion Helpers
# ───────────────────────────────────────────────────────

# 斷言輸出包含指定文字
assert_output_contains() {
    local expected="$1"
    if [[ ! "$output" =~ $expected ]]; then
        echo "Expected output to contain: $expected"
        echo "Actual output: $output"
        return 1
    fi
}

# 斷言輸出不包含指定文字
assert_output_not_contains() {
    local unexpected="$1"
    if [[ "$output" =~ $unexpected ]]; then
        echo "Expected output NOT to contain: $unexpected"
        echo "Actual output: $output"
        return 1
    fi
}

# 斷言文件存在
assert_file_exists() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Expected file to exist: $file"
        return 1
    fi
}

# 斷言目錄存在
assert_dir_exists() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Expected directory to exist: $dir"
        return 1
    fi
}

# ───────────────────────────────────────────────────────
# Mock Helpers
# ───────────────────────────────────────────────────────

# 創建 mock 命令
create_mock_command() {
    local name="$1"
    local behavior="$2"

    local mock_dir="$TEST_DIR/fixtures/bin"
    mkdir -p "$mock_dir"

    cat > "$mock_dir/$name" << EOF
#!/usr/bin/env bash
$behavior
EOF

    chmod +x "$mock_dir/$name"
    export PATH="$mock_dir:$PATH"
}

# 移除 mock 命令
remove_mock_command() {
    local name="$1"
    rm -f "$TEST_DIR/fixtures/bin/$name"
}

# ───────────────────────────────────────────────────────
# Git Helpers（用於測試 ta 的 git repo 偵測）
# ───────────────────────────────────────────────────────

# 創建測試用 git repo
create_test_git_repo() {
    local repo_path="${1:-$TEST_DIR/fixtures/test-repo}"

    mkdir -p "$repo_path"
    cd "$repo_path"
    git init --quiet
    git config user.email "test@vibeghostty.test"
    git config user.name "Test User"
    echo "test" > README.md
    git add README.md
    git commit -m "Initial commit" --quiet

    echo "$repo_path"
}

# 清理測試 git repo
cleanup_test_git_repo() {
    local repo_path="${1:-$TEST_DIR/fixtures/test-repo}"
    rm -rf "$repo_path"
}
