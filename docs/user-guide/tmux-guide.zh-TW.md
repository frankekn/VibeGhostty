# Tmux 使用指南

**版本**: 1.1.0
**最後更新**: 2025-10-19
**預估閱讀時間**: 完整閱讀 30 分鐘，快速開始 10 分鐘
**前置閱讀**: 建議先完成 [Ghostty 快速開始](quickstart.zh-TW.md)

---

## 目錄

1. [Tmux 快速開始（10 分鐘）](#第一章tmux-快速開始10-分鐘)
2. [Tmux 核心概念](#第二章tmux-核心概念)
3. [配置系統](#第三章配置系統)
4. [工作空間布局](#第四章工作空間布局)
5. [完整快捷鍵速查表](#第五章完整快捷鍵速查表)
6. [進階功能](#第六章進階功能)
7. [工具命令](#第七章工具命令)
8. [工作流程最佳實踐](#第八章工作流程最佳實踐)
9. [效能優化](#第九章效能優化)
10. [常見問題](#第十章常見問題)

---

## 第一章：Tmux 快速開始（10 分鐘）

**本章目標**: 10 分鐘內完成 Tmux 配置安裝並啟動第一個工作空間

### 1.1 什麼是 Tmux？

Tmux 是一個終端機多工器（terminal multiplexer），讓你能夠：

- 🔄 **持久化 sessions**：關閉終端機視窗後，工作環境仍在背景執行
- 📐 **複雜布局管理**：在單一視窗內分割多個窗格
- 🤝 **多 AI 協作**：Codex CLI 和 Claude Code 並排工作
- 💾 **自動保存**：透過插件自動儲存和恢復工作狀態

### 與 Ghostty 的互補關係

| 功能 | Ghostty | Tmux | 最佳使用場景 |
|------|---------|------|-------------|
| **視窗管理** | Tabs/Splits | Sessions/Windows/Panes | 輕量任務用 Ghostty，複雜協作用 Tmux |
| **持久化** | ❌ 關閉即消失 | ✅ 可 detach/attach | 長期專案、多天工作用 Tmux |
| **快捷鍵** | `Cmd+...` (macOS 原生) | `Ctrl+Space ...` (Tmux prefix) | 兩者不衝突，可同時使用 |
| **啟動速度** | ⚡ 極快 | 🐢 稍慢（需載入配置） | 快速實驗用 Ghostty，正式開發用 Tmux |

---

### 1.2 安裝 Tmux 配置

#### 方法 1: 從專案目錄安裝（推薦）

```bash
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh
```

#### 方法 2: 一鍵安裝（遠端）

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/frankekn/VibeGhostty/master/tmux/install.sh)
```

**腳本會自動：**
- ✅ 檢查並安裝 Tmux（若未安裝）
- ✅ 安裝 TPM（Tmux Plugin Manager）
- ✅ 複製所有配置文件到正確位置
- ✅ 設定執行權限
- ✅ 更新 PATH（如需要）

---

### 1.3 啟動第一個工作空間

#### 使用互動式選單（推薦新手）

```bash
tmux-launch
```

你會看到：

```
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║          🚀 Tmux AI Workspace Launcher 🤖                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

選擇工作空間布局：

  1 │ AI Workspace (主要工作模式)
  2 │ AI Split (比較模式)
  3 │ Full Focus (專注模式)
  4 │ Resume (恢復上次 session)
  q │ Exit (離開)
```

**選擇布局 1（推薦新手）**：

按 `1` 然後按 `Enter`，你會看到：

```
┌─────────────────────────┬─────────────┐
│   🔧 Codex CLI         │  🤖 Claude  │
│   (主要工作區 70%)      │   Code      │
│                         │   (30%)     │
│                         ├─────────────┤
│                         │  📊 Monitor │
│                         │   (30%)     │
└─────────────────────────┴─────────────┘
```

#### 直接啟動特定布局

```bash
# AI Workspace 布局（70/30 分割）
~/.tmux-layouts/ai-workspace.sh

# AI Split 布局（50/50 分割）
~/.tmux-layouts/ai-split.sh

# Full Focus 布局（100% 全屏）
~/.tmux-layouts/full-focus.sh
```

---

### 1.4 基本操作（前 5 分鐘需要的）

**Prefix 鍵**: `Ctrl+Space`（所有 Tmux 命令都以此開頭）

| 快捷鍵 | 功能 | 使用場景 |
|--------|------|---------|
| `Ctrl+Space d` | 離開 session（detach） | 保持程式執行，稍後回來 |
| `Ctrl+Space 1~5` | 跳轉到窗格 1-5 | 快速切換工作區 |
| `Ctrl+Space z` | 窗格全屏切換 | 專注單一任務 |
| `Ctrl+Space ?` | 顯示所有快捷鍵 | 查看完整按鍵列表 |

**實際操作範例**：

```bash
# 1. 在左側 Codex CLI（窗格 0）開始工作
Ctrl+Space 1    # 跳到窗格 0

# 2. 切換到右上 Claude Code（窗格 1）
Ctrl+Space 2    # 跳到窗格 1

# 3. 切換到右下 Monitor（窗格 2）
Ctrl+Space 3    # 跳到窗格 2

# 4. 需要暫時離開
Ctrl+Space d    # Detach（session 繼續在背景執行）
```

---

### 1.5 重新連接 session

離開 session 後，隨時可以重新連接：

```bash
# 方法 1: 智能 attach（自動偵測專案）
ta

# 方法 2: 連接到最近的 session
tmux attach

# 方法 3: 列出所有 sessions 並選擇
ta -l
tmux attach -t <session-name>

# 方法 4: 指定 session 名稱
ta -n my-project
```

---

### 1.6 驗證安裝

**檢查清單**：

```bash
# 1. 檢查 Tmux 版本
tmux -V
# 應該顯示: tmux 3.0 或更高版本

# 2. 檢查配置載入
tmux source-file ~/.tmux.conf
# 沒有錯誤訊息即為成功

# 3. 檢查插件安裝
ls ~/.tmux/plugins/tpm
# 應該顯示 TPM 目錄

# 4. 檢查快捷鍵有效
# 啟動 tmux 後按 Ctrl+Space ?
# 應該顯示快捷鍵列表
```

---

### 1.7 下一步

完成快速開始後：

- 📖 繼續閱讀本指南的後續章節（完整功能）
- 🎨 參考 [自訂配置](customization.zh-TW.md) 調整布局和主題
- 🚀 查看 [工作流程範例](workflows.zh-TW.md) 學習實戰技巧

---

## 第二章：Tmux 核心概念

### 2.1 Session、Window、Pane 的關係

Tmux 使用三層結構來組織終端環境：

```
Server (tmux 主程序)
└── Session (工作會話，如 "ai-work")
    └── Window (視窗，類似瀏覽器分頁)
        └── Pane (窗格，分割的終端區域)
```

**具體範例**：

```
Session: vibeghostty-dev
├── Window 0: development
│   ├── Pane 0: Codex CLI (70%)
│   ├── Pane 1: Claude Code (30%)
│   └── Pane 2: Monitor (30%)
├── Window 1: testing
│   └── Pane 0: npm test --watch (100%)
└── Window 2: git
    └── Pane 0: git status (100%)
```

### 2.2 VibeGhostty 的 Tmux 配置哲學

#### 為什麼選擇 Ctrl+Space？

傳統 Tmux 使用 `Ctrl+B` 作為 prefix，但我們選擇 `Ctrl+Space` 因為：

- ✅ **人體工學**：Space 鍵比 B 鍵更容易按到
- ✅ **避免衝突**：`Ctrl+B` 在很多編輯器中是「向上翻頁」
- ✅ **單手操作**：`Ctrl+Space` 可以單手按（左手 Ctrl + 右手大拇指 Space）
- ✅ **與 Ghostty 區隔**：Ghostty 使用 `Cmd+...`，Tmux 使用 `Ctrl+Space ...`，不會衝突

#### Tokyo Night Storm 主題

所有配置使用統一的 Tokyo Night Storm 主題：

| 元素 | 色彩 | 用途 |
|------|------|------|
| 背景 | `#24283b` | 深藍灰色，低對比度，護眼 |
| 前景 | `#c0caf5` | 柔和白色，清晰易讀 |
| 強調 | `#ff9e64` | 橙色，用於游標和重要元素 |
| 活動 | `#7aa2f7` | 藍色，用於活動視窗和邊框 |

#### AI 協作設計

三種預設布局專為多 AI 協作設計：

1. **AI Workspace (70/30)**：主力 AI（左側）+ 輔助 AI（右上）+ 監控（右下）
2. **AI Split (50/50)**：並排比較兩個 AI 的不同建議
3. **Full Focus (100%)**：深度思考時只使用單一 AI

---

### 2.3 與 Ghostty 的分工

| 使用場景 | 建議工具 | 原因 |
|---------|---------|------|
| 快速實驗、單一命令 | Ghostty tabs | 啟動快速，視覺簡潔 |
| 複雜專案、多 AI 協作 | Tmux sessions | 複雜布局，持久化 |
| 需要保存工作狀態 | Tmux sessions | 可 detach/attach，自動保存 |
| 臨時測試、快速查看 | Ghostty splits | 最小設定，即開即用 |
| 多天開發同一專案 | Tmux sessions | 恢復完整工作環境 |

**混合模式（推薦）**：

```
Ghostty Tab 1: 專案 A 的 Tmux session
Ghostty Tab 2: 專案 B 的 Tmux session
Ghostty Tab 3: 系統監控（純 Ghostty，不用 Tmux）
```

---

## 第三章：配置系統

### 3.1 配置文件結構

```
~/.tmux.conf          # 主配置
~/.tmux-layouts/      # 布局腳本
│   ├── ai-workspace.sh
│   ├── ai-split.sh
│   └── full-focus.sh
~/.local/bin/         # 工具命令
│   ├── tmux-launch
│   ├── vibe-help
│   └── ta
~/.tmux/plugins/      # TPM 插件
│   ├── tpm/
│   ├── tmux-sensible/
│   ├── tmux-resurrect/
│   ├── tmux-continuum/
│   └── tmux-logging/
```

---

### 3.2 主題配置（Tokyo Night Storm）

**色彩變數**（定義在 `~/.tmux.conf`）：

```bash
# Tokyo Night Storm 色彩變數
bg="#24283b"          # 背景
fg="#c0caf5"          # 前景
blue="#7aa2f7"        # 藍色（活動窗格）
orange="#ff9e64"      # 橙色（強調）
green="#9ece6a"       # 綠色（成功）
red="#f7768e"         # 紅色（錯誤）
```

**如何修改主題**：

1. 編輯 `~/.tmux.conf` 中的色彩變數
2. 重新載入配置：`Ctrl+Space r`

**範例：改為淺色主題**

```bash
# 在 ~/.tmux.conf 中修改
bg="#ffffff"          # 白色背景
fg="#000000"          # 黑色前景
blue="#0000ff"        # 標準藍色
```

---

### 3.3 重新載入配置

修改配置後，無需重啟 Tmux：

```bash
# 方法 1: 在 Tmux 內使用快捷鍵
Ctrl+Space r

# 方法 2: 在 Tmux 外執行命令
tmux source-file ~/.tmux.conf

# 方法 3: 在 Tmux 命令模式中
Ctrl+Space :
source-file ~/.tmux.conf
```

---

## 第四章：工作空間布局

### 4.1 三種預設布局

#### AI Workspace (70/30)

**適用場景**：
- 日常開發工作
- 需要 AI 輔助編碼
- 同時監控測試或日誌

**布局設計**：

```
┌─────────────────────────┬─────────────┐
│   🔧 Codex CLI         │  🤖 Claude  │
│   (主要工作區 70%)      │   Code      │
│                         │   (30%)     │
│   - 主要對話            ├─────────────┤
│   - 程式碼生成          │  📊 Monitor │
│   - 問題解決            │   (30%)     │
│                         │             │
│                         │ - 測試輸出  │
│                         │ - 日誌監控  │
└─────────────────────────┴─────────────┘
```

**啟動方式**：

```bash
# 方法 1: 互動式
tmux-launch
# → 選擇 1

# 方法 2: 直接啟動
~/.tmux-layouts/ai-workspace.sh

# 方法 3: 指定專案目錄
~/.tmux-layouts/ai-workspace.sh ~/my-project
```

**快速跳轉**：

- `Ctrl+Space 1` → Codex CLI（窗格 0）
- `Ctrl+Space 2` → Claude Code（窗格 1）
- `Ctrl+Space 3` → Monitor（窗格 2）

**使用技巧**：

1. **主 AI + 輔助 AI 模式**
   - Codex CLI（左側）：主要程式碼生成
   - Claude Code（右上）：程式碼審查、建議改進
   - Monitor（右下）：執行 `npm test --watch`

2. **問題解決工作流程**
   ```
   1. 在 Codex 描述問題
   2. 在 Claude 獲取第二意見
   3. 在 Monitor 執行測試驗證
   ```

---

#### AI Split (50/50)

**適用場景**：
- 比較兩個 AI 的解決方案
- 評估不同實作方式
- 學習 AI 思考差異

**布局設計**：

```
┌────────────────┬────────────────┐
│  🔧 Codex CLI  │  🤖 Claude     │
│  (50%)         │   Code (50%)   │
│                │                │
│  相同問題      │  相同問題      │
│  不同解法      │  不同解法      │
│                │                │
├────────────────┴────────────────┤
│  ⚖️  Compare/Monitor (25%)     │
│                                 │
│  - 比較輸出差異                 │
│  - 執行兩邊的程式碼             │
│  - 評估品質和效能               │
└─────────────────────────────────┘
```

**啟動方式**：

```bash
~/.tmux-layouts/ai-split.sh
```

**使用場景範例**：

**範例 1: 演算法比較**

```
問題：「實作一個高效的陣列去重函式」

Codex 回答：
  → 使用 Set 方法（簡潔）

Claude 回答：
  → 使用 filter + indexOf（相容性好）

在 Compare 窗格：
  → 執行效能測試
  → 比較不同資料量的表現
  → 決定最適合的方案
```

**範例 2: API 設計**

```
問題：「設計一個 RESTful API 處理使用者認證」

比較重點：
  - API 端點命名
  - 錯誤處理方式
  - 安全性考量
  - 程式碼組織結構
```

---

#### Full Focus (100%)

**適用場景**：
- 深度思考複雜問題
- 減少視覺干擾
- 長時間與單一 AI 對話

**布局設計**：

```
┌─────────────────────────────────┐
│                                 │
│    🔧 Codex CLI (100%)         │
│    或                           │
│    🤖 Claude Code (100%)       │
│                                 │
│    全屏專注，無干擾             │
│                                 │
└─────────────────────────────────┘
```

**啟動方式**：

```bash
# 預設使用 Codex
~/.tmux-layouts/full-focus.sh

# 指定使用 Claude
~/.tmux-layouts/full-focus.sh ~/my-project claude
```

**專注模式哲學**：

單一 AI、單一任務、深度思考。適合：
- 學習新概念
- 解決複雜 bug
- 架構設計討論
- 程式碼深度重構

**需要分割時**：

```bash
# 在 Focus 模式中，隨時可以分割
Ctrl+Space |    # 垂直分割
Ctrl+Space -    # 水平分割
```

---

### 4.2 布局腳本解析

**基本結構**（以 `ai-workspace.sh` 為例）：

```bash
#!/usr/bin/env bash
set -e

SESSION="ai-work"
PROJECT_DIR="${1:-$PWD}"

# 檢查 session 是否存在
tmux has-session -t $SESSION 2>/dev/null
if [ $? != 0 ]; then
    # 創建新 session
    tmux new-session -d -s "$SESSION" -c "$PROJECT_DIR"

    # 設定窗格 0（Codex CLI，70%）
    tmux select-pane -t 0 -T "🔧 Codex CLI"
    tmux send-keys -t "$SESSION:0.0" "codex" C-m

    # 分割窗格 1（Claude Code，30%）
    tmux split-window -h -p 30 -t "$SESSION:0" -c "$PROJECT_DIR"
    tmux select-pane -t 1 -T "🤖 Claude Code"
    tmux send-keys -t "$SESSION:0.1" "claude" C-m

    # 分割窗格 2（Monitor，30%）
    tmux split-window -v -p 50 -t "$SESSION:0.1" -c "$PROJECT_DIR"
    tmux select-pane -t 2 -T "📊 Monitor"

    # 跳回窗格 0
    tmux select-pane -t 0
fi

# 連接到 session
tmux attach-session -t "$SESSION"
```

**關鍵參數說明**：

- `-d`: detached mode（在背景創建）
- `-s`: session 名稱
- `-c`: 初始目錄
- `-h`: 水平分割（左右）
- `-v`: 垂直分割（上下）
- `-p 30`: 新窗格佔 30%
- `-t`: 目標 session/window/pane
- `-T`: 設定窗格標題

---

### 4.3 使用 tmux-launch 互動式選擇

`tmux-launch` 是一個互動式布局選擇器，提供友善的選單介面：

**功能**：

1. 列出所有可用布局
2. 顯示每個布局的說明
3. 恢復上次使用的 session
4. 自動處理 session 已存在的情況

**使用方式**：

```bash
tmux-launch
```

**選單說明**：

```
  1 │ AI Workspace (主要工作模式)
      → 70/30 分割，適合日常開發

  2 │ AI Split (比較模式)
      → 50/50 分割，適合比較 AI 建議

  3 │ Full Focus (專注模式)
      → 100% 全屏，適合深度思考

  4 │ Resume (恢復上次 session)
      → 連接到最近使用的 session

  q │ Exit (離開)
```

---

## 第五章：完整快捷鍵速查表

**Prefix**: `Ctrl+Space`（所有 Tmux 快捷鍵都要先按這個）

### 5.1 Session 管理

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space d` | Detach session | 暫時離開（session 保留） |
| `Ctrl+Space s` | 列出 sessions | 選擇要切換的 session |
| `Ctrl+Space $` | 重新命名 session | 修改當前 session 名稱 |
| `Ctrl+Space (` | 切換到上一個 session | 快速切換 |
| `Ctrl+Space )` | 切換到下一個 session | 快速切換 |

**命令列操作**：

```bash
tmux new -s <name>           # 創建新 session
tmux attach -t <name>        # 連接到 session
tmux kill-session -t <name>  # 刪除 session
tmux list-sessions           # 列出所有 sessions
```

---

### 5.2 Window 管理

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space c` | 創建新 window | 類似瀏覽器新分頁 |
| `Ctrl+Space ,` | 重新命名 window | 修改 window 名稱 |
| `Ctrl+Space &` | 關閉當前 window | 需確認 |
| `Ctrl+Space 0~9` | 跳到 window 0-9 | 快速切換 |
| `Ctrl+Space n` | 下一個 window | Next window |
| `Ctrl+Space p` | 上一個 window | Previous window |

---

### 5.3 Pane 管理

#### 創建和關閉

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space \|` | 垂直分割 | 左右分割（記：\| 是垂直線） |
| `Ctrl+Space -` | 水平分割 | 上下分割（記：- 是水平線） |
| `Ctrl+Space x` | 關閉窗格 | 需確認 |
| `Ctrl+Space z` | 縮放窗格 | 全屏/還原（toggle） |

#### 導航（Vim-Style）

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space h` | 移到左側窗格 | Vim 左鍵 |
| `Ctrl+Space j` | 移到下方窗格 | Vim 下鍵 |
| `Ctrl+Space k` | 移到上方窗格 | Vim 上鍵 |
| `Ctrl+Space l` | 移到右側窗格 | Vim 右鍵 |

#### 快速跳轉

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space 1` | 跳到窗格 0 | Codex CLI（左側） |
| `Ctrl+Space 2` | 跳到窗格 1 | Claude Code（右上） |
| `Ctrl+Space 3` | 跳到窗格 2 | Monitor（右下） |
| `Ctrl+Space 4` | 跳到窗格 3 | 如果有第 4 個 pane |
| `Ctrl+Space 5` | 跳到窗格 4 | 如果有第 5 個 pane |

#### 調整大小

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space H` | 向左擴展 | Shift+h（大寫） |
| `Ctrl+Space J` | 向下擴展 | Shift+j（大寫） |
| `Ctrl+Space K` | 向上擴展 | Shift+k（大寫） |
| `Ctrl+Space L` | 向右擴展 | Shift+l（大寫） |

**提示**：按住 Shift 的 hjkl 是調整大小

---

### 5.4 Copy Mode（複製模式）

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space [` | 進入 copy mode | 可捲動歷史記錄 |
| `v` | 開始選取 | 類似 Vim visual mode |
| `y` | 複製選取內容 | 複製到系統剪貼簿 |
| `q` | 離開 copy mode | 回到正常模式 |
| `Ctrl+v` | 矩形選取 | 選取方塊區域 |

**Copy Mode 中的移動**：

- `h/j/k/l` - 游標移動
- `w/b` - 前後移動一個單字
- `0/$` - 行首/行尾
- `g/G` - 檔案開頭/結尾
- `/` - 搜尋

---

### 5.5 其他常用快捷鍵

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space r` | 重新載入配置 | 修改 .tmux.conf 後使用 |
| `Ctrl+Space :` | 命令模式 | 輸入 tmux 命令 |
| `Ctrl+Space ?` | 顯示所有快捷鍵 | 查看完整按鍵列表 |
| `Ctrl+Space m` | 模式選單 | 臨時控制面板 |

---

## 第六章：進階功能

### 6.1 TPM 插件管理

#### 已安裝插件

| 插件 | 功能 | 版本 |
|------|------|------|
| tmux-sensible | 基礎配置優化 | 最新 |
| tmux-resurrect | Session 保存/恢復 | 最新 |
| tmux-continuum | 自動保存 | 最新 |
| tmux-logging | 日誌記錄 | 最新 |

#### 安裝新插件

1. **編輯 `~/.tmux.conf`**

```bash
# 在插件列表中新增
set -g @plugin 'new-plugin-author/new-plugin-name'
```

2. **安裝插件**

```bash
# 在 Tmux 中按快捷鍵
Ctrl+Space I    # 大寫 I

# 或手動執行
~/.tmux/plugins/tpm/bin/install_plugins
```

3. **更新所有插件**

```bash
Ctrl+Space U    # 大寫 U
```

---

### 6.2 Session 持久化（tmux-resurrect）

**功能**：記錄所有 sessions、windows、panes 的布局和工作目錄

**手動操作**：

```bash
# 手動儲存當前所有 sessions
Ctrl+Space Ctrl+s

# 手動恢復所有 sessions
Ctrl+Space Ctrl+r
```

**儲存內容包含**：
- 所有 sessions、windows、panes 的布局
- 每個窗格 的工作目錄
- 每個窗格 正在執行的程式（如 vim、less）
- Pane 標題

**實際應用**：

1. **電腦需要重啟**
   ```bash
   Ctrl+Space Ctrl+s    # 手動儲存
   # 重啟電腦
   tmux                 # 啟動 tmux
   Ctrl+Space Ctrl+r    # 恢復所有 sessions
   ```

2. **Tmux 當掉了怎麼辦？**
   ```bash
   # 系統每 15 分鐘自動儲存
   # 重啟 tmux 後
   tmux
   Ctrl+Space Ctrl+r    # 恢復到 15 分鐘前
   ```

---

### 6.3 自動保存（tmux-continuum）

**功能**：自動定期儲存 sessions，自動恢復上次狀態

**設定**（已在 `~/.tmux.conf` 中配置）：

```bash
# 自動保存間隔（分鐘）
set -g @continuum-save-interval '15'

# 自動恢復（啟動 Tmux 時）
set -g @continuum-restore 'on'
```

**運作方式**：

- 每 15 分鐘自動儲存一次
- 啟動 Tmux 時自動恢復上次狀態
- 無需手動操作

---

### 6.4 日誌記錄（tmux-logging）

**功能**：記錄窗格 中的所有輸出

**操作**：

```bash
# 開始記錄當前窗格
Ctrl+Space Shift+P    # 開始記錄

# 停止記錄
Ctrl+Space Shift+P    # 再按一次停止

# 日誌存放位置
~/.tmux/logs/
```

**使用場景**：

1. **記錄測試輸出**
   ```bash
   Ctrl+Space 3          # 跳到 monitor 窗格
   Ctrl+Space Shift+P    # 開始記錄
   npm test              # 執行測試
   # 測試完成
   Ctrl+Space Shift+P    # 停止記錄
   ```

2. **記錄 AI 對話**
   - 保存完整的 AI 回答
   - 稍後分析或分享

---

### 6.5 模式選單（Mode Menu）

**功能**：臨時控制面板，快速存取常用功能

**啟動**：

```bash
Ctrl+Space m
```

**選單內容**：

- Session 管理
- Window 管理
- Pane 管理
- 快捷鍵提示

---

## 第七章：工具命令

### 7.1 tmux-launch

**功能**：互動式布局選擇器

**完整說明請參考** [第四章 - 4.3 使用 tmux-launch 互動式選擇](#43-使用-tmux-launch-互動式選擇)

---

### 7.2 ta（智能 attach）

**功能**：專案感知的 session 管理工具

**使用方式**：

```bash
# 自動偵測當前專案並 attach
ta

# 列出所有 sessions
ta -l

# 指定 session 名稱
ta -n my-project
```

**智能偵測原理**：

`ta` 會根據當前目錄名稱自動尋找對應的 session：

```bash
# 當前目錄: ~/projects/vibeghostty
ta
# → 自動 attach 到 "vibeghostty" session（如果存在）

# 當前目錄: ~/work/client-website
ta
# → 自動 attach 到 "client-website" session（如果存在）
```

---

### 7.3 vibe-help

**功能**：快捷鍵速查表的快速查詢

**使用方式**：

```bash
vibe-help
# 或在 Tmux 中按
Ctrl+Space ?
```

**顯示內容**：

- 所有快捷鍵列表
- 按功能分類
- 使用範例

---

## 第八章：工作流程最佳實踐

### 8.1 單一專案深度工作

**場景**：專注開發單一專案

**推薦布局**：Full Focus 模式

**工作流程**：

```bash
# 1. 啟動 Full Focus 模式
~/.tmux-layouts/full-focus.sh ~/my-project

# 2. 使用單一 AI 深度對話
# （Codex 或 Claude）

# 3. 需要參考文檔時，臨時分割
Ctrl+Space |    # 垂直分割
# 在新窗格 中查看文檔

# 4. 完成後關閉臨時 pane
Ctrl+Space x
```

---

### 8.2 多專案並行開發

**場景**：同時處理多個專案

**推薦策略**：每個專案一個 session

**工作流程**：

```bash
# 1. 為每個專案創建 session
~/.tmux-layouts/ai-workspace.sh ~/project-a
Ctrl+Space d    # Detach

~/.tmux-layouts/ai-workspace.sh ~/project-b
Ctrl+Space d    # Detach

~/.tmux-layouts/ai-workspace.sh ~/project-c
Ctrl+Space d    # Detach

# 2. 使用 ta 快速切換
ta -n ai-project-a
ta -n ai-project-b
ta -n ai-project-c

# 3. 或使用 session 列表切換
Ctrl+Space s    # 顯示 session 列表，上下鍵選擇
```

---

### 8.3 AI 工具協作

**場景**：使用多個 AI 協作開發

**推薦布局**：AI Workspace 或 AI Split

**詳細工作流程請參考** [工作流程範例](workflows.zh-TW.md)

---

### 8.4 Session 命名規範

**推薦格式**：

```bash
# 按專案命名
ta -n vibeghostty
ta -n client-website
ta -n backend-api

# 按功能命名
ta -n learning-rust
ta -n debugging-auth
ta -n experiment-ai

# 按客戶/公司命名
ta -n client-projecta
ta -n internal-tools
```

**避免的命名**：

```bash
# ❌ 太泛
ta -n test
ta -n work

# ❌ 無意義
ta -n session1
ta -n asdf

# ❌ 難以辨識
ta -n abc123
```

**原因**：`ta` 工具會根據當前目錄名稱自動偵測，清晰的命名更易管理

---

## 第九章：效能優化

### 9.1 Session 數量管理

**建議**：

- 1 session per project（專案隔離）
- 定期清理不活躍的 session

**清理 session**：

```bash
# 列出所有 sessions
tmux list-sessions

# 刪除不用的 session
tmux kill-session -t old-project

# 或使用 ta
ta -l    # 列出 sessions
# 選擇要刪除的 session
tmux kill-session -t <name>
```

---

### 9.2 Scrollback 限制調整

**預設**：50,000 行

**調整建議**：

| RAM 大小 | 建議 scrollback-limit |
|---------|----------------------|
| <8GB | 10,000-20,000 行 |
| 8-16GB | 50,000 行（預設） |
| 16GB+ | 100,000-200,000 行 |

**修改方式**：

```bash
# 編輯 ~/.tmux.conf
set -g history-limit 50000

# 重新載入配置
Ctrl+Space r
```

---

### 9.3 Pane 數量管理

**最佳實踐**：

- **3-5 個 panes**：正常使用 ✅
- **6-10 個 panes**：注意記憶體 ⚠️
- **>10 個 panes**：建議清理 🔴

**原因**：每個窗格 維護獨立的 scrollback buffer

---

## 第十章：常見問題

### Q1: Tmux 和 Ghostty 分頁有什麼不同？

**A:**
- **Ghostty 分頁**：完全獨立的終端環境，關閉就消失
- **Tmux Session**：可以 detach 和 attach，關閉 Ghostty 也不影響

**最佳實踐：**
- 使用 Tmux sessions 管理專案工作空間
- Ghostty 分頁用於完全不同的工作（如系統管理、監控）

---

### Q2: 為什麼選擇 Ctrl+Space 而不是 Ctrl+B？

**A:**
- **人體工學**：Space 比 B 更容易按到
- **避免衝突**：Ctrl+B 在很多編輯器中是「向上翻頁」
- **單手操作**：Ctrl+Space 可以單手按

---

### Q3: 可以在 Tmux 中使用滑鼠嗎？

**A:**
可以！配置中已啟用滑鼠支援：
- 點擊切換 pane
- 拖曳調整 pane 大小
- 滾輪捲動歷史記錄
- 在 copy mode 中選取文字

---

### Q4: 如何完全退出所有 sessions？

**A:**
```bash
# 方法 1：在 tmux 外
tmux kill-server

# 方法 2：在 tmux 內
Ctrl+Space : kill-server

# 方法 3：只殺當前 session
Ctrl+Space : kill-session
```

---

### Q5: 為什麼腳本沒有自動啟動 AI CLI？

**A:**
2025-10 更新後，`ai-workspace.sh`、`ai-split.sh`、`full-focus.sh` 僅負責建立窗格與調整版面，不再自動執行 `codex`、`claude` 等 CLI。這樣做可以避免在窗格建立時同時發送指令造成干擾，並讓使用者自由決定要啟動哪個工具。

建議流程：

1. 執行對應腳本建立 layout。
2. 切換到想使用的窗格（如 `Ctrl+Space 1`）。
3. **手動輸入** `codex`、`claude` 或其他指令啟動工具。

若輸入指令後仍無法啟動，請依序確認：

```bash
which codex
which claude
echo $PATH
```

若 CLI 安裝與 PATH 都正常，仍遇到 shell 初始化問題，可在 `~/.tmux.conf` 加入：

```bash
set -g default-command "${SHELL}"
```

---

### Q6: 顏色看起來不對？

**A:**

1. **檢查終端類型**
   ```bash
   echo $TERM
   # 應該是 screen-256color 或 tmux-256color
   ```

2. **測試真彩色支援**
   ```bash
   # 在 tmux 中執行
   printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
   # 應該顯示橘色的 TRUECOLOR
   ```

3. **確保 Ghostty 啟用真彩色**
   - 檢查 Ghostty config 中有 `term = xterm-256color`

---

### Q7: 如何在 Pane 之間複製貼上？

**A:**

**方法 1：使用 Tmux copy mode**
```bash
1. Ctrl+Space [           # 進入 copy mode
2. 移動到要複製的位置
3. v                      # 開始選取
4. 移動選取範圍
5. y                      # 複製（自動回到正常模式）
6. 移到目標 pane
7. Cmd+V                  # 貼上（macOS 剪貼簿）
```

**方法 2：使用滑鼠**
```bash
1. 按住滑鼠左鍵拖曳選取
2. Cmd+C 複製
3. 移到目標 pane
4. Cmd+V 貼上
```

---

### Q8: Session 無法恢復？

**A:**

**診斷**：
```bash
# 檢查 resurrect 檔案
ls ~/.tmux/resurrect/
```

**解決**：
```bash
# 確認 plugin 已安裝
ls ~/.tmux/plugins/tmux-resurrect

# 如果不存在，安裝 plugins
Ctrl+Space I

# 手動儲存一次測試
Ctrl+Space Ctrl+s
```

---

### Q9: 快捷鍵衝突怎麼辦？

**A:**

**常見衝突**：

| 快捷鍵 | 可能衝突的程式 | 解決方案 |
|--------|---------------|---------|
| `Ctrl+Space` | macOS Spotlight | 取消 Spotlight 快捷鍵或改用 `Ctrl+A` |
| `Ctrl+h/j/k/l` | Vim、Neovim | 使用 vim-tmux-navigator plugin |

**更改 prefix key**：

```bash
# 在 ~/.tmux.conf
unbind C-Space
set -g prefix C-a
bind C-a send-prefix
```

---

### Q10: 布局腳本執行失敗？

**A:**

**症狀**：
```bash
$ ~/.tmux-layouts/ai-workspace.sh
bash: permission denied
```

**解決**：
```bash
# 設定執行權限
chmod +x ~/.tmux-layouts/*.sh
chmod +x ~/.local/bin/tmux-launch

# 驗證
ls -la ~/.tmux-layouts/
```

---

### 更多問題？

請參考 [故障排除完整指南](troubleshooting.zh-TW.md)

---

## 延伸閱讀

**基礎知識**：
- [Ghostty 使用指南](ghostty-guide.zh-TW.md) - 了解 Ghostty 與 Tmux 的整合
- [快速開始](quickstart.zh-TW.md) - 5 分鐘快速設定

**進階主題**：
- [自訂配置](customization.zh-TW.md) - 深度自訂 Ghostty 和 Tmux
- [工作流程範例](workflows.zh-TW.md) - AI 協作實戰案例

**問題排除**：
- [故障排除](troubleshooting.zh-TW.md) - 完整問題解決方案

**官方資源**：
- [Tmux 官方 Wiki](https://github.com/tmux/tmux/wiki) - Tmux 完整參考
- [TPM GitHub](https://github.com/tmux-plugins/tpm) - 插件管理器

---

**版本歷史**：

| 版本 | 日期 | 變更 |
|------|------|------|
| 1.1.0 | 2025-10-19 | 整合 QUICKSTART_TMUX + TMUX_GUIDE，消除 85% 冗餘 |
| 1.0.0 | 2025-10-16 | 初始版本 |

**維護者**: Frank Yang
**最後更新**: 2025-10-19
**配置版本**: 1.0.0
