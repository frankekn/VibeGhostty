# Tmux AI 工作空間完整使用指南

> **專為 Frank Yang 打造的多 AI Agent 協作終端環境**
> 整合 Codex CLI 與 Claude Code，搭配 Tokyo Night Storm 主題

---

## 📑 目錄

1. [簡介](#簡介)
2. [核心概念](#核心概念)
3. [快速開始](#快速開始)
4. [布局說明](#布局說明)
5. [快捷鍵速查表](#快捷鍵速查表)
6. [進階使用](#進階使用)
7. [常見問題](#常見問題)
8. [最佳實踐](#最佳實踐)
9. [故障排除](#故障排除)

---

## 簡介

### 什麼是 Tmux AI 工作空間？

這是一個專門為多 AI Agent 協作設計的終端環境配置，讓你能夠：

- 🤝 **同時使用多個 AI**：Codex CLI 和 Claude Code 並行工作
- 🎨 **視覺一致性**：Tokyo Night Storm 主題與 Ghostty 完美配合
- ⚡ **高效切換**：Vim-style 導航，快速在不同 panes 間移動
- 💾 **自動保存**：Session 自動儲存，隨時恢復工作狀態
- 📊 **即時監控**：專屬 monitor pane 顯示測試、日誌、系統狀態

### 為什麼使用 Tmux？

| 功能 | 沒有 Tmux | 使用 Tmux |
|------|-----------|----------|
| **多視窗管理** | 需要多個終端視窗 | 單一視窗內分割多個 panes |
| **Session 保留** | 關閉就丟失 | 自動保存，隨時恢復 |
| **AI 協作** | 來回切換視窗 | 並排比較，即時協作 |
| **工作流程** | 手動設定每次 | 一鍵啟動完整環境 |

---

## 核心概念

### Tmux 層級結構

```
Server (tmux 主程序)
└── Session (工作 session，如 "ai-work")
    └── Window (視窗，類似瀏覽器分頁)
        └── Pane (面板，分割的終端區域)
```

### Ghostty + Tmux 雙層控制

```
┌─────────────────────────────────────┐
│         Ghostty Terminal            │  ← 第一層（終端模擬器）
│  ┌───────────────────────────────┐  │
│  │      Tmux Session             │  │  ← 第二層（終端多工器）
│  │  ┌─────────┬──────────────┐   │  │
│  │  │ Pane 0  │  Pane 1      │   │  │  ← 第三層（分割面板）
│  │  │         ├──────────────┤   │  │
│  │  │         │  Pane 2      │   │  │
│  │  └─────────┴──────────────┘   │  │
│  └───────────────────────────────┘  │
└─────────────────────────────────────┘
```

**重要區別：**
- **Ghostty 快捷鍵**：`Cmd+...`（macOS 原生控制）
- **Tmux 快捷鍵**：`Ctrl+Space ...`（Tmux prefix）

---

## 快速開始

### 第一次使用

1. **安裝配置**
   ```bash
   cd ~/Documents/GitHub/VibeGhostty/tmux
   bash install.sh
   ```

2. **啟動工作空間**
   ```bash
   tmux-launch
   ```

3. **選擇布局**
   - 選項 1：AI Workspace（推薦新手）
   - 輸入專案目錄或按 Enter 使用當前目錄

4. **開始使用**
  - 左側 Codex pane（手動啟動或由 vibe-start 自動注入）
  - 右上 Claude pane（手動啟動或由 vibe-start 自動注入）
   - 右下 Monitor pane 顯示使用提示

### 日常使用流程

```bash
# 早上開始工作
tmux-launch              # 啟動選單
# → 選擇 "4. Resume" 恢復昨天的 session

# 中途需要暫時離開
Ctrl+Space d             # Detach（session 繼續在背景執行）

# 回來繼續工作
tmux attach              # 連接回最近的 session

# 下班前
Ctrl+Space : kill-session  # 結束當天工作
```

---

## 布局說明

### 1. AI Workspace（主要工作模式）

**適用場景：**
- 日常開發工作
- 需要 AI 輔助編碼
- 同時監控測試或日誌

**布局設計：**
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

**啟動方式：**
```bash
# 方法 1：互動式
tmux-launch
# → 選擇 1

# 方法 2：直接啟動
~/.tmux-layouts/ai-workspace.sh

# 方法 3：指定專案目錄
~/.tmux-layouts/ai-workspace.sh ~/my-project
```

> 換好布局後，pane 會保留空白，請在各 pane 手動輸入 `codex`、`claude` 或測試指令。若想自動注入命令，可直接使用 `vibe-start`。

**快速跳轉：**
- `Ctrl+Space 1` → Codex CLI
- `Ctrl+Space 2` → Claude Code
- `Ctrl+Space 3` → Monitor

**使用技巧：**

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

### 2. AI Split（比較模式）

**適用場景：**
- 比較兩個 AI 的解決方案
- 評估不同實作方式
- 學習 AI 思考差異

**布局設計：**
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

**啟動方式：**
```bash
~/.tmux-layouts/ai-split.sh
```

> Pane 預留給左右兩個 AI 工具，由使用者自行啟動。若需自動將命令輸入 panes，可使用 `vibe-start --mode debug` 或 `--mode review`。

**使用場景範例：**

**範例 1：演算法比較**
```
問題：「實作一個高效的陣列去重函式」

Codex 回答：
  → 使用 Set 方法（簡潔）

Claude 回答：
  → 使用 filter + indexOf（相容性好）

在 Compare pane：
  → 執行效能測試
  → 比較不同資料量的表現
  → 決定最適合的方案
```

**範例 2：API 設計**
```
問題：「設計一個 RESTful API 處理使用者認證」

比較重點：
  - API 端點命名
  - 錯誤處理方式
  - 安全性考量
  - 程式碼組織結構
```

---

### 3. Full Focus（專注模式）

**適用場景：**
- 深度思考複雜問題
- 減少視覺干擾
- 長時間與單一 AI 對話

**布局設計：**
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

**啟動方式：**
```bash
# 預設使用 Codex
~/.tmux-layouts/full-focus.sh

# 指定使用 Claude
~/.tmux-layouts/full-focus.sh ~/my-project claude
```

**專注模式哲學：**

單一 AI、單一任務、深度思考。適合：
- 學習新概念
- 解決複雜 bug
- 架構設計討論
- 程式碼深度重構

**需要分割時：**
```bash
# 在 Focus 模式中，隨時可以分割
Ctrl+Space |    # 垂直分割
Ctrl+Space -    # 水平分割
```

---

## 快捷鍵速查表

### Ghostty 終端控制（第一層）

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+T` | 新分頁 | Ghostty 原生分頁 |
| `Cmd+W` | 關閉分頁 | 關閉當前 Ghostty 分頁 |
| `Cmd+1~9` | 切換分頁 | 切換 Ghostty 分頁 |
| `Cmd+Plus` | 放大字體 | 放大終端字體 |
| `Cmd+Minus` | 縮小字體 | 縮小終端字體 |
| `Cmd+Q` | 退出 Ghostty | 關閉整個終端 |

### Tmux 基礎控制（第二層）

**重要：所有 Tmux 快捷鍵都要先按 `Ctrl+Space`（prefix）**

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space r` | 重新載入配置 | 修改 .tmux.conf 後使用 |
| `Ctrl+Space d` | Detach session | 暫時離開（session 保留） |
| `Ctrl+Space :` | 命令模式 | 輸入 tmux 命令 |
| `Ctrl+Space ?` | 顯示所有快捷鍵 | 查看完整按鍵列表 |

### Pane 管理（面板控制）

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space \|` | 垂直分割 | 左右分割（記：\| 是垂直線）|
| `Ctrl+Space -` | 水平分割 | 上下分割（記：- 是水平線）|
| `Ctrl+Space x` | 關閉 pane | 需確認 |
| `Ctrl+Space z` | 縮放 pane | 全屏/還原（toggle） |

### Vim-Style 導航

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space h` | 移到左側 pane | Vim 左鍵 |
| `Ctrl+Space j` | 移到下方 pane | Vim 下鍵 |
| `Ctrl+Space k` | 移到上方 pane | Vim 上鍵 |
| `Ctrl+Space l` | 移到右側 pane | Vim 右鍵 |

### 快速跳轉

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space 1` | 跳到 Pane 0 | Codex pane（手動或 vibe-start） |
| `Ctrl+Space 2` | 跳到 Pane 1 | Claude pane（手動或 vibe-start） |
| `Ctrl+Space 3` | 跳到 Pane 2 | Monitor / 測試 |
| `Ctrl+Space 4` | 跳到 Pane 3 | 如果有第 4 個 pane |
| `Ctrl+Space 5` | 跳到 Pane 4 | 如果有第 5 個 pane |

### Pane 大小調整

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space H` | 向左擴展 | Shift+h（大寫） |
| `Ctrl+Space J` | 向下擴展 | Shift+j（大寫） |
| `Ctrl+Space K` | 向上擴展 | Shift+k（大寫） |
| `Ctrl+Space L` | 向右擴展 | Shift+l（大寫） |

**提示：** 按住 Shift 的 hjkl 是調整大小

### Copy Mode（複製模式）

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space [` | 進入 copy mode | 可捲動歷史記錄 |
| `v` | 開始選取 | 類似 Vim visual mode |
| `y` | 複製選取內容 | 複製到系統剪貼簿 |
| `q` | 離開 copy mode | 回到正常模式 |
| `Ctrl+v` | 矩形選取 | 選取方塊區域 |

**Copy Mode 中的移動：**
- `h/j/k/l` - 游標移動
- `w/b` - 前後移動一個單字
- `0/$` - 行首/行尾
- `g/G` - 檔案開頭/結尾
- `/` - 搜尋

### Session 管理

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space s` | 列出 sessions | 選擇要切換的 session |
| `Ctrl+Space $` | 重新命名 session | 修改當前 session 名稱 |
| `Ctrl+Space (` | 切換到上一個 session | 快速切換 |
| `Ctrl+Space )` | 切換到下一個 session | 快速切換 |

---

## 進階使用

### 自訂 Pane 標題

```bash
# 在 tmux 中執行
Ctrl+Space : select-pane -T "🚀 New Title"

# 範例：設定 monitor pane 為「測試執行中」
Ctrl+Space 3                                  # 跳到 monitor pane
Ctrl+Space : select-pane -T "🧪 Testing"     # 設定標題
npm test --watch                              # 執行測試
```

### 多 Session 工作流程

**場景：同時處理多個專案**

```bash
# 建立專案 A 的 workspace
~/.tmux-layouts/ai-workspace.sh ~/projects/project-a

# Detach（Ctrl+Space d）

# 建立專案 B 的 workspace
~/.tmux-layouts/ai-workspace.sh ~/projects/project-b

# Detach

# 隨時切換
tmux attach -t ai-project-a
tmux attach -t ai-project-b

# 或使用快捷鍵列表
Ctrl+Space s    # 顯示 session 列表，上下鍵選擇
```

### Session 持久化（Tmux Resurrect）

**自動保存設定：** 每 15 分鐘自動儲存

**手動操作：**

```bash
# 手動儲存當前所有 sessions
Ctrl+Space Ctrl+s

# 手動恢復所有 sessions
Ctrl+Space Ctrl+r
```

**儲存內容包含：**
- 所有 sessions、windows、panes 的布局
- 每個 pane 的工作目錄
- 每個 pane 正在執行的程式（如 vim、less）
- Pane 標題

**實際應用：**

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

### 日誌記錄（Tmux Logging）

**功能：** 記錄 pane 中的所有輸出

```bash
# 開始記錄當前 pane
Ctrl+Space Shift+P    # 開始記錄

# 停止記錄
Ctrl+Space Shift+P    # 再按一次停止

# 日誌存放位置
~/.tmux/logs/
```

**使用場景：**

1. **記錄測試輸出**
   ```bash
   Ctrl+Space 3          # 跳到 monitor pane
   Ctrl+Space Shift+P    # 開始記錄
   npm test              # 執行測試
   # 測試完成
   Ctrl+Space Shift+P    # 停止記錄
   ```

2. **記錄 AI 對話**
   - 保存完整的 AI 回答
   - 稍後分析或分享

### 腳本化工作流程

**建立自己的自訂布局：**

```bash
# 創建新的布局腳本
vim ~/.tmux-layouts/my-custom-layout.sh
```

範例腳本：
```bash
#!/usr/bin/env bash
set -e

SESSION_NAME="my-layout"
PROJECT_DIR="${1:-$PWD}"

tmux new-session -d -s "$SESSION_NAME" -c "$PROJECT_DIR"

# Pane 0: 編輯器
tmux select-pane -t 0 -T "📝 Editor"
tmux send-keys -t "$SESSION_NAME:0.0" "nvim ." C-m

# Pane 1: Git 狀態
tmux split-window -h -p 30 -t "$SESSION_NAME:0" -c "$PROJECT_DIR"
tmux select-pane -t 1 -T "🌳 Git"
tmux send-keys -t "$SESSION_NAME:0.1" "git status" C-m

# Pane 2: Server
tmux split-window -v -p 50 -t "$SESSION_NAME:0.1" -c "$PROJECT_DIR"
tmux select-pane -t 2 -T "🚀 Server"
tmux send-keys -t "$SESSION_NAME:0.2" "npm run dev" C-m

tmux select-pane -t 0
tmux attach-session -t "$SESSION_NAME"
```

記得加執行權限：
```bash
chmod +x ~/.tmux-layouts/my-custom-layout.sh
```

---

## 常見問題

### Q1: Tmux 和 Ghostty 分頁有什麼不同？

**A:**
- **Ghostty 分頁**：完全獨立的終端環境，關閉就消失
- **Tmux Session**：可以 detach 和 attach，關閉 Ghostty 也不影響

**最佳實踐：**
- 使用 Tmux sessions 管理專案工作空間
- Ghostty 分頁用於完全不同的工作（如系統管理、監控）

### Q2: 如果 Tmux 當掉了怎麼辦？

**A:**
1. **自動恢復**：tmux-continuum 每 15 分鐘自動儲存
   ```bash
   tmux                 # 重新啟動
   Ctrl+Space Ctrl+r    # 恢復 sessions
   ```

2. **最壞情況**：
   - 最多損失 15 分鐘內的變更
   - AI 對話記錄仍在（Codex/Claude 有自己的歷史）
   - 程式碼變更在 git（應該經常 commit）

### Q3: 為什麼選擇 Ctrl+Space 而不是 Ctrl+B？

**A:**
- **人體工學**：Space 比 B 更容易按到
- **避免衝突**：Ctrl+B 在很多編輯器中是「向上翻頁」
- **單手操作**：Ctrl+Space 可以單手按

### Q4: 可以在 Tmux 中使用滑鼠嗎？

**A:**
可以！配置中已啟用滑鼠支援：
- 點擊切換 pane
- 拖拽調整 pane 大小
- 滾輪捲動歷史記錄
- 在 copy mode 中選取文字

### Q5: 如何完全退出所有 sessions？

**A:**
```bash
# 方法 1：在 tmux 外
tmux kill-server

# 方法 2：在 tmux 內
Ctrl+Space : kill-server

# 方法 3：只殺當前 session
Ctrl+Space : kill-session
```

### Q6: AI CLI 沒有自動啟動？

**A:**
預設布局腳本只建立 panes，不會自動啟動任何 AI CLI。這樣可以避免登入流程或多帳號造成衝突。請切換到對應 pane 後，手動輸入：

```bash
codex     # 左側 pane
claude    # 右側 pane
```

想要自動注入指令？使用 `vibe-start`：

```bash
vibe-start --yes          # 偵測專案並自動啟動
vibe-start --mode debug   # 左右兩側 AI + 底部比對 pane
```

`vibe-start` 會在啟動前顯示預覽，並確保命令與 pane 對齊。

### Q7: 顏色看起來不對？

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

### Q8: 如何在 Pane 之間複製貼上？

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

### Q9: Session 名稱太長了？

**A:**
```bash
# 重新命名當前 session
Ctrl+Space $
# 輸入新名稱，如 "ai"
```

或在創建時就用簡短名稱：
```bash
tmux new -s ai    # 創建名為 "ai" 的 session
```

### Q10: 如何在 Tmux 中使用 Vim/Neovim？

**A:**

完全相容！配置中已經考慮 Vim 使用者：

```bash
# 正常啟動 Vim
vim file.txt

# Copy mode 使用 Vim 快捷鍵
Ctrl+Space [    # hjkl 移動、w/b 跳字、/ 搜尋
```

**額外設定（選用）：**

如果你在 Vim 中也想用 Ctrl+Space：
```vim
" 在 ~/.vimrc 中
" 將 Ctrl+Space 映射為 Esc
inoremap <C-Space> <Esc>
```

---

## 最佳實踐

### 1. Session 命名策略

**按專案命名：**
```bash
ai-vibeghostty
ai-blog
ai-api-server
```

**按功能命名：**
```bash
learning-rust
debugging-auth
experiment-ai
```

**按客戶/公司命名：**
```bash
client-projecta
internal-tools
```

### 2. Pane 使用模式

**3-Pane 標準布局：**
```
主工作區（70%） | 輔助區（30%）
                | ─────────────
                | 監控區（30%）
```

**各 Pane 的角色：**

| Pane | 角色 | 常駐內容 |
|------|------|----------|
| 主工作區 | 主要 AI 對話 | Codex CLI 或 Claude |
| 輔助區 | 第二意見、審查 | 另一個 AI 或文檔 |
| 監控區 | 即時回饋 | 測試、日誌、git status |

### 3. 工作流程建議

**早上開始：**
```bash
1. tmux-launch
2. 選擇 "Resume" 恢復昨天
3. 檢查 monitor pane 的測試狀態
4. git status 確認進度
```

**開發新功能：**
```bash
1. git checkout -b feature/new-feature
2. Ctrl+Space 1 → Codex：「我想實作...」
3. Ctrl+Space 2 → Claude：「審查這個設計」
4. Ctrl+Space 3 → 執行測試
5. 循環直到完成
```

**Debug 問題：**
```bash
1. Ctrl+Space 3 → tail -f error.log
2. Ctrl+Space 1 → Codex：分析錯誤
3. Ctrl+Space 2 → Claude：提供替代方案
4. 在 monitor 觀察修復效果
```

**下班前：**
```bash
1. git add . && git commit
2. Ctrl+Space Ctrl+s    # 手動儲存 tmux
3. Ctrl+Space d         # Detach（保留 session）
```

### 4. 效能優化

**減少 Pane 數量：**
- 不要超過 5 個 panes
- 太多會降低可讀性
- 使用 window 分組不同任務

**善用 Zoom：**
```bash
Ctrl+Space z    # 暫時全屏當前 pane
# 工作完成
Ctrl+Space z    # 還原布局
```

**記憶體管理：**
```bash
# 限制歷史記錄（已在 .tmux.conf 設定為 50000）
set -g history-limit 50000

# 定期清理不用的 sessions
tmux kill-session -t old-project
```

### 5. 與 Git 整合

**Monitor Pane 的黃金組合：**
```bash
# 在 monitor pane 中
watch -n 2 -c 'git status --short && echo "---" && git log --oneline -5'
```

**Git 工作流程：**
```bash
# 主工作區：編碼
Ctrl+Space 1 → Codex 生成程式碼

# 輔助區：審查
Ctrl+Space 2 → Claude 審查 commit

# 監控區：Git 狀態
Ctrl+Space 3 → git diff
```

### 6. 學習與實驗

**建立實驗 Session：**
```bash
~/.tmux-layouts/full-focus.sh ~/experiments claude
```

用途：
- 學習新技術
- 實驗性想法
- 不影響主專案的安全環境

**比較學習法：**
```bash
~/.tmux-layouts/ai-split.sh ~/learning
```

同時問兩個 AI 相同的學習問題，比較：
- 解釋方式
- 範例程式碼
- 學習路徑建議

---

## 故障排除

### 問題 1：無法啟動 Tmux

**症狀：**
```bash
$ tmux
tmux: command not found
```

**解決：**
```bash
# 安裝 tmux
brew install tmux

# 驗證安裝
tmux -V
```

---

### 問題 2：配置沒有生效

**症狀：** 修改 `~/.tmux.conf` 後沒有變化

**解決：**
```bash
# 方法 1：在 tmux 內重新載入
Ctrl+Space r

# 方法 2：在 tmux 外
tmux source-file ~/.tmux.conf

# 方法 3：重啟 tmux
tmux kill-server
tmux
```

---

### 問題 3：Plugin 無法安裝

**症狀：** 按 `Ctrl+Space I` 沒有反應

**解決：**
```bash
# 手動安裝 TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 重啟 tmux
tmux kill-server
tmux

# 再次嘗試
Ctrl+Space I
```

---

### 問題 4：顏色顯示錯誤

**症狀：** 主題顏色不對，或看到奇怪的字元

**診斷：**
```bash
# 檢查 TERM 變數
echo $TERM
# 應該是 screen-256color 或 tmux-256color

# 檢查真彩色支援
printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"
```

**解決：**
```bash
# 在 ~/.tmux.conf 確認有這行
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# 重新載入
Ctrl+Space r
```

---

### 問題 5：Pane 標題不顯示 Emoji

**症狀：** 看到 ? 或方塊而不是 emoji

**解決：**

1. **確認 Ghostty 字體支援 emoji**
   - 檢查 Ghostty config：`font-family = "SF Mono"`
   - 或安裝 Nerd Font：`brew tap homebrew/cask-fonts && brew install font-hack-nerd-font`

2. **更新 Ghostty 配置**
   ```
   font-family = "Hack Nerd Font"
   ```

---

### 問題 6：Session 無法恢復

**症狀：** `Ctrl+Space Ctrl+r` 沒有恢復任何東西

**診斷：**
```bash
# 檢查 resurrect 檔案
ls ~/.tmux/resurrect/
```

**解決：**
```bash
# 確認 plugin 已安裝
ls ~/.tmux/plugins/tmux-resurrect

# 如果不存在，安裝 plugins
Ctrl+Space I

# 手動儲存一次測試
Ctrl+Space Ctrl+s
```

---

### 問題 7：快捷鍵衝突

**症狀：** 某些快捷鍵不工作，或有意外行為

**常見衝突：**

| 快捷鍵 | 可能衝突的程式 | 解決方案 |
|--------|---------------|---------|
| `Ctrl+Space` | IDE、Vim | 改用 `Ctrl+A`（修改 .tmux.conf）|
| `Ctrl+h/j/k/l` | Vim、Neovim | 使用 vim-tmux-navigator plugin |

**更改 prefix key：**
```bash
# 在 ~/.tmux.conf
unbind C-Space
set -g prefix C-a
bind C-a send-prefix
```

---

### 問題 8：滑鼠滾輪不工作

**症狀：** 滾輪無法捲動歷史記錄

**解決：**
```bash
# 確認 ~/.tmux.conf 有這行
set -g mouse on

# 重新載入
Ctrl+Space r
```

---

### 問題 9：Copy mode 複製到系統剪貼簿失敗

**症狀：** 在 tmux 中複製後，無法在其他程式貼上

**macOS 解決：**
```bash
# 安裝 reattach-to-user-namespace
brew install reattach-to-user-namespace

# 在 ~/.tmux.conf 加入
set -g default-command "reattach-to-user-namespace -l $SHELL"

# 重新載入
Ctrl+Space r
```

**或使用滑鼠：**
- 用滑鼠選取文字
- `Cmd+C` 複製（macOS 原生）

---

### 問題 10：AI CLI 在 Tmux 中行為異常

**症狀：** Codex 或 Claude 在 tmux 中顯示不正常

**診斷：**
```bash
# 在 tmux 外測試
codex
claude

# 在 tmux 內測試
tmux
codex
```

**可能原因：**

1. **TERM 變數問題**
   ```bash
   # 在 tmux 內檢查
   echo $TERM
   # 應該是 screen-256color
   ```

2. **Path 問題**
   ```bash
   # 確認在 tmux 內可以找到
   which codex
   which claude
   ```

3. **Shell 初始化問題**
   ```bash
   # 確保 .zshrc 或 .bashrc 正確載入
   echo $PATH | grep local
   ```

---

### 問題 11：布局腳本執行失敗

**症狀：**
```bash
$ ~/.tmux-layouts/ai-workspace.sh
bash: permission denied
```

**解決：**
```bash
# 設定執行權限
chmod +x ~/.tmux-layouts/*.sh
chmod +x ~/.local/bin/tmux-launch

# 驗證
ls -la ~/.tmux-layouts/
```

---

### 問題 12：Session 名稱衝突

**症狀：** 腳本說 session 已存在，但找不到

**解決：**
```bash
# 列出所有 sessions
tmux list-sessions

# 找到衝突的 session
tmux kill-session -t ai-work

# 或殺掉所有
tmux kill-server
```

---

### 緊急重置

如果一切都出問題，完整重置：

```bash
# 1. 備份當前配置
cp ~/.tmux.conf ~/.tmux.conf.backup.$(date +%Y%m%d)

# 2. 停止所有 tmux
tmux kill-server

# 3. 清理 tmux 目錄
rm -rf ~/.tmux/

# 4. 重新安裝
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh

# 5. 啟動測試
tmux-launch
```

---

## 更多資源

### 官方文檔

- **Tmux 官方**: https://github.com/tmux/tmux/wiki
- **Tmux Cheat Sheet**: https://tmuxcheatsheet.com/
- **TPM Plugin Manager**: https://github.com/tmux-plugins/tpm

### 進階學習

- **Tmux Book**: "tmux 2: Productive Mouse-Free Development" by Brian P. Hogan
- **Vim + Tmux**: https://github.com/christoomey/vim-tmux-navigator

### VibeGhostty 相關

- **Ghostty 配置**: `~/Documents/GitHub/VibeGhostty/config`
- **快速開始**: `~/Documents/GitHub/VibeGhostty/QUICKSTART_TMUX.md`
- **專案摘要**: `~/Documents/GitHub/VibeGhostty/PROJECT_SUMMARY.md`

---

## 意見回饋

這是一個為 Frank Yang 量身打造的工具。如果有任何問題、建議或改進想法：

1. 在專案中提 issue
2. 直接修改配置文件並分享你的改進
3. 記錄你的工作流程，幫助改進工具

---

**版本：** 1.0.0
**最後更新：** 2025-10-17
**作者：** Claude Code for Frank Yang
**授權：** MIT

---

祝你使用愉快！🚀 享受多 AI 協作的強大工作流程！
