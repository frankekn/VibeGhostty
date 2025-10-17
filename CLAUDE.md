# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 專案概述

**VibeGhostty** 是為 Claude Code、Codex CLI 等多 AI 工具協作優化的 Ghostty 終端機配置專案，包含完整的 Tmux 工作空間整合。

**主要語言**: Shell Script (Bash), Ghostty Config, Tmux Config
**專案類型**: 終端機配置與工作流程優化工具
**目標用戶**: AI 工具重度使用者、多專案平行開發者

---

## 核心架構

### 配置層次結構

```
1. Ghostty Layer（終端機基礎）
   ├── Tokyo Night Storm 主題
   ├── JetBrains Mono Nerd Font
   ├── 快捷鍵系統 (Cmd+1~9 tab 跳轉)
   └── AI 協作功能 (copy-on-select, shell-integration)

2. Tmux Layer（工作空間管理）
   ├── 配置文件 (tmux.conf) - Tokyo Night Storm 主題
   ├── 布局系統 (layouts/*.sh)
   │   ├── ai-workspace.sh - 70/30 主工作布局
   │   ├── ai-compare.sh - 50/50 並排比較
   │   └── full-focus.sh - 全屏專注模式
   └── 工具集 (bin/)
       ├── tmux-launch - 互動式布局選擇器
       ├── vibe-help - 快捷鍵速查表
       └── ta - 智能 session 管理（project-aware attach）
```

### 工作流程設計哲學

**分層責任**:
- **Ghostty**: 提供視覺一致性、字體渲染、基礎 tab/split 管理
- **Tmux**: 提供持久化 session、複雜布局管理、多 pane 協作

**典型使用場景**:
1. **簡單任務**: 僅使用 Ghostty tabs/splits（輕量、快速）
2. **複雜協作**: Tmux sessions + Ghostty（強大、持久化）
3. **混合模式**: Ghostty tab = 不同專案，Tmux session = 專案內工作空間

---

## 常用命令

### Ghostty 操作

```bash
# 安裝配置
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 重新載入配置（或按 Cmd+Shift+Comma）
pkill -9 ghostty && open -a Ghostty

# 驗證配置
ls -lh ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 備份現有配置
cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   ~/ghostty-config.backup
```

### Tmux 操作

```bash
# 安裝 Tmux 配置和工具
cd tmux && bash install.sh

# 快速 attach 到專案 session（最常用）
ta                          # 自動偵測當前專案
ta -l                       # 列出所有 sessions
ta -n my-project           # 指定 session 名稱

# 查看快捷鍵速查表
vibe-help                   # 或在 Tmux 中按 Ctrl+Space ?

# 啟動互動式布局選單
tmux-launch

# 直接啟動特定布局
~/.tmux-layouts/ai-workspace.sh    # AI 工作空間（70/30）
~/.tmux-layouts/ai-compare.sh      # AI 比較模式（50/50）
~/.tmux-layouts/full-focus.sh      # 全屏專注模式

# 重新載入 Tmux 配置
tmux source-file ~/.tmux.conf      # 或在 Tmux 中按 Ctrl+Space r

# Session 管理
tmux ls                     # 列出所有 sessions
tmux attach -t SESSION     # 重新連接 session
tmux kill-session -t NAME  # 刪除 session
```

### 測試和驗證

```bash
# 測試布局腳本語法
bash -n ~/.tmux-layouts/ai-workspace.sh
bash -n ~/.tmux-layouts/ai-compare.sh
bash -n ~/.tmux-layouts/full-focus.sh

# 測試 bin 工具語法
bash -n ~/.local/bin/tmux-launch
bash -n ~/.local/bin/vibe-help
bash -n ~/.local/bin/ta

# 驗證 TPM 插件安裝
ls -la ~/.tmux/plugins/tpm

# 檢查 PATH 設定
echo $PATH | grep -q "$HOME/.local/bin" && echo "✅ PATH OK" || echo "❌ 需要加入 PATH"
```

---

## 關鍵設計決策

### 1. Ghostty 快捷鍵系統

**核心概念**: macOS 原生快捷鍵風格（Cmd 為主）

```
Cmd+1~9        → 直接跳轉 tab（最高優先級，頻繁使用）
Cmd+D          → 向右分割（符合 iTerm2/VSCode 習慣）
Cmd+Shift+D    → 向下分割
Cmd+Shift+,    → 重新載入配置（與 macOS 偏好設定一致）
```

**為什麼這樣設計**:
- 減少認知負擔（與其他 macOS 應用一致）
- 單手操作友好（Cmd 比 Ctrl 更易按）
- 與 Tmux 快捷鍵不衝突（Tmux 使用 Ctrl+Space prefix）

### 2. Tmux Prefix 選擇

**使用 `Ctrl+Space` 而非預設 `Ctrl+B`**:

原因:
- 更符合人體工學（Space 鍵大，易觸及）
- 避免與 Vim/Emacs 導航衝突
- 與 Ghostty Cmd 快捷鍵明確區隔

### 3. Tmux 布局設計

**三種布局對應三種工作模式**:

```bash
# ai-workspace.sh - 主要開發模式
┌─────────────────────────┬─────────────┐
│   Codex CLI (70%)       │  Claude     │
│   主要工作區            │  Code (30%) │
│                         ├─────────────┤
│                         │  Monitor    │
└─────────────────────────┴─────────────┘

# ai-compare.sh - 並排比較模式
┌────────────────┬────────────────┐
│  Codex CLI     │  Claude Code   │
│  (50%)         │  (50%)         │
├────────────────┴────────────────┤
│  Compare/Monitor (25%)          │
└─────────────────────────────────┘

# full-focus.sh - 專注模式
┌─────────────────────────────────┐
│  Single AI Tool (100%)          │
└─────────────────────────────────┘
```

**設計考量**:
- 70/30 分割: 黃金比例，主工作區足夠寬，輔助區域不干擾
- 50/50 分割: 公平比較，適合評估兩個 AI 的不同建議
- 100% 全屏: 減少視覺干擾，深度思考時使用

### 4. Pane 標題系統

**自動設定有意義的 emoji 標題**:

```bash
🚀 Terminal    # 預設新 window
📟 Pane        # 預設新 split
🤖 Codex CLI   # AI 工具
🧠 Claude Code # AI 工具
📊 Monitor     # 監控/測試
```

**實作**: 透過 `select-pane -T` 設定，在布局腳本中定義

### 5. 主題一致性

**Tokyo Night Storm 跨層應用**:

- Ghostty config: 完整 ANSI palette 定義
- Tmux config: 匹配的 status bar 和 pane border 顏色
- 色彩變數化: tmux.conf 定義 `$bg`, `$fg`, `$blue` 等變數

**關鍵色彩**:
```
背景: #24283b (深藍灰)
前景: #c0caf5 (柔和白)
強調: #ff9e64 (橙色 - cursor)
活動: #7aa2f7 (藍色 - active border/tab)
```

---

## 文件組織邏輯

### 文檔層次

```
README.md              → 入口文檔（3.9K）- 快速概覽 + Tmux 整合介紹
QUICKSTART.md          → 5 分鐘快速開始 (1.0K) - Ghostty only
QUICKSTART_TMUX.md     → 5 分鐘 Tmux 快速開始
INSTALL.md             → 完整安裝指南 (4.2K) - Ghostty 安裝細節
GUIDE.md               → 詳細使用指南 (9.1K) - Ghostty 進階技巧
TMUX_GUIDE.md          → Tmux 完整使用指南
CHANGELOG.md           → 版本歷史和已知問題
PROJECT_SUMMARY.md     → 專案後設資訊
USABILITY_IMPROVEMENTS.md → 用戶體驗改進建議
```

**文檔設計原則**:
1. **漸進式深度**: QUICKSTART → INSTALL → GUIDE
2. **工具分離**: Ghostty 文檔與 Tmux 文檔獨立
3. **實例驅動**: 每個概念都有具體使用範例
4. **中文優先**: 目標用戶為繁體中文使用者

### 配置文件結構

```
config                 → Ghostty 主配置（直接複製使用）
tmux/
├── tmux.conf         → Tmux 主配置（通過 install.sh 部署）
├── install.sh        → 一鍵安裝腳本（處理依賴、備份、PATH）
├── layouts/          → 布局腳本（可執行 .sh 文件）
└── bin/              → 工具集（安裝到 ~/.local/bin）
```

---

## 修改配置指南

### 修改 Ghostty 快捷鍵

**位置**: `config` 文件第 67-94 行

```bash
# 範例: 改變分割方向快捷鍵
keybind = super+d=new_split:right      # 原本向右
keybind = super+d=new_split:down       # 改為向下
```

**注意事項**:
- `super` = macOS 的 Cmd 鍵
- 修改後必須執行 `Cmd+Shift+Comma` 或重啟 Ghostty
- 檢查是否與系統快捷鍵衝突（系統偏好設定 → 鍵盤 → 快速鍵）

### 修改 Tmux 快捷鍵

**位置**: `tmux/tmux.conf` 第 119-200 行

```bash
# 範例: 改變 prefix key
unbind C-b
set -g prefix C-a           # 改為 Ctrl+A
bind C-a send-prefix

# 範例: 改變分割鍵
bind | split-window -h      # 原本 |
bind '\' split-window -h    # 改為 \
```

**重新載入**: `tmux source-file ~/.tmux.conf` 或 `Ctrl+Space r`

### 調整 Tmux 布局比例

**位置**: `tmux/layouts/ai-workspace.sh`

```bash
# 原本 70/30 分割
tmux split-window -h -p 30 -t $SESSION:1

# 改為 60/40 分割
tmux split-window -h -p 40 -t $SESSION:1
```

**`-p` 參數**: 表示百分比（右側或下方 pane 的大小）

### 自訂主題色彩

**Ghostty**: 修改 `config` 第 16-45 行的 palette 定義

**Tmux**: 修改 `tmux/tmux.conf` 第 41-73 行的色彩變數

**保持一致性**: 兩處都要修改，確保視覺統一

---

## 依賴關係

### Ghostty 配置依賴

```
必需:
- Ghostty 1.0+ (終端機應用)
- JetBrains Mono Nerd Font (字體)

可選:
- Homebrew (用於安裝 Ghostty 和字體)
```

### Tmux 配置依賴

```
必需:
- Tmux 3.0+ (終端機多路復用器)
- Git (用於安裝 TPM)
- Bash 4.0+ (執行安裝和布局腳本)

可選:
- Codex CLI (AI 工具)
- Claude Code (AI 工具)
- TPM 插件:
  - tmux-sensible (基礎配置)
  - tmux-resurrect (session 復原)
  - tmux-continuum (自動保存)
  - tmux-logging (日誌記錄)
```

### 安裝依賴命令

```bash
# Ghostty 依賴
brew install --cask ghostty
brew install --cask font-jetbrains-mono-nerd-font

# Tmux 依賴
brew install tmux
brew install git

# AI 工具（可選）
npm install -g @codexhq/cli
# Claude Code 從 https://claude.com/code 下載
```

---

## 專案約定

### Shell Script 規範

1. **Shebang**: 使用 `#!/usr/bin/env bash`（可移植性）
2. **錯誤處理**: 腳本開頭使用 `set -e`（遇錯即停）
3. **色彩輸出**: 統一使用定義的色彩變數（`$BLUE`, `$GREEN` 等）
4. **函數命名**:
   - `print_header()` - 顯示標題
   - `print_step()` - 顯示步驟
   - `print_success()` / `print_error()` - 顯示結果

### 配置文件規範

1. **註解區塊**: 使用 `═` 和 `─` 創建視覺分隔
2. **邏輯分組**: 相關設定集中在同一區塊
3. **內嵌文檔**: 重要配置包含使用說明註解
4. **一致性**: Ghostty 和 Tmux 配置使用相同的註解風格

### 文檔規範

1. **Emoji 使用**:
   - 🚀 啟動/開始
   - ✅ 成功/檢查清單
   - ⚠️ 警告
   - 🔧 配置/工具
   - 📚 資源/文檔

2. **程式碼區塊**: 始終標註語言 (\`\`\`bash)
3. **表格格式**: 使用 Markdown 表格表示快捷鍵和選項
4. **區塊分隔**: 使用 `---` 分隔主要章節

---

## 常見陷阱與解決方案

### Ghostty 配置不生效

**問題**: 修改 config 後沒有變化

**解決**:
1. 檢查配置文件位置是否正確（`~/Library/Application Support/com.mitchellh.ghostty/config`）
2. 確認語法正確（沒有拼寫錯誤）
3. 使用 `Cmd+Shift+Comma` 重新載入
4. 若仍無效，完全重啟 Ghostty: `pkill -9 ghostty && open -a Ghostty`

### Tmux 快捷鍵不工作

**問題**: 按 `Ctrl+Space` 沒有反應

**原因**: macOS Spotlight 可能佔用 `Ctrl+Space`

**解決**:
1. 系統偏好設定 → 鍵盤 → 快速鍵 → Spotlight
2. 取消勾選「顯示 Spotlight 搜尋」或改為其他快捷鍵
3. 重新載入 Tmux 配置

### PATH 設定問題

**問題**: `tmux-launch`, `vibe-help`, `ta` 找不到命令

**原因**: `~/.local/bin` 不在 PATH 中

**解決**:
```bash
# 加入到 ~/.zshrc 或 ~/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 驗證
which tmux-launch    # 應該顯示 /Users/xxx/.local/bin/tmux-launch
```

### TPM 插件安裝失敗

**問題**: Tmux 啟動時顯示 TPM 錯誤

**解決**:
```bash
# 手動安裝 TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 在 Tmux 中按 Ctrl+Space I（大寫 I）安裝插件
# 或手動執行
~/.tmux/plugins/tpm/bin/install_plugins
```

### 字體顯示問題

**問題**: Ghostty 中圖標顯示為方塊或亂碼

**解決**:
```bash
# 重新安裝 Nerd Font
brew reinstall --cask font-jetbrains-mono-nerd-font

# 驗證安裝
ls ~/Library/Fonts/ | grep -i jetbrains

# 完全重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

---

## 效能考量

### Scrollback 限制

**預設**: 50,000 行

**調整建議**:
- **<8GB RAM**: 10,000-20,000 行
- **8-16GB RAM**: 50,000 行（預設）
- **16GB+ RAM**: 100,000-200,000 行

**位置**:
- Ghostty: `config` 第 57 行 `scrollback-limit`
- Tmux: `tmux/tmux.conf` 第 21 行 `history-limit`

### Tab/Split 管理

**最佳實踐**:
- **3-5 個 tab**: 正常使用 ✅
- **6-10 個 tab**: 注意記憶體 ⚠️
- **>10 個 tab**: 建議清理 🔴

**原因**: 每個 tab 維護獨立的 scrollback buffer

### Tmux Session 數量

**建議**:
- 1 session per project（專案隔離）
- 定期清理不活躍的 session: `tmux kill-session -t NAME`
- 使用 `ta -l` 檢視所有 session

---

## AI 協作工作流程

### 典型使用場景

**場景 1: Claude Code + Codex CLI 並行**
```bash
# Ghostty Tab 模式（簡單）
Tab 1: claude
Tab 2: codex
Tab 3: npm test -- --watch
切換: Cmd+1/2/3

# Tmux 模式（複雜專案）
tmux-launch → 選擇 AI Workspace
Pane 1: codex（主工作區 70%）
Pane 2: claude（輔助區 30%）
Pane 3: 監控/測試
```

**場景 2: 比較 AI 建議**
```bash
# Ghostty Split 模式
claude
Cmd+D → 右側執行 codex
並排比較輸出

# Tmux 模式
tmux-launch → 選擇 AI Compare
左側 50%: Codex 建議
右側 50%: Claude 建議
底部 25%: 實際測試結果
```

**場景 3: 深度專注**
```bash
# Tmux Full Focus 模式
~/.tmux-layouts/full-focus.sh
100% 全屏 Claude Code
Ctrl+Space z 切換 zoom
最小化視覺干擾
```

### Session 命名規範

**推薦格式**: `project-name` 或 `client-project`

```bash
# 好的命名
ta -n vibeghostty
ta -n client-website
ta -n backend-api

# 避免的命名
ta -n test           # 太泛
ta -n session1       # 無意義
ta -n asdf           # 難以辨識
```

**原因**: `ta` 工具會根據當前目錄名稱自動偵測，清晰的命名更易管理

---

## 貢獻指南

### 新增布局腳本

1. 在 `tmux/layouts/` 創建新的 `.sh` 文件
2. 遵循現有腳本的結構:
   ```bash
   #!/usr/bin/env bash
   SESSION="layout-name"

   # 檢查 session 是否存在
   tmux has-session -t $SESSION 2>/dev/null

   if [ $? != 0 ]; then
       # 創建布局...
   fi

   tmux attach -t $SESSION
   ```
3. 設定執行權限: `chmod +x tmux/layouts/new-layout.sh`
4. 測試語法: `bash -n tmux/layouts/new-layout.sh`
5. 更新 `tmux-launch` 選單

### 新增 bin 工具

1. 在 `tmux/bin/` 創建新工具
2. 使用 `#!/usr/bin/env bash` shebang
3. 包含使用說明（`--help` 選項）
4. 在 `install.sh` 中加入複製邏輯:
   ```bash
   cp "$SCRIPT_DIR/bin/new-tool" "$HOME/.local/bin/new-tool"
   chmod +x "$HOME/.local/bin/new-tool"
   ```

### 更新文檔

**修改任何功能時，同步更新**:
- README.md（如果影響快速開始）
- GUIDE.md 或 TMUX_GUIDE.md（詳細使用說明）
- CHANGELOG.md（記錄變更）

---

## 版本控制注意事項

### Git 工作流程

```bash
# 修改前先確認狀態
git status
git branch

# 建議使用 feature branch
git checkout -b feature/new-layout

# 提交訊息規範
git commit -m "feat: add new AI layout for 3-pane setup"
git commit -m "fix: correct PATH detection in install.sh"
git commit -m "docs: update TMUX_GUIDE with new shortcuts"
```

### 需要測試的檔案

**修改這些檔案時必須測試**:
- `config` → 重新載入 Ghostty，驗證無錯誤
- `tmux/tmux.conf` → `tmux source-file ~/.tmux.conf`
- `tmux/layouts/*.sh` → 執行腳本，確認布局正確
- `tmux/install.sh` → 在乾淨環境測試完整安裝流程

---

## 快速參考

### Ghostty 配置路徑
```
~/Library/Application Support/com.mitchellh.ghostty/config
```

### Tmux 配置路徑
```
~/.tmux.conf
~/.tmux-layouts/
~/.local/bin/
~/.tmux/plugins/
```

### 核心快捷鍵速查

**Ghostty**:
- `Cmd+1~9`: 跳轉 tab
- `Cmd+D`: 向右分割
- `Cmd+Shift+Comma`: 重新載入配置

**Tmux**:
- `Ctrl+Space`: Prefix
- `Ctrl+Space ?`: 幫助
- `Ctrl+Space |`: 向右分割
- `Ctrl+Space -`: 向下分割
- `Ctrl+Space 1~5`: 跳轉 pane

### 常用命令速查

```bash
# Ghostty
pkill -9 ghostty && open -a Ghostty

# Tmux
ta                              # 智能 attach
tmux-launch                     # 布局選單
vibe-help                       # 快捷鍵速查
tmux source-file ~/.tmux.conf   # 重新載入配置

# 測試
bash -n <script>               # 語法檢查
```

---

**專案維護者**: Frank Yang
**最後更新**: 2025-10-17
**配置版本**: 1.0.0
