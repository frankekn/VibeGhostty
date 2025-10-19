# 自訂配置指南

**版本**: 1.1.0
**最後更新**: 2025-10-19
**預估閱讀時間**: 15 分鐘
**前置閱讀**: [Ghostty 使用指南](../../GUIDE.md)、[Tmux 使用指南](../../TMUX_GUIDE.md)

---

## 目錄

1. [Ghostty 自訂](#ghostty-自訂)
   - [主題與色彩](#1-主題與色彩)
   - [字體配置](#2-字體配置)
   - [快捷鍵自訂](#3-快捷鍵自訂)
   - [Scrollback Buffer](#4-scrollback-buffer)
   - [視窗邊距](#5-視窗邊距)
2. [Tmux 自訂](#tmux-自訂)
   - [修改 Prefix 鍵](#1-修改-prefix-鍵)
   - [主題色彩](#2-主題色彩)
   - [自訂布局](#3-自訂布局)
   - [快捷鍵修改](#4-快捷鍵修改)
3. [整合自訂](#整合自訂)
4. [備份與恢復](#備份與恢復)

---

## Ghostty 自訂

### 配置文件位置

```bash
~/Library/Application Support/com.mitchellh.ghostty/config
```

**重新載入配置**: `Cmd+Shift+Comma` 或重啟 Ghostty

---

### 1. 主題與色彩

#### 當前主題：Tokyo Night Storm

**完整色彩規範**:

```toml
# 基礎色彩
background = 24283b
foreground = c0caf5

# Cursor
cursor-color = ff9e64
cursor-text = 1a1b26

# Selection
selection-background = 364a82
selection-foreground = c0caf5

# ANSI 標準色 (0-7)
palette = 0=#1d202f    # Black
palette = 1=#f7768e    # Red
palette = 2=#9ece6a    # Green
palette = 3=#e0af68    # Yellow
palette = 4=#7aa2f7    # Blue
palette = 5=#bb9af7    # Magenta
palette = 6=#7dcfff    # Cyan
palette = 7=#a9b1d6    # White

# ANSI 亮色 (8-15)
palette = 8=#414868    # Bright Black
palette = 9=#f7768e    # Bright Red
palette = 10=#9ece6a   # Bright Green
palette = 11=#e0af68   # Bright Yellow
palette = 12=#7aa2f7   # Bright Blue
palette = 13=#bb9af7   # Bright Magenta
palette = 14=#7dcfff   # Bright Cyan
palette = 15=#c0caf5   # Bright White
```

---

#### 改為 Gruvbox Dark 主題

**步驟**:

1. 開啟配置文件

```bash
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

2. 替換色彩定義

```toml
# Gruvbox Dark 主題

# 基礎色彩
background = 282828
foreground = ebdbb2

# Cursor
cursor-color = fe8019
cursor-text = 282828

# Selection
selection-background = 504945
selection-foreground = ebdbb2

# ANSI 標準色 (0-7)
palette = 0=#282828    # Black
palette = 1=#cc241d    # Red
palette = 2=#98971a    # Green
palette = 3=#d79921    # Yellow
palette = 4=#458588    # Blue
palette = 5=#b16286    # Magenta
palette = 6=#689d6a    # Cyan
palette = 7=#a89984    # White

# ANSI 亮色 (8-15)
palette = 8=#928374    # Bright Black
palette = 9=#fb4934    # Bright Red
palette = 10=#b8bb26   # Bright Green
palette = 11=#fabd2f   # Bright Yellow
palette = 12=#83a598   # Bright Blue
palette = 13=#d3869b   # Bright Magenta
palette = 14=#8ec07c   # Bright Cyan
palette = 15=#ebdbb2   # Bright White
```

3. 重新載入配置

```bash
# 方法 1: 快捷鍵
Cmd+Shift+Comma

# 方法 2: 重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

---

#### 其他流行主題

**Dracula**:

```toml
background = 282a36
foreground = f8f8f2
cursor-color = bd93f9

palette = 0=#21222c
palette = 1=#ff5555
palette = 2=#50fa7b
palette = 3=#f1fa8c
palette = 4=#bd93f9
palette = 5=#ff79c6
palette = 6=#8be9fd
palette = 7=#f8f8f2
palette = 8=#6272a4
palette = 9=#ff6e6e
palette = 10=#69ff94
palette = 11=#ffffa5
palette = 12=#d6acff
palette = 13=#ff92df
palette = 14=#a4ffff
palette = 15=#ffffff
```

**Nord**:

```toml
background = 2e3440
foreground = d8dee9
cursor-color = 88c0d0

palette = 0=#3b4252
palette = 1=#bf616a
palette = 2=#a3be8c
palette = 3=#ebcb8b
palette = 4=#81a1c1
palette = 5=#b48ead
palette = 6=#88c0d0
palette = 7=#e5e9f0
palette = 8=#4c566a
palette = 9=#bf616a
palette = 10=#a3be8c
palette = 11=#ebcb8b
palette = 12=#81a1c1
palette = 13=#b48ead
palette = 14=#8fbcbb
palette = 15=#eceff4
```

**Catppuccin Mocha**:

```toml
background = 1e1e2e
foreground = cdd6f4
cursor-color = f5e0dc

palette = 0=#45475a
palette = 1=#f38ba8
palette = 2=#a6e3a1
palette = 3=#f9e2af
palette = 4=#89b4fa
palette = 5=#f5c2e7
palette = 6=#94e2d5
palette = 7=#bac2de
palette = 8=#585b70
palette = 9=#f38ba8
palette = 10=#a6e3a1
palette = 11=#f9e2af
palette = 12=#89b4fa
palette = 13=#f5c2e7
palette = 14=#94e2d5
palette = 15=#a6adc8
```

---

### 2. 字體配置

#### 修改字體系列

**當前字體**: JetBrains Mono Nerd Font

**步驟 1: 安裝其他 Nerd Font**

```bash
# Fira Code（支援連字）
brew install --cask font-fira-code-nerd-font

# Hack（簡潔風格）
brew install --cask font-hack-nerd-font

# Source Code Pro（Adobe 出品）
brew install --cask font-source-code-pro

# Cascadia Code（Microsoft 出品）
brew install --cask font-cascadia-code

# Meslo LG（傳統風格）
brew install --cask font-meslo-lg-nerd-font
```

**步驟 2: 修改配置**

```toml
# 編輯 config 文件

# Fira Code（連字支援）
font-family = Fira Code Nerd Font

# Hack（簡潔）
font-family = Hack Nerd Font

# Source Code Pro
font-family = Source Code Pro

# Cascadia Code
font-family = Cascadia Code

# Meslo LG
font-family = Meslo LG Nerd Font
```

**步驟 3: 重新載入**

```bash
Cmd+Shift+Comma
```

---

#### 調整字體大小

```toml
# 當前設定
font-size = 13

# 適合 4K 高解析度螢幕
font-size = 11

# 標準設定
font-size = 12

# 預設（推薦）
font-size = 13

# 較大（適合遠距離閱讀）
font-size = 14

# 演示模式
font-size = 16
```

**即時調整**（臨時性）:

```bash
Cmd+Plus        # 放大字體
Cmd+Minus       # 縮小字體
Cmd+0           # 重設為配置值
```

---

#### 調整行高

```toml
# 當前設定
adjust-cell-height = 15%

# 標準行高（緊湊）
adjust-cell-height = 0%

# 稍微緊湊
adjust-cell-height = 10%

# 預設（推薦）
adjust-cell-height = 15%

# 寬鬆
adjust-cell-height = 20%

# 極寬鬆（易讀但佔空間）
adjust-cell-height = 25%
```

**使用建議**:

- **程式碼閱讀**: 15-20%（當前預設）
- **密集資訊**: 10%
- **簡報展示**: 20-25%

---

### 3. 快捷鍵自訂

#### 修改分割方向快捷鍵

**當前設定**:
- `Cmd+D`: 向右分割
- `Cmd+Shift+D`: 向下分割

**改為類似 iTerm2 的習慣**:

```toml
# 編輯 config 文件

# 取消原有綁定
keybind = super+d=unbind
keybind = super+shift+d=unbind

# 新綁定（使用 \ 和 -）
keybind = super+backslash=new_split:right       # Cmd+\
keybind = super+minus=new_split:down            # Cmd+-
```

**重新載入**: `Cmd+Shift+Comma`

---

#### 新增自訂快捷鍵

**範例 1: Cmd+K 清空畫面**

```toml
keybind = super+k=clear_screen
```

**範例 2: Cmd+Shift+C 複製（如果 copy-on-select 關閉）**

```toml
keybind = super+shift+c=copy_to_clipboard
```

**範例 3: Cmd+Option+Left/Right 切換 tab**

```toml
keybind = super+alt+left=previous_tab
keybind = super+alt+right=next_tab
```

---

#### 快捷鍵語法說明

**修飾鍵**:

| 名稱 | macOS 對應 |
|------|-----------|
| `super` | Cmd |
| `shift` | Shift |
| `alt` | Option |
| `ctrl` | Control |

**組合方式**:

```toml
# 單一修飾鍵
keybind = super+t=new_tab

# 多個修飾鍵（用 + 連接）
keybind = super+shift+t=new_window

# 三個修飾鍵
keybind = super+shift+alt+c=copy_to_clipboard
```

**可用動作**（部分）:

- `new_tab`: 新建 tab
- `close_surface`: 關閉 tab/split
- `new_split:right`: 向右分割
- `new_split:down`: 向下分割
- `goto_tab:N`: 跳轉到第 N 個 tab（N=1~9）
- `clear_screen`: 清空畫面
- `reload_config`: 重新載入配置
- `copy_to_clipboard`: 複製
- `paste_from_clipboard`: 貼上

---

### 4. Scrollback Buffer

```toml
# 當前設定
scrollback-limit = 50000

# 根據 RAM 調整

# < 8GB RAM（省記憶體）
scrollback-limit = 10000

# 8GB RAM（輕度使用）
scrollback-limit = 20000

# 16GB RAM（標準，推薦）
scrollback-limit = 50000

# 32GB+ RAM（大容量）
scrollback-limit = 100000

# 極大（注意記憶體使用）
scrollback-limit = 200000
```

**效能影響**:

| Scrollback | 每 Tab 記憶體 | 適合場景 |
|-----------|-------------|---------|
| 10,000 | ~5 MB | 輕度使用、低配機器 |
| 50,000 | ~25 MB | 標準開發（推薦） |
| 100,000 | ~50 MB | 需要大量歷史記錄 |
| 200,000 | ~100 MB | AI 長對話、日誌分析 |

---

### 5. 視窗邊距

```toml
# 當前設定
window-padding-x = 8
window-padding-y = 8

# 無邊距（最大化空間）
window-padding-x = 0
window-padding-y = 0

# 緊湊
window-padding-x = 4
window-padding-y = 4

# 預設（推薦）
window-padding-x = 8
window-padding-y = 8

# 寬鬆（美觀優先）
window-padding-x = 16
window-padding-y = 16

# 極寬鬆（演示模式）
window-padding-x = 24
window-padding-y = 24
```

**視覺效果對比**:

```
無邊距 (0):
┌──────────────┐
│█████████████ │
│█████████████ │
└──────────────┘

預設 (8):
┌──────────────┐
│              │
│  █████████   │
│  █████████   │
│              │
└──────────────┘

寬鬆 (16):
┌──────────────┐
│              │
│              │
│   ███████    │
│   ███████    │
│              │
│              │
└──────────────┘
```

---

## Tmux 自訂

### 配置文件位置

```bash
~/.tmux.conf
```

**重新載入配置**:

```bash
# 方法 1: Tmux 內快捷鍵
Ctrl+Space r

# 方法 2: 命令列
tmux source-file ~/.tmux.conf
```

---

### 1. 修改 Prefix 鍵

**當前 Prefix**: `Ctrl+Space`

#### 改為 Ctrl+A（GNU Screen 風格）

**步驟 1: 編輯 `~/.tmux.conf`**

```bash
# 找到這幾行
unbind C-Space
set -g prefix C-Space
bind C-Space send-prefix

# 替換為
unbind C-b
set -g prefix C-a
bind C-a send-prefix
```

**步驟 2: 重新載入**

```bash
tmux source-file ~/.tmux.conf
```

**步驟 3: 測試新 Prefix**

```bash
# 現在使用 Ctrl+A 作為 prefix
Ctrl+A |        # 垂直分割
Ctrl+A -        # 水平分割
Ctrl+A ?        # 顯示幫助
```

---

#### 改為 Ctrl+B（Tmux 預設）

```bash
# 編輯 ~/.tmux.conf

unbind C-Space
set -g prefix C-b
bind C-b send-prefix
```

---

#### 使用雙 Prefix（進階）

```bash
# 同時支援 Ctrl+Space 和 Ctrl+A

# 主 Prefix
set -g prefix C-Space
bind C-Space send-prefix

# 副 Prefix
set -g prefix2 C-a
bind C-a send-prefix -2
```

**使用場景**: 習慣兩種快捷鍵風格時

---

### 2. 主題色彩

**當前主題**: Tokyo Night Storm（與 Ghostty 一致）

#### 修改 Status Bar 顏色

**步驟 1: 編輯 `~/.tmux.conf`**

找到色彩變數定義區塊（約第 41-73 行）:

```bash
# Tokyo Night Storm 色彩（當前）
bg="#24283b"
fg="#c0caf5"
blue="#7aa2f7"
cyan="#7dcfff"
black="#1d202f"
white="#c0caf5"
grey="#414868"
green="#9ece6a"
purple="#bb9af7"
orange="#ff9e64"
```

**步驟 2: 替換為其他主題**

**Gruvbox Dark**:

```bash
bg="#282828"
fg="#ebdbb2"
blue="#83a598"
cyan="#8ec07c"
black="#3c3836"
white="#fbf1c7"
grey="#928374"
green="#b8bb26"
purple="#d3869b"
orange="#fe8019"
```

**Nord**:

```bash
bg="#2e3440"
fg="#d8dee9"
blue="#81a1c1"
cyan="#88c0d0"
black="#3b4252"
white="#eceff4"
grey="#4c566a"
green="#a3be8c"
purple="#b48ead"
orange="#d08770"
```

**Dracula**:

```bash
bg="#282a36"
fg="#f8f8f2"
blue="#bd93f9"
cyan="#8be9fd"
black="#21222c"
white="#f8f8f2"
grey="#6272a4"
green="#50fa7b"
purple="#ff79c6"
orange="#ffb86c"
```

**步驟 3: 重新載入**

```bash
Ctrl+Space r
```

---

#### 自訂 Status Bar 內容

**當前 Status Bar**:

```
[Session Name] | Window 1 | Window 2 | ... | 2025-10-19 14:30
```

**完全自訂**:

```bash
# 編輯 ~/.tmux.conf

# 左側狀態列
set -g status-left "#[fg=$blue,bold] #S #[default]"

# 右側狀態列
set -g status-right "#[fg=$cyan]%Y-%m-%d %H:%M #[fg=$blue,bold]⚡#[default]"

# 視窗狀態格式
setw -g window-status-format "#[fg=$grey] #I:#W "
setw -g window-status-current-format "#[fg=$blue,bold] #I:#W* "
```

**可用變數**:

| 變數 | 含義 | 範例 |
|------|------|------|
| `#S` | Session 名稱 | `ai-vibeghostty` |
| `#I` | Window 編號 | `1` |
| `#W` | Window 名稱 | `Terminal` |
| `#P` | Pane 編號 | `0` |
| `#H` | 主機名稱 | `MacBook-Pro` |
| `%Y-%m-%d` | 日期 | `2025-10-19` |
| `%H:%M` | 時間 | `14:30` |

---

### 3. 自訂布局

#### 創建新布局：Dev + Logs (60/40)

**步驟 1: 創建布局腳本**

```bash
# 創建檔案
vim ~/.tmux-layouts/dev-logs.sh
```

**步驟 2: 編寫腳本**

```bash
#!/usr/bin/env bash
set -e

SESSION="dev-logs"
PROJECT_DIR="${1:-$PWD}"

# 檢查 session 是否已存在
if ! tmux has-session -t $SESSION 2>/dev/null; then
    # 創建 session 和主 window
    tmux new-session -d -s $SESSION -n "DevLogs" -c "$PROJECT_DIR"

    # 向右分割（40% 右側用於日誌）
    tmux split-window -h -p 40 -t $SESSION:1 -c "$PROJECT_DIR"

    # 設定窗格標題
    tmux select-pane -t $SESSION:1.0 -T "💻 Development"
    tmux select-pane -t $SESSION:1.1 -T "📋 Logs"

    # 在日誌窗格啟動日誌監控（可選）
    # tmux send-keys -t $SESSION:1.1 "tail -f app.log" C-m

    # 選擇主工作區
    tmux select-pane -t $SESSION:1.0
fi

# Attach 到 session
tmux attach -t $SESSION
```

**步驟 3: 設定執行權限**

```bash
chmod +x ~/.tmux-layouts/dev-logs.sh
```

**步驟 4: 測試布局**

```bash
~/.tmux-layouts/dev-logs.sh
```

**視覺效果**:

```
┌──────────────────┬──────────┐
│  💻 Development  │  📋 Logs │
│  (60%)           │  (40%)   │
│                  │          │
│  主要編碼區      │  日誌    │
│                  │  監控    │
└──────────────────┴──────────┘
```

---

#### 修改現有布局比例

**範例: 將 AI Workspace 從 70/30 改為 60/40**

**步驟 1: 編輯布局腳本**

```bash
vim ~/.tmux-layouts/ai-workspace.sh
```

**步驟 2: 找到分割比例設定**

```bash
# 原本（70/30）
tmux split-window -h -p 30 -t $SESSION:1

# 改為（60/40）
tmux split-window -h -p 40 -t $SESSION:1
```

**`-p` 參數說明**: 表示百分比，右側或下方窗格的大小

- `-p 30`: 右側佔 30%，左側佔 70%
- `-p 40`: 右側佔 40%，左側佔 60%
- `-p 50`: 對半分

**步驟 3: 測試新布局**

```bash
# 先刪除舊 session（如果存在）
tmux kill-session -t ai-work

# 重新啟動布局
~/.tmux-layouts/ai-workspace.sh
```

---

### 4. 快捷鍵修改

#### 改變分割鍵

**當前設定**:
- `Ctrl+Space |`: 垂直分割
- `Ctrl+Space -`: 水平分割

**改為使用 \ 和 _**:

```bash
# 編輯 ~/.tmux.conf

# 找到分割鍵設定（約第 150 行）
unbind |
unbind -

# 新綁定
bind '\' split-window -h -c "#{pane_current_path}"
bind '_' split-window -v -c "#{pane_current_path}"
```

**重新載入**: `Ctrl+Space r`

---

#### 新增自訂快捷鍵

**範例 1: Ctrl+Space k 關閉當前 pane（無需確認）**

```bash
# 編輯 ~/.tmux.conf

bind k kill-pane
```

**範例 2: Ctrl+Space Ctrl+K 關閉當前 window**

```bash
bind C-k kill-window
```

**範例 3: Ctrl+Space m 最大化/還原當前 pane**

```bash
bind m resize-pane -Z
```

---

#### Vim 風格導航增強

**當前**: `hjkl` 移動、`HJKL` 調整大小

**增加對角線移動**:

```bash
# 編輯 ~/.tmux.conf

# 快速跳到角落
bind H select-pane -L \; select-pane -t 0    # 左上角
bind L select-pane -R \; select-pane -t 0    # 右上角
bind J select-pane -D \; select-pane -t 0    # 左下角
bind K select-pane -U \; select-pane -t 0    # 右下角
```

---

## 整合自訂

### 範例：打造個人專屬環境

**需求**:
1. Gruvbox 主題（Ghostty + Tmux）
2. Fira Code 字體
3. Cmd+\ 和 Cmd+- 分割（Ghostty）
4. Ctrl+A 作為 Prefix（Tmux）
5. 自訂 Dev+Logs 布局（60/40）

**實施步驟**:

#### 步驟 1: 修改 Ghostty 配置

```bash
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

**變更內容**:

```toml
# 1. 改為 Gruvbox Dark 主題
background = 282828
foreground = ebdbb2
cursor-color = fe8019

palette = 0=#282828
palette = 1=#cc241d
palette = 2=#98971a
palette = 3=#d79921
palette = 4=#458588
palette = 5=#b16286
palette = 6=#689d6a
palette = 7=#a89984
palette = 8=#928374
palette = 9=#fb4934
palette = 10=#b8bb26
palette = 11=#fabd2f
palette = 12=#83a598
palette = 13=#d3869b
palette = 14=#8ec07c
palette = 15=#ebdbb2

# 2. 改為 Fira Code 字體
font-family = Fira Code Nerd Font

# 3. 修改分割快捷鍵
keybind = super+d=unbind
keybind = super+shift+d=unbind
keybind = super+backslash=new_split:right
keybind = super+minus=new_split:down
```

**重新載入**: `Cmd+Shift+Comma`

---

#### 步驟 2: 修改 Tmux 配置

```bash
vim ~/.tmux.conf
```

**變更內容**:

```bash
# 1. 改為 Gruvbox 主題（色彩變數）
bg="#282828"
fg="#ebdbb2"
blue="#83a598"
cyan="#8ec07c"
black="#3c3836"
white="#fbf1c7"
grey="#928374"
green="#b8bb26"
purple="#d3869b"
orange="#fe8019"

# 2. 改為 Ctrl+A Prefix
unbind C-Space
set -g prefix C-a
bind C-a send-prefix
```

**重新載入**: `Ctrl+A r`（注意：現在是 Ctrl+A）

---

#### 步驟 3: 創建 Dev+Logs 布局

```bash
# 創建腳本
vim ~/.tmux-layouts/dev-logs.sh
```

**腳本內容**（見前面「自訂布局」章節）

```bash
chmod +x ~/.tmux-layouts/dev-logs.sh
```

---

#### 步驟 4: 驗證所有變更

**Ghostty 驗證**:

```bash
# 檢查主題
# 背景應為深灰棕色（Gruvbox）

# 檢查字體
# 代碼中的 -> 應顯示為連字箭頭（Fira Code 特性）

# 檢查快捷鍵
Cmd+\           # 應向右分割
Cmd+-           # 應向下分割
```

**Tmux 驗證**:

```bash
# 檢查 Prefix
Ctrl+A ?        # 應顯示幫助（不是 Ctrl+Space）

# 檢查主題
# Status bar 應為 Gruvbox 色彩

# 測試新布局
~/.tmux-layouts/dev-logs.sh
# 應看到 60/40 分割
```

---

## 備份與恢復

### 備份配置

**Ghostty 配置**:

```bash
# 備份當前配置
cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   ~/ghostty-config.backup.$(date +%Y%m%d)

# 驗證備份
ls -lh ~/ghostty-config.backup.*
```

**Tmux 配置**:

```bash
# 備份 Tmux 配置
cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d)

# 備份布局腳本
cp -r ~/.tmux-layouts ~/.tmux-layouts.backup.$(date +%Y%m%d)

# 驗證備份
ls -lh ~/.tmux.conf.backup.*
ls -lhd ~/.tmux-layouts.backup.*
```

**完整備份腳本**:

```bash
#!/usr/bin/env bash

BACKUP_DIR=~/vibeghostty-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

# Ghostty
cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   "$BACKUP_DIR/ghostty-config"

# Tmux
cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf"
cp -r ~/.tmux-layouts "$BACKUP_DIR/tmux-layouts"

echo "✅ 備份完成: $BACKUP_DIR"
ls -lh "$BACKUP_DIR"
```

---

### 恢復配置

**從備份恢復**:

```bash
# Ghostty
cp ~/ghostty-config.backup.20251019 \
   ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 重新載入 Ghostty
Cmd+Shift+Comma

# Tmux
cp ~/.tmux.conf.backup.20251019 ~/.tmux.conf

# 重新載入 Tmux
tmux source-file ~/.tmux.conf
```

**從 Git 恢復**（如果有版本控制）:

```bash
cd ~/Documents/GitHub/VibeGhostty

# 恢復 Ghostty 配置
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 恢復 Tmux 配置
cp tmux/tmux.conf ~/.tmux.conf
cp -r tmux/layouts ~/.tmux-layouts
```

---

## 延伸閱讀

**官方參考**:
- [Ghostty 配置參考](https://ghostty.org/docs/config) - 完整配置選項
- [Tmux 官方 Wiki](https://github.com/tmux/tmux/wiki) - Tmux 進階設定

**主題資源**:
- [Tokyo Night](https://github.com/enkia/tokyo-night-vscode-theme) - 當前主題
- [Gruvbox](https://github.com/morhetz/gruvbox) - 暖色調復古風
- [Dracula](https://draculatheme.com/) - 紫色系高對比
- [Nord](https://www.nordtheme.com/) - 冷色調極簡風
- [Catppuccin](https://github.com/catppuccin/catppuccin) - 柔和莫蘭迪色

**字體資源**:
- [Nerd Fonts](https://www.nerdfonts.com/) - 完整 Nerd Font 集合
- [Programming Fonts](https://www.programmingfonts.org/) - 程式設計字體測試

**社群配置**:
- [dotfiles](https://dotfiles.github.io/) - 各種配置分享

---

**文檔版本**: 1.1.0
**最後更新**: 2025-10-19
**貢獻者**: Claude Code

祝你打造出完美的個人化終端環境！ 🎨
