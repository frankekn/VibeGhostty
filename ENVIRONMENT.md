# 環境變數文檔

本文檔列出了 VibeGhostty Tmux 配置系統支援的所有環境變數。

## 概述

VibeGhostty 支援透過環境變數自訂 AI 工具選擇，讓你可以根據個人偏好或專案需求靈活配置工作環境。

## 環境變數列表

### AI Workspace 布局 (`ai-workspace.sh`)

主要開發模式，70/30 分割視窗配置。

| 變數名稱 | 預設值 | 說明 |
|---------|-------|------|
| `VIBE_AI_PRIMARY` | `codex` | 主要 AI 工具（左側 70%） |
| `VIBE_AI_SECONDARY` | `claude` | 輔助 AI 工具（右上 30%） |

**範例使用**：
```bash
# 使用預設配置
./ai-workspace.sh

# 自訂 AI 工具
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
./ai-workspace.sh
```

**布局結構**：
```
┌─────────────────────────┬─────────────┐
│   PRIMARY (70%)         │  SECONDARY  │
│   預設: Codex CLI       │  (30%)      │
│                         │  預設: Claude│
│                         ├─────────────┤
│                         │  Monitor    │
└─────────────────────────┴─────────────┘
```

---

### AI Compare 布局 (`ai-compare.sh`)

並排比較模式，50/50 分割視窗配置。

| 變數名稱 | 預設值 | 說明 |
|---------|-------|------|
| `VIBE_AI_LEFT` | `codex` | 左側 AI 工具（50%） |
| `VIBE_AI_RIGHT` | `claude` | 右側 AI 工具（50%） |

**範例使用**：
```bash
# 比較 Claude 和 Codex 的建議
export VIBE_AI_LEFT=claude
export VIBE_AI_RIGHT=codex
./ai-compare.sh

# 或使用預設配置
./ai-compare.sh
```

**布局結構**：
```
┌────────────────┬────────────────┐
│  LEFT (50%)    │  RIGHT (50%)   │
│  預設: Codex   │  預設: Claude  │
├────────────────┴────────────────┤
│  Compare/Monitor (25%)          │
└─────────────────────────────────┘
```

---

### Full Focus 布局 (`full-focus.sh`)

專注模式，全屏單一 AI 工具配置。

| 變數名稱 | 預設值 | 說明 |
|---------|-------|------|
| `VIBE_AI_FOCUS` | `codex` | 專注模式使用的 AI 工具 |

**範例使用**：
```bash
# 使用 Claude 進行專注工作
export VIBE_AI_FOCUS=claude
./full-focus.sh

# 或透過參數指定（參數優先於環境變數）
./full-focus.sh ~/my-project claude

# 使用預設配置
./full-focus.sh
```

**布局結構**：
```
┌─────────────────────────────────┐
│  FOCUS (100%)                   │
│  預設: Codex CLI                │
│                                 │
│  專注模式 - 全屏工作            │
└─────────────────────────────────┘
```

---

## 設定方法

### 1. 臨時設定（單次使用）

在執行布局腳本前設定環境變數：

```bash
export VIBE_AI_PRIMARY=claude
./ai-workspace.sh
```

### 2. Shell 配置檔（永久設定）

將環境變數加入你的 shell 配置檔：

**Zsh (`~/.zshrc`)**:
```bash
# VibeGhostty AI 工具配置
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
export VIBE_AI_LEFT=claude
export VIBE_AI_RIGHT=codex
export VIBE_AI_FOCUS=claude
```

**Bash (`~/.bashrc` 或 `~/.bash_profile`)**:
```bash
# VibeGhostty AI 工具配置
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
export VIBE_AI_LEFT=claude
export VIBE_AI_RIGHT=codex
export VIBE_AI_FOCUS=claude
```

重新載入配置：
```bash
# Zsh
source ~/.zshrc

# Bash
source ~/.bashrc
```

### 3. 專案特定設定

在專案根目錄創建 `.envrc` 檔案（配合 direnv 使用）：

```bash
# .envrc
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
```

安裝並配置 direnv：
```bash
# 安裝 direnv
brew install direnv

# 加入 shell hook
echo 'eval "$(direnv hook zsh)"' >> ~/.zshrc

# 允許專案目錄
direnv allow .
```

---

## 支援的 AI 工具

目前支援的 AI CLI 工具值：

| 工具名稱 | 環境變數值 | 安裝方法 |
|---------|-----------|---------|
| Codex CLI | `codex` | `npm install -g @codexhq/cli` |
| Claude Code | `claude` | 從 https://claude.com/code 下載 |

---

## 工具檢查與錯誤處理

### 自動檢查

所有布局腳本會在啟動時自動檢查指定的 AI 工具是否已安裝。

### 錯誤處理行為

#### ai-workspace.sh
- ✅ **兩個工具都存在**：正常啟動
- ⚠️ **單一工具缺失**：詢問是否繼續（功能受限）
- ❌ **兩個工具都缺失**：中止執行，顯示安裝指引

#### ai-compare.sh
- ✅ **兩個工具都存在**：正常啟動
- ⚠️ **單一工具缺失**：警告但可繼續（比較功能受限）
- ❌ **兩個工具都缺失**：中止執行，顯示安裝指引

#### full-focus.sh
- ✅ **工具存在**：正常啟動
- ❌ **工具缺失**：詢問是否建立空 shell session

### 錯誤訊息範例

```bash
⚠️  警告：'claude' 未安裝
   安裝方法：
     從 https://claude.com/code 下載

❌ 錯誤：沒有可用的 AI 工具
   請至少安裝 codex 或 claude
```

---

## 使用場景範例

### 場景 1：使用 Claude 作為主力工具

```bash
# ~/.zshrc
export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
export VIBE_AI_FOCUS=claude

# 使用
ta  # 自動使用 Claude 作為主工具
```

### 場景 2：專案特定配置

```bash
# Frontend 專案：使用 Claude
cd ~/projects/frontend-app
export VIBE_AI_PRIMARY=claude
./ai-workspace.sh

# Backend 專案：使用 Codex
cd ~/projects/backend-api
export VIBE_AI_PRIMARY=codex
./ai-workspace.sh
```

### 場景 3：A/B 測試不同 AI 建議

```bash
# 比較 Claude 和 Codex 對同一問題的回答
export VIBE_AI_LEFT=claude
export VIBE_AI_RIGHT=codex
./ai-compare.sh
```

### 場景 4：深度專注模式

```bash
# 使用 Claude 進行複雜問題解決
export VIBE_AI_FOCUS=claude
./full-focus.sh ~/complex-project

# 或直接透過參數
./full-focus.sh ~/complex-project claude
```

---

## 最佳實踐

### 1. 保持一致性

在同一專案中使用相同的 AI 工具配置，確保團隊協作時的一致性。

### 2. 使用 direnv

利用 direnv 實現專案層級的自動配置切換：

```bash
# ~/projects/project-a/.envrc
export VIBE_AI_PRIMARY=claude

# ~/projects/project-b/.envrc
export VIBE_AI_PRIMARY=codex
```

### 3. 文檔化你的選擇

在專案 README 中記錄推薦的 AI 工具配置：

```markdown
## 開發環境設定

推薦使用以下 VibeGhostty 配置：

export VIBE_AI_PRIMARY=claude
export VIBE_AI_SECONDARY=codex
```

### 4. 定期檢查工具版本

確保使用的 AI 工具是最新版本：

```bash
# Codex CLI
npm update -g @codexhq/cli

# Claude Code
# 檢查 https://claude.com/code 獲取更新
```

---

## 疑難排解

### 問題 1：環境變數未生效

**原因**：未重新載入 shell 配置

**解決**：
```bash
source ~/.zshrc  # 或 ~/.bashrc
```

### 問題 2：工具仍顯示為未安裝

**原因**：工具不在 PATH 中

**檢查**：
```bash
which codex
which claude
echo $PATH
```

**解決**：
```bash
# 確保工具安裝路徑在 PATH 中
export PATH="/path/to/tools:$PATH"
```

### 問題 3：參數與環境變數衝突

**行為**：full-focus.sh 中參數優先於環境變數

**範例**：
```bash
export VIBE_AI_FOCUS=claude
./full-focus.sh ~/project codex  # 實際使用 codex（參數優先）
```

---

## 進階配置

### 自訂別名

在 shell 配置檔中創建便捷別名：

```bash
# ~/.zshrc
alias vibe-claude='export VIBE_AI_PRIMARY=claude && export VIBE_AI_SECONDARY=codex && ./ai-workspace.sh'
alias vibe-codex='export VIBE_AI_PRIMARY=codex && export VIBE_AI_SECONDARY=claude && ./ai-workspace.sh'
alias vibe-compare='./ai-compare.sh'
alias vibe-focus-claude='./full-focus.sh . claude'
alias vibe-focus-codex='./full-focus.sh . codex'
```

使用：
```bash
vibe-claude    # 快速啟動 Claude 主導的工作空間
vibe-compare   # 快速啟動比較模式
```

### 函數包裝

創建智能函數自動偵測專案類型：

```bash
# ~/.zshrc
vibe-auto() {
    if [[ -f "package.json" ]]; then
        export VIBE_AI_PRIMARY=codex  # Node.js 專案使用 Codex
    elif [[ -f "requirements.txt" ]]; then
        export VIBE_AI_PRIMARY=claude  # Python 專案使用 Claude
    fi
    ~/.tmux-layouts/ai-workspace.sh
}
```

---

## 相關文檔

- 📖 [TMUX_GUIDE.md](./TMUX_GUIDE.md) - 完整 Tmux 使用指南
- 🚀 [QUICKSTART_TMUX.md](./QUICKSTART_TMUX.md) - 5 分鐘快速開始
- 📚 [README.md](./README.md) - 專案概覽
- 🔧 [CLAUDE.md](./CLAUDE.md) - Claude Code 專案指引

---

**最後更新**: 2025-10-19
**版本**: 1.1.0
