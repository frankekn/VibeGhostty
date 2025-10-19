# VibeGhostty 兩級配置系統設計文檔

> 為 vibe-start 工具設計的簡化配置系統

**版本**: 1.0.0
**日期**: 2025-10-19
**作者**: System Architecture Design

---

## 目錄

1. [設計概述](#設計概述)
2. [配置架構](#配置架構)
3. [配置格式範例](#配置格式範例)
4. [配置項清單](#配置項清單)
5. [使用場景](#使用場景)
6. [實作建議](#實作建議)
7. [遷移路徑](#遷移路徑)

---

## 設計概述

### 核心設計原則

**80/20 法則**: 20% 的配置選項滿足 80% 的使用需求

1. **簡單優先**: 扁平化結構，避免嵌套複雜度
2. **合理預設**: 90% 場景不需要任何配置
3. **漸進配置**: 從零配置到完全自訂
4. **約定優於配置**: 自動偵測優於明確配置
5. **最小驚訝原則**: 行為符合直覺預期

### 設計目標

- ✅ **零配置即可用**: 無配置文件時使用智能預設
- ✅ **兩級覆蓋**: 全局 → 專案 → 環境變數 → 命令列參數
- ✅ **易於編輯**: 人類可讀，註解友好
- ✅ **易於解析**: Shell 腳本直接 source
- ✅ **向後兼容**: 支援現有環境變數系統

### 非目標

- ❌ 不支援複雜的嵌套配置
- ❌ 不提供 GUI 配置工具
- ❌ 不支援配置驗證 DSL
- ❌ 不做動態配置熱重載

---

## 配置架構

### 層次結構圖

```
優先級（從高到低）:

1. 命令列參數              vibe-start --layout=focus --ai=claude
   ↓
2. 環境變數                export VIBE_AI_PRIMARY=claude
   ↓
3. 專案配置                .vibe/config (當前專案根目錄)
   ↓
4. 全局配置                ~/.vibe/config (用戶主目錄)
   ↓
5. 內建預設值              腳本硬編碼的預設值
```

### 配置文件位置

```bash
# 全局配置（用戶層級）
~/.vibe/
├── config           # 主配置文件（必須）
└── layouts/         # 自訂布局腳本（可選，未來功能）

# 專案配置（專案層級）
<project-root>/.vibe/
├── config           # 專案覆蓋配置（可選）
└── .gitignore       # 建議加入 config 到 .gitignore（含敏感信息時）
```

### 優先級規則

1. **命令列參數 > 所有配置**: 明確的用戶意圖
2. **環境變數 > 配置文件**: 臨時覆蓋或 CI/CD 場景
3. **專案配置 > 全局配置**: 專案特定需求
4. **全局配置 > 內建預設**: 用戶偏好
5. **存在檢查**: 缺失的配置項回退到下一層級

---

## 配置格式範例

### 格式選擇: Shell Source 格式

**選擇理由**:
- ✅ Bash 原生支援（`source ~/.vibe/config`）
- ✅ 無需額外解析器
- ✅ 支援註解和環境變數展開
- ✅ 與現有環境變數系統一致
- ❌ 不支援複雜數據結構（但我們不需要）

### 全局配置範例

**文件**: `~/.vibe/config`

```bash
# ═══════════════════════════════════════════════════════
# VibeGhostty 全局配置
# ═══════════════════════════════════════════════════════
#
# 此文件定義 vibe-start 的預設行為
# 專案特定配置可在 <project>/.vibe/config 中覆蓋
#
# 格式: KEY=value（不要有空格）
# 註解: 使用 # 開頭
#
# ═══════════════════════════════════════════════════════

# ───────────────────────────────────────────────────────
# AI 工具配置
# ───────────────────────────────────────────────────────

# 主要 AI 工具（左側或上方 pane）
# 選項: codex | claude | cursor | aider
VIBE_AI_PRIMARY=codex

# 輔助 AI 工具（右側或下方 pane）
# 選項: codex | claude | cursor | aider | none
VIBE_AI_SECONDARY=claude

# 專注模式使用的 AI 工具
# 選項: codex | claude | cursor | aider
VIBE_AI_FOCUS=codex

# ───────────────────────────────────────────────────────
# 布局配置
# ───────────────────────────────────────────────────────

# 預設布局
# 選項: workspace | compare | focus
VIBE_DEFAULT_LAYOUT=workspace

# 自動選擇布局（根據專案類型）
# 選項: true | false
VIBE_AUTO_LAYOUT=false

# ───────────────────────────────────────────────────────
# Session 管理
# ───────────────────────────────────────────────────────

# Session 命名模式
# 選項: auto | git | dir | custom
# - auto: 自動偵測（git repo 名稱 > 目錄名稱）
# - git: 僅使用 git repo 名稱（非 git repo 則使用 dir）
# - dir: 使用目錄名稱
# - custom: 使用 VIBE_SESSION_NAME 的值
VIBE_SESSION_NAMING=auto

# 自訂 session 名稱前綴（當 VIBE_SESSION_NAMING=custom）
# VIBE_SESSION_PREFIX=ai-

# Session 已存在時的行為
# 選項: attach | ask | recreate | new
# - attach: 直接連接到現有 session
# - ask: 詢問用戶（互動模式）
# - recreate: 刪除舊的，建立新的
# - new: 建立新的帶數字後綴的 session（如 ai-work-2）
VIBE_SESSION_EXISTS=ask

# ───────────────────────────────────────────────────────
# 專案偵測
# ───────────────────────────────────────────────────────

# 專案根目錄偵測
# 選項: auto | git | pwd
# - auto: .git > .vibe > package.json > requirements.txt > pwd
# - git: 僅偵測 git 根目錄
# - pwd: 使用當前目錄
VIBE_PROJECT_DETECT=auto

# 是否切換到專案根目錄
# 選項: true | false
VIBE_CHANGE_TO_ROOT=true

# ───────────────────────────────────────────────────────
# 工具檢查
# ───────────────────────────────────────────────────────

# 工具未安裝時的行為
# 選項: ask | skip | abort
# - ask: 詢問是否繼續（預設）
# - skip: 跳過缺失的工具，繼續建立 session
# - abort: 中止並顯示安裝指引
VIBE_MISSING_TOOL=ask

# 啟動前檢查工具版本
# 選項: true | false
VIBE_CHECK_VERSION=false

# ───────────────────────────────────────────────────────
# 互動性
# ───────────────────────────────────────────────────────

# 顯示詳細訊息
# 選項: true | false
VIBE_VERBOSE=true

# 顯示布局選擇選單（當未指定布局時）
# 選項: true | false
VIBE_SHOW_MENU=true

# 確認提示（重大操作前）
# 選項: true | false
VIBE_CONFIRM=true

# ───────────────────────────────────────────────────────
# 進階選項
# ───────────────────────────────────────────────────────

# Tmux socket 名稱（多用戶環境）
# VIBE_TMUX_SOCKET=default

# 自訂布局腳本目錄（未來功能）
# VIBE_LAYOUTS_DIR=~/.vibe/layouts

# 日誌級別
# 選項: silent | normal | verbose | debug
VIBE_LOG_LEVEL=normal
```

### 專案配置範例

**文件**: `<project-root>/.vibe/config`

```bash
# ═══════════════════════════════════════════════════════
# VibeGhostty 專案配置
# ═══════════════════════════════════════════════════════
#
# 此專案特定配置會覆蓋全局設定
# 僅列出需要覆蓋的項目即可
#
# 專案: Frontend Application
# ═══════════════════════════════════════════════════════

# 前端專案偏好使用 Claude
VIBE_AI_PRIMARY=claude
VIBE_AI_SECONDARY=codex

# 預設使用比較布局（評估不同 AI 建議）
VIBE_DEFAULT_LAYOUT=compare

# 靜默模式（CI/CD 環境）
VIBE_VERBOSE=false
VIBE_CONFIRM=false

# 缺失工具時跳過（不中斷 CI 流程）
VIBE_MISSING_TOOL=skip
```

### 最小配置範例

**只配置最常用的選項**:

```bash
# ~/.vibe/config (最小配置)

# 我偏好 Claude 作為主工具
VIBE_AI_PRIMARY=claude

# 預設使用工作空間布局
VIBE_DEFAULT_LAYOUT=workspace
```

**其他所有選項使用內建預設值**

---

## 配置項清單

### AI 工具配置

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_AI_PRIMARY` | string | `codex` | 主要 AI 工具 | 否 |
| `VIBE_AI_SECONDARY` | string | `claude` | 輔助 AI 工具 | 否 |
| `VIBE_AI_FOCUS` | string | `codex` | 專注模式 AI 工具 | 否 |

**有效值**: `codex`, `claude`, `cursor`, `aider`, `none`（僅 SECONDARY）

### 布局配置

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_DEFAULT_LAYOUT` | string | `workspace` | 預設布局類型 | 否 |
| `VIBE_AUTO_LAYOUT` | boolean | `false` | 是否自動選擇布局 | 否 |

**有效值（布局）**: `workspace`, `compare`, `focus`

### Session 管理

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_SESSION_NAMING` | string | `auto` | Session 命名策略 | 否 |
| `VIBE_SESSION_PREFIX` | string | `""` | Session 名稱前綴 | 否 |
| `VIBE_SESSION_EXISTS` | string | `ask` | 已存在時的行為 | 否 |

**有效值（命名）**: `auto`, `git`, `dir`, `custom`
**有效值（存在）**: `attach`, `ask`, `recreate`, `new`

### 專案偵測

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_PROJECT_DETECT` | string | `auto` | 專案根目錄偵測方式 | 否 |
| `VIBE_CHANGE_TO_ROOT` | boolean | `true` | 是否切換到根目錄 | 否 |

**有效值（偵測）**: `auto`, `git`, `pwd`

### 工具檢查

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_MISSING_TOOL` | string | `ask` | 工具缺失時的行為 | 否 |
| `VIBE_CHECK_VERSION` | boolean | `false` | 是否檢查工具版本 | 否 |

**有效值（缺失）**: `ask`, `skip`, `abort`

### 互動性

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_VERBOSE` | boolean | `true` | 顯示詳細訊息 | 否 |
| `VIBE_SHOW_MENU` | boolean | `true` | 顯示選單 | 否 |
| `VIBE_CONFIRM` | boolean | `true` | 重大操作前確認 | 否 |

### 進階選項

| 配置項 | 類型 | 預設值 | 說明 | 必需 |
|-------|------|-------|------|------|
| `VIBE_LOG_LEVEL` | string | `normal` | 日誌級別 | 否 |
| `VIBE_TMUX_SOCKET` | string | `default` | Tmux socket 名稱 | 否 |
| `VIBE_LAYOUTS_DIR` | string | `~/.vibe/layouts` | 自訂布局目錄 | 否 |

**有效值（日誌）**: `silent`, `normal`, `verbose`, `debug`

### 配置項分類總結

```
總配置項: 18 個
├─ AI 工具: 3 個
├─ 布局: 2 個
├─ Session: 3 個
├─ 專案: 2 個
├─ 工具檢查: 2 個
├─ 互動性: 3 個
└─ 進階: 3 個

必需配置項: 0 個（所有都是可選）
```

---

## 使用場景

### 場景 1: 純 Claude 用戶（全局配置）

**需求**: 只使用 Claude，不需要 Codex

**配置**: `~/.vibe/config`

```bash
VIBE_AI_PRIMARY=claude
VIBE_AI_SECONDARY=none
VIBE_AI_FOCUS=claude
```

**使用**:

```bash
# 自動使用 Claude
vibe-start

# 結果: workspace 布局，主 pane 執行 claude，無輔助 pane
```

### 場景 2: 專案特定 AI 選擇

**需求**: Frontend 用 Claude，Backend 用 Codex

**全局配置**: `~/.vibe/config`

```bash
VIBE_AI_PRIMARY=codex  # 預設
```

**Frontend 專案**: `~/projects/frontend/.vibe/config`

```bash
VIBE_AI_PRIMARY=claude
VIBE_DEFAULT_LAYOUT=compare
```

**Backend 專案**: `~/projects/backend/.vibe/config`

```bash
VIBE_AI_PRIMARY=codex
VIBE_DEFAULT_LAYOUT=workspace
```

**使用**:

```bash
cd ~/projects/frontend
vibe-start              # 使用 claude + compare 布局

cd ~/projects/backend
vibe-start              # 使用 codex + workspace 布局
```

### 場景 3: CI/CD 環境（環境變數覆蓋）

**需求**: 自動化測試環境，無互動

**配置**: 透過環境變數設定

```bash
export VIBE_VERBOSE=false
export VIBE_CONFIRM=false
export VIBE_MISSING_TOOL=skip
export VIBE_DEFAULT_LAYOUT=focus
export VIBE_AI_PRIMARY=codex

vibe-start
```

### 場景 4: 臨時嘗試不同布局（命令列覆蓋）

**需求**: 不改變配置，臨時使用不同布局

**使用**:

```bash
# 全局配置: workspace
# 臨時使用 compare 布局
vibe-start --layout=compare

# 臨時使用 Claude
vibe-start --ai=claude --layout=focus

# 命令列參數優先級最高
```

### 場景 5: 團隊協作（專案配置 + .gitignore）

**需求**: 團隊共享配置，但允許個人覆蓋

**專案配置**: `<project>/.vibe/config`（提交到 git）

```bash
# 團隊標準配置
VIBE_DEFAULT_LAYOUT=workspace
VIBE_SESSION_EXISTS=attach
VIBE_MISSING_TOOL=abort  # 確保工具已安裝
```

**個人配置**: `<project>/.vibe/config.local`（加入 .gitignore）

```bash
# 個人覆蓋（不提交到 git）
VIBE_AI_PRIMARY=claude   # 個人偏好
VIBE_VERBOSE=false       # 個人喜歡靜默模式
```

**實作**: vibe-start 依次載入 config 和 config.local

---

## 實作建議

### 配置讀取流程

```bash
#!/usr/bin/env bash
# vibe-start 配置載入邏輯

# ───────────────────────────────────────────────────────
# 1. 設定內建預設值
# ───────────────────────────────────────────────────────
VIBE_AI_PRIMARY="${VIBE_AI_PRIMARY:-codex}"
VIBE_AI_SECONDARY="${VIBE_AI_SECONDARY:-claude}"
VIBE_AI_FOCUS="${VIBE_AI_FOCUS:-codex}"
VIBE_DEFAULT_LAYOUT="${VIBE_DEFAULT_LAYOUT:-workspace}"
VIBE_SESSION_NAMING="${VIBE_SESSION_NAMING:-auto}"
VIBE_SESSION_EXISTS="${VIBE_SESSION_EXISTS:-ask}"
VIBE_PROJECT_DETECT="${VIBE_PROJECT_DETECT:-auto}"
VIBE_CHANGE_TO_ROOT="${VIBE_CHANGE_TO_ROOT:-true}"
VIBE_MISSING_TOOL="${VIBE_MISSING_TOOL:-ask}"
VIBE_CHECK_VERSION="${VIBE_CHECK_VERSION:-false}"
VIBE_VERBOSE="${VIBE_VERBOSE:-true}"
VIBE_SHOW_MENU="${VIBE_SHOW_MENU:-true}"
VIBE_CONFIRM="${VIBE_CONFIRM:-true}"
VIBE_AUTO_LAYOUT="${VIBE_AUTO_LAYOUT:-false}"
VIBE_LOG_LEVEL="${VIBE_LOG_LEVEL:-normal}"
VIBE_TMUX_SOCKET="${VIBE_TMUX_SOCKET:-default}"
VIBE_LAYOUTS_DIR="${VIBE_LAYOUTS_DIR:-$HOME/.vibe/layouts}"

# ───────────────────────────────────────────────────────
# 2. 載入全局配置（如果存在）
# ───────────────────────────────────────────────────────
GLOBAL_CONFIG="$HOME/.vibe/config"
if [[ -f "$GLOBAL_CONFIG" ]]; then
    # shellcheck source=/dev/null
    source "$GLOBAL_CONFIG"
fi

# ───────────────────────────────────────────────────────
# 3. 偵測專案根目錄
# ───────────────────────────────────────────────────────
detect_project_root() {
    local current_dir="$PWD"

    case "$VIBE_PROJECT_DETECT" in
        auto)
            # 優先順序: .git > .vibe > package.json > requirements.txt > pwd
            while [[ "$current_dir" != "/" ]]; do
                if [[ -d "$current_dir/.git" ]] || \
                   [[ -d "$current_dir/.vibe" ]] || \
                   [[ -f "$current_dir/package.json" ]] || \
                   [[ -f "$current_dir/requirements.txt" ]]; then
                    echo "$current_dir"
                    return
                fi
                current_dir=$(dirname "$current_dir")
            done
            echo "$PWD"
            ;;
        git)
            git rev-parse --show-toplevel 2>/dev/null || echo "$PWD"
            ;;
        pwd)
            echo "$PWD"
            ;;
        *)
            echo "$PWD"
            ;;
    esac
}

PROJECT_ROOT=$(detect_project_root)

# ───────────────────────────────────────────────────────
# 4. 載入專案配置（如果存在）
# ───────────────────────────────────────────────────────
PROJECT_CONFIG="$PROJECT_ROOT/.vibe/config"
if [[ -f "$PROJECT_CONFIG" ]]; then
    # shellcheck source=/dev/null
    source "$PROJECT_CONFIG"
fi

# 載入專案本地配置（個人覆蓋，不提交到 git）
PROJECT_LOCAL_CONFIG="$PROJECT_ROOT/.vibe/config.local"
if [[ -f "$PROJECT_LOCAL_CONFIG" ]]; then
    # shellcheck source=/dev/null
    source "$PROJECT_LOCAL_CONFIG"
fi

# ───────────────────────────────────────────────────────
# 5. 環境變數已自動覆蓋（Bash 特性）
# ───────────────────────────────────────────────────────
# 因為使用 ${VAR:-default} 語法，環境變數會自動優先

# ───────────────────────────────────────────────────────
# 6. 解析命令列參數（最高優先級）
# ───────────────────────────────────────────────────────
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --ai=*)
                VIBE_AI_PRIMARY="${1#*=}"
                shift
                ;;
            --layout=*)
                VIBE_DEFAULT_LAYOUT="${1#*=}"
                shift
                ;;
            --session=*)
                VIBE_SESSION_NAME="${1#*=}"
                VIBE_SESSION_NAMING=custom
                shift
                ;;
            --no-confirm)
                VIBE_CONFIRM=false
                shift
                ;;
            --verbose)
                VIBE_VERBOSE=true
                shift
                ;;
            --quiet)
                VIBE_VERBOSE=false
                shift
                ;;
            *)
                # 位置參數（如專案目錄）
                PROJECT_DIR="$1"
                shift
                ;;
        esac
    done
}

parse_args "$@"

# ───────────────────────────────────────────────────────
# 7. 配置已完全載入，開始使用
# ───────────────────────────────────────────────────────
```

### 驗證規則

```bash
# 驗證配置值的有效性
validate_config() {
    local errors=0

    # 驗證 AI 工具
    case "$VIBE_AI_PRIMARY" in
        codex|claude|cursor|aider) ;;
        *)
            echo "❌ 錯誤: VIBE_AI_PRIMARY='$VIBE_AI_PRIMARY' 無效"
            echo "   有效值: codex, claude, cursor, aider"
            ((errors++))
            ;;
    esac

    # 驗證布局
    case "$VIBE_DEFAULT_LAYOUT" in
        workspace|compare|focus) ;;
        *)
            echo "❌ 錯誤: VIBE_DEFAULT_LAYOUT='$VIBE_DEFAULT_LAYOUT' 無效"
            echo "   有效值: workspace, compare, focus"
            ((errors++))
            ;;
    esac

    # 驗證布林值
    case "$VIBE_VERBOSE" in
        true|false) ;;
        *)
            echo "⚠️  警告: VIBE_VERBOSE='$VIBE_VERBOSE' 無效，使用 true"
            VIBE_VERBOSE=true
            ;;
    esac

    # 其他驗證...

    if [[ $errors -gt 0 ]]; then
        echo ""
        echo "發現 $errors 個配置錯誤，請修正後重試"
        return 1
    fi

    return 0
}

# 在啟動前驗證
validate_config || exit 1
```

### 錯誤處理

```bash
# 錯誤類型
# 1. 配置文件語法錯誤
# 2. 配置值無效
# 3. 必要工具缺失
# 4. 權限問題

# 語法錯誤檢查
check_config_syntax() {
    local config_file="$1"

    # 嘗試在 subshell 中載入配置
    if ! (source "$config_file") 2>/dev/null; then
        echo "❌ 錯誤: 配置文件語法錯誤"
        echo "   檔案: $config_file"
        echo ""
        echo "請檢查："
        echo "  - 是否有未配對的引號"
        echo "  - 變數名稱是否正確（VIBE_ 開頭）"
        echo "  - 等號兩邊不要有空格（KEY=value，不是 KEY = value）"
        return 1
    fi

    return 0
}

# 配置衝突檢測
check_config_conflicts() {
    # 檢查不兼容的配置組合
    if [[ "$VIBE_AI_PRIMARY" == "none" ]]; then
        echo "❌ 錯誤: VIBE_AI_PRIMARY 不能為 'none'"
        return 1
    fi

    if [[ "$VIBE_DEFAULT_LAYOUT" == "compare" ]] && \
       [[ "$VIBE_AI_SECONDARY" == "none" ]]; then
        echo "⚠️  警告: compare 布局需要兩個 AI 工具"
        echo "   將 VIBE_AI_SECONDARY 改為 'claude'"
        VIBE_AI_SECONDARY=claude
    fi

    return 0
}
```

### 配置初始化助手

```bash
# vibe-config init
# 互動式建立配置文件

vibe_config_init() {
    local config_type="${1:-global}"  # global 或 project
    local config_file

    if [[ "$config_type" == "global" ]]; then
        config_file="$HOME/.vibe/config"
        mkdir -p "$HOME/.vibe"
    else
        config_file=".vibe/config"
        mkdir -p ".vibe"
    fi

    if [[ -f "$config_file" ]]; then
        echo "配置文件已存在: $config_file"
        read -p "是否覆蓋？ [y/N]: " confirm
        [[ "$confirm" != "y" ]] && return
    fi

    echo "建立 VibeGhostty 配置..."
    echo ""

    # 互動式詢問
    read -p "主要 AI 工具 [codex/claude/cursor/aider]: " ai_primary
    ai_primary="${ai_primary:-codex}"

    read -p "輔助 AI 工具 [codex/claude/cursor/aider/none]: " ai_secondary
    ai_secondary="${ai_secondary:-claude}"

    read -p "預設布局 [workspace/compare/focus]: " layout
    layout="${layout:-workspace}"

    # 寫入配置
    cat > "$config_file" <<EOF
# VibeGhostty 配置
# 自動生成於 $(date)

VIBE_AI_PRIMARY=$ai_primary
VIBE_AI_SECONDARY=$ai_secondary
VIBE_AI_FOCUS=$ai_primary
VIBE_DEFAULT_LAYOUT=$layout
EOF

    echo "✅ 配置已建立: $config_file"
}
```

### 配置診斷工具

```bash
# vibe-config doctor
# 檢查配置健康狀態

vibe_config_doctor() {
    echo "🔍 VibeGhostty 配置診斷"
    echo ""

    # 檢查配置文件存在性
    echo "配置文件:"
    [[ -f "$HOME/.vibe/config" ]] && \
        echo "  ✅ 全局: $HOME/.vibe/config" || \
        echo "  ⚠️  全局: 不存在（使用預設值）"

    [[ -f ".vibe/config" ]] && \
        echo "  ✅ 專案: .vibe/config" || \
        echo "  ℹ️  專案: 不存在"

    echo ""

    # 顯示當前有效配置
    echo "當前有效配置:"
    echo "  AI_PRIMARY     = $VIBE_AI_PRIMARY"
    echo "  AI_SECONDARY   = $VIBE_AI_SECONDARY"
    echo "  DEFAULT_LAYOUT = $VIBE_DEFAULT_LAYOUT"
    echo "  SESSION_NAMING = $VIBE_SESSION_NAMING"
    echo ""

    # 檢查工具可用性
    echo "工具檢查:"
    for tool in codex claude cursor aider; do
        if command -v "$tool" &>/dev/null; then
            echo "  ✅ $tool"
        else
            echo "  ❌ $tool (未安裝)"
        fi
    done
    echo ""

    # 驗證配置
    validate_config && echo "✅ 配置驗證通過" || echo "❌ 配置驗證失敗"
}
```

---

## 遷移路徑

### 從環境變數遷移到配置文件

**現狀**: 用戶在 `~/.zshrc` 中設定環境變數

```bash
# ~/.zshrc
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
```

**遷移步驟**:

1. **自動遷移工具**:

```bash
# vibe-migrate-config
#!/usr/bin/env bash

echo "🔄 遷移環境變數到配置文件"

# 從當前環境提取配置
mkdir -p "$HOME/.vibe"
cat > "$HOME/.vibe/config" <<EOF
# 從環境變數自動遷移
# 原始位置: ~/.zshrc

VIBE_AI_PRIMARY=${VIBE_AI_PRIMARY:-codex}
VIBE_AI_SECONDARY=${VIBE_AI_SECONDARY:-claude}
VIBE_AI_FOCUS=${VIBE_AI_FOCUS:-codex}
# 其他配置使用預設值
EOF

echo "✅ 配置已遷移到 ~/.vibe/config"
echo ""
echo "可選: 從 ~/.zshrc 中移除以下行:"
echo "  export VIBE_AI_PRIMARY=..."
echo "  export VIBE_AI_SECONDARY=..."
```

2. **保持向後兼容**: 環境變數仍然有效（優先級更高）

### 階段性推出

**Phase 1: 向後兼容（v1.0）**
- ✅ 支援配置文件
- ✅ 支援環境變數（現有行為）
- ✅ 環境變數優先級高於配置文件
- 📖 文檔提及配置文件，但不強制

**Phase 2: 鼓勵遷移（v1.1）**
- ⚠️ 啟動時提示「偵測到環境變數，建議遷移到配置文件」
- 🛠️ 提供 `vibe-migrate-config` 工具
- 📖 文檔推薦配置文件

**Phase 3: 棄用警告（v2.0）**
- ⚠️ 環境變數顯示棄用警告
- ✅ 配置文件成為主要方式
- 📖 文檔標註環境變數為 legacy

**Phase 4: 僅配置文件（v3.0，可選）**
- ❌ 移除環境變數支援（僅保留 override 用途）
- ✅ 純配置文件驅動

---

## 附錄

### A. 完整配置模板

提供三種模板：

1. **minimal.config** - 最小配置
2. **recommended.config** - 推薦配置
3. **full.config** - 完整配置（含所有選項）

這些模板文件應放在 `tmux/config-templates/` 目錄。

### B. 配置遷移檢查清單

- [ ] 檢查現有環境變數（`env | grep VIBE_`）
- [ ] 執行 `vibe-migrate-config`
- [ ] 驗證新配置（`vibe-config doctor`）
- [ ] 測試各種場景
- [ ] 從 shell 配置移除環境變數
- [ ] 重新載入 shell（`source ~/.zshrc`）
- [ ] 確認仍正常運作

### C. 配置優先級矩陣

| 場景 | 全局 | 專案 | 環境變數 | 命令列 | 最終值 |
|------|------|------|----------|--------|--------|
| 無任何配置 | - | - | - | - | 內建預設 |
| 僅全局 | ✓ | - | - | - | 全局 |
| 全局+專案 | ✓ | ✓ | - | - | 專案 |
| 全局+環境變數 | ✓ | - | ✓ | - | 環境變數 |
| 專案+環境變數 | - | ✓ | ✓ | - | 環境變數 |
| 全局+專案+環境變數 | ✓ | ✓ | ✓ | - | 環境變數 |
| 所有+命令列 | ✓ | ✓ | ✓ | ✓ | 命令列 |

---

## 總結

### 設計亮點

1. **零配置可用**: 無配置文件時使用合理預設
2. **漸進式配置**: 從最小配置到完整配置
3. **扁平結構**: 無嵌套，易讀易寫
4. **Shell 原生**: 無需解析器，直接 source
5. **多層覆蓋**: 5 層優先級系統
6. **向後兼容**: 環境變數仍然有效
7. **工具友好**: 提供 init, doctor, migrate 工具

### 實作複雜度

- **Low**: Shell source 機制，無需複雜解析
- **配置載入**: ~50 行代碼
- **驗證邏輯**: ~100 行代碼
- **助手工具**: ~200 行代碼（可選）

### 維護性

- **文檔成本**: 低（單一文件格式）
- **測試成本**: 低（Bash 測試）
- **演進空間**: 預留擴展點（自訂布局目錄等）

---

**下一步**:

1. 審查此設計文檔
2. 確認配置項是否合理
3. 實作 MVP（核心配置載入）
4. 實作配置工具（init, doctor）
5. 撰寫用戶文檔
6. 測試遷移路徑

---

**版本歷史**:

- **1.0.0** (2025-10-19): 初始設計文檔
