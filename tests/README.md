# VibeGhostty 測試文檔

## 📋 概述

本專案使用 [Bats](https://github.com/bats-core/bats-core)（Bash Automated Testing System）進行自動化測試。

## 🚀 快速開始

### 安裝測試依賴

```bash
# macOS
brew install bats-core

# Ubuntu/Debian
sudo apt-get install bats

# 手動安裝
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local
```

### 執行測試

```bash
# 執行所有測試
cd tests
bats *.bats

# 執行特定測試文件
bats ta.bats

# 詳細輸出
bats --tap *.bats

# 計時
bats --timing *.bats
```

## 📁 測試結構

```
tests/
├── README.md              # 本文件
├── setup.bash            # 共用測試函數和 helpers
├── helpers/              # 測試輔助工具
├── fixtures/             # 測試用固定數據
│   ├── .vibe/           # 測試用配置
│   ├── bin/             # Mock 命令
│   └── test-repo/       # 測試用 git repo
├── ta.bats              # ta 命令測試
├── tmux-launch.bats     # tmux-launch 測試
├── install.bats         # install.sh 測試
└── layouts.bats         # 布局腳本測試
```

## 🧪 測試指南

### 編寫測試

Bats 測試使用簡單的語法：

```bash
@test "description of test" {
    # 測試代碼
    run command_to_test arg1 arg2

    # 斷言
    [ "$status" -eq 0 ]              # 檢查退出碼
    [ "$output" = "expected" ]       # 檢查輸出

    # 或使用 helper functions
    assert_output_contains "text"
    assert_file_exists "/path/to/file"
}
```

### 使用 Setup Helpers

```bash
# 載入共用函數
load setup

setup() {
    bats_setup                    # 基礎設置
    export PATH="$PROJECT_ROOT/tmux/bin:$PATH"
}

teardown() {
    bats_teardown                 # 清理
}

@test "example" {
    skip_if_missing tmux          # 跳過（如果依賴不存在）

    run ta -h
    assert_output_contains "help" # 自訂斷言
}
```

### 可用的 Helper Functions

#### 測試管理
- `bats_setup` - 測試前設置
- `bats_teardown` - 測試後清理
- `skip_if_missing <cmd>` - 跳過測試（如果命令不存在）

#### Tmux Helpers
- `create_test_session [name]` - 創建測試 session
- `cleanup_test_session <name>` - 清理測試 session
- `cleanup_all_test_sessions` - 清理所有測試 sessions

#### 斷言 Helpers
- `assert_output_contains <text>` - 斷言輸出包含文字
- `assert_output_not_contains <text>` - 斷言輸出不包含文字
- `assert_file_exists <path>` - 斷言文件存在
- `assert_dir_exists <path>` - 斷言目錄存在

#### Mock Helpers
- `create_mock_command <name> <behavior>` - 創建 mock 命令
- `remove_mock_command <name>` - 移除 mock 命令

#### Git Helpers
- `create_test_git_repo [path]` - 創建測試 git repo
- `cleanup_test_git_repo [path]` - 清理測試 git repo

## 📊 測試覆蓋範圍

### ta 命令（tests/ta.bats）

- ✅ 基礎功能
  - `-h` / `--help` 幫助訊息
  - `-l` / `--list` 列出 sessions
  - `-n` / `--name` 指定 session 名稱

- ✅ Session 偵測
  - Git repo 名稱偵測
  - 目錄名稱偵測

- ✅ 錯誤處理
  - 缺少依賴（tmux）
  - 未知選項
  - 缺少參數

- ✅ 輸出格式
  - Attached/detached 狀態顯示
  - 幫助文檔包含範例

### tmux-launch（tests/tmux-launch.bats）
- ⏳ 待實作

### install.sh（tests/install.bats）
- ⏳ 待實作

### 布局腳本（tests/layouts.bats）
- ⏳ 待實作

## 🎯 測試最佳實踐

### 1. 測試隔離

每個測試應該獨立運行，不依賴其他測試：

```bash
@test "example" {
    # 設置測試環境
    local test_session=$(create_test_session)

    # 執行測試
    run ta -n "$test_session"

    # 清理
    cleanup_test_session "$test_session"
}
```

### 2. 使用 Skip

當依賴不存在時，跳過測試而非失敗：

```bash
@test "example" {
    skip_if_missing tmux "Tmux is required for this test"

    # 測試代碼...
}
```

### 3. 測試邊界情況

```bash
@test "handles empty input" {
    run command ""
    [ "$status" -ne 0 ]
}

@test "handles very long input" {
    run command "$(printf 'a%.0s' {1..10000})"
    # ...
}
```

### 4. 清晰的測試描述

```bash
# ✅ 好的描述
@test "ta -n attaches to existing session"

# ❌ 不好的描述
@test "test ta"
```

## 🐛 除錯測試

### 顯示詳細輸出

```bash
# 顯示所有輸出
bats --tap ta.bats

# 只執行單一測試
bats -f "specific test name" ta.bats
```

### 在測試中加入 debug

```bash
@test "example" {
    run ta -l

    # Debug 輸出
    echo "Status: $status"
    echo "Output: $output"

    [ "$status" -eq 0 ]
}
```

## 📈 CI/CD 整合

測試會在以下情況自動執行：

- Push 到 master, develop 分支
- Pull Request 到 master, develop
- Refactor 分支的 push

查看 `.github/workflows/tests.yml` 了解完整配置。

## 🔧 疑難排解

### 問題：測試卡住不動

**原因**：可能嘗試 attach 到 tmux session
**解決**：使用 mock 或避免實際 attach

```bash
# 不要這樣做
run ta -n test-session  # 可能卡住

# 而是測試輸出
run bash -c 'echo "n" | ta'
```

### 問題：測試失敗但手動執行正常

**原因**：環境變數或 PATH 不同
**解決**：檢查 `setup()` 函數設定

```bash
setup() {
    bats_setup
    export PATH="$PROJECT_ROOT/tmux/bin:$PATH"
}
```

### 問題：Tmux sessions 殘留

**原因**：測試失敗導致清理未執行
**解決**：手動清理

```bash
# 清理所有測試 sessions
tmux list-sessions | grep vibe-test | cut -d: -f1 | xargs -I {} tmux kill-session -t {}
```

## 📚 參考資源

- [Bats 官方文檔](https://bats-core.readthedocs.io/)
- [Bats GitHub](https://github.com/bats-core/bats-core)
- [Bats Tutorial](https://opensource.com/article/19/2/testing-bash-bats)

---

**最後更新**: 2025-10-19
**測試覆蓋率目標**: > 70%
