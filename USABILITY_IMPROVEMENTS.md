# VibeGhostty 易用性改善指南

> 解決「命令太多、難記憶」問題的完整方案

## 📊 問題分析

### 原始狀況

```
Ghostty:  16 個快捷鍵
Tmux:     15+ 個快捷鍵
腳本:     3 個布局腳本名稱
─────────────────────────────
總計:     30+ 個命令需要記憶
```

**核心問題**：
- 認知負擔過重，使用者難以記住所有快捷鍵
- 重複功能（Ghostty split vs Tmux split）造成混淆
- 腳本名稱不直觀，需要查文檔才能使用

---

## ✨ 改善方案（三層架構）

### 🎯 方案 1：視覺化提示（不用記！）

#### 1.1 Tmux Status Bar 快捷鍵提示

在 Tmux 底部永久顯示最常用的快捷鍵：

```
?:help | r:reload | |:vsplit | -:hsplit    🚀 Session    HH:MM  YYYY-MM-DD
```

**使用方式**：
- 啟動 Tmux 後自動顯示
- 隨時可見，不需要記憶

#### 1.2 內建幫助系統

**在 Tmux 內按 `Ctrl+Space ?` 顯示完整快捷鍵表**

```
╔════════════════════════════════════════════════════════════╗
║         VibeGhostty 快捷鍵速查表 (Cheatsheet)             ║
╠════════════════════════════════════════════════════════════╣
║  【Ghostty 快捷鍵】（macOS 原生，直接使用）               ║
║    Cmd + T          新建 Tab                              ║
║    Cmd + 1/2/3      跳轉到 Tab 1/2/3（最常用）           ║
║    Cmd + D          向右分割視窗                          ║
║  ...                                                       ║
╚════════════════════════════════════════════════════════════╝
```

**特點**：
- 彈出視窗顯示，不干擾工作區
- 分類清晰（Ghostty / Tmux / 工作流程）
- 按任意鍵關閉

#### 1.3 獨立速查命令

**在任何終端執行 `vibe-help` 查看快捷鍵**

```bash
vibe-help
```

**特點**：
- 彩色輸出，易於閱讀
- 強調最常用的 5 個快捷鍵
- 包含工作流程範例
- 不需要在 Tmux 環境內也能使用

---

### 🎯 方案 2：精簡模式（只記 8 個核心快捷鍵）

#### 2.1 使用精簡版配置

**適合新手或不想記太多快捷鍵的使用者**

```bash
# 使用精簡版配置
cp config.minimal ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 重新載入 Ghostty
# 按 Cmd+Shift+Comma 或重啟應用
```

#### 2.2 精簡版快捷鍵列表（只有 8 個！）

```
核心操作（最常用的 3 個）：
  Cmd+T         新 Tab（開始新任務）
  Cmd+1/2/3     快速切換 Tab（最常用！）
  Cmd+D         並排分割（比較 AI 輸出）

其他快捷鍵：
  Cmd+W         關閉 Tab
  Cmd+Shift+T   新視窗
  Cmd+Shift+,   重新載入配置
```

**優勢**：
- 減少 50% 的快捷鍵數量（16 個 → 8 個）
- 專注於最高頻使用的功能
- 移除重複和低頻功能

#### 2.3 工作流程範例

**只用 3 個快捷鍵就能完成 AI 協作**：

```
1. Cmd+T → 開新 Tab → 啟動 Claude Code
2. Cmd+T → 再開一個 → 啟動 Codex CLI
3. Cmd+1/Cmd+2 → 快速切換
4. （可選）Cmd+D → 並排比較
```

---

### 🎯 方案 3：互動式操作（完全不用背！）

#### 3.1 互動式布局啟動器

**執行 `tmux-launch` 使用選單操作**：

```bash
tmux-launch
```

顯示互動式選單：

```
════════════════════════════════════════════
   🚀 Tmux AI Workspace Launcher
════════════════════════════════════════════

請選擇布局:
  1) AI Workspace  - 主要工作模式（70/30）
  2) AI Split    - 並排比較模式（50/50）
  3) Full Focus    - 全屏專注模式
  4) Resume        - 恢復上次會話
  q) Quit

選擇 [1-4, q]:
```

**優勢**：
- 不需要記腳本名稱
- 視覺化選項說明
- 支援 fzf 快速搜尋（如果已安裝）

#### 3.2 自動化常用操作

**建立自己的快速啟動別名**：

在 `~/.zshrc` 加入：

```bash
# VibeGhostty 快速啟動
alias cai='tmux-launch'                  # 啟動選單
alias workspace='~/.tmux-layouts/ai-workspace.sh'
alias compare='~/.tmux-layouts/ai-split.sh'
alias focus='~/.tmux-layouts/full-focus.sh'
alias keys='vibe-help'                   # 查看快捷鍵
```

之後只需要輸入：
- `workspace` → 啟動 AI 工作空間
- `keys` → 查看所有快捷鍵

---

### 🎯 方案 4：智能 Session 管理（ta 命令）

#### 4.1 超快速 Attach（只需 2 個字元！）

**問題**：每次都要輸入 `tmux attach -t ai-VibeGhostty` 太冗長

**解決方案**：使用 `ta` 命令智能偵測專案

```bash
cd ~/projects/VibeGhostty
ta    # 自動 attach 到 ai-VibeGhostty session
```

#### 4.2 核心功能

**自動專案偵測**：
```bash
# 在 git repo 目錄
cd ~/projects/VibeGhostty
ta    # 自動偵測 → attach 到 ai-VibeGhostty

# 在非 git 目錄
cd ~/my-project
ta    # 自動偵測 → attach 到 ai-my-project
```

**智能 Session 管理**：
- Session 存在 → 直接 attach
- Session 不存在 → 詢問是否建立新 AI Workspace
- 已在 tmux 內 → 自動使用 `switch-client`（不會巢狀 tmux）

**列出所有 Session**：
```bash
ta -l    # 查看所有可用的 tmux session
```

輸出範例：
```
📋 可用的 Tmux Sessions:

  ● ai-VibeGhostty (1 windows, attached)
  ○ ai-another-project (2 windows)
  ○ ai-test (1 window)
```

**指定 Session 名稱**：
```bash
ta -n ai-test    # 直接 attach 到指定 session
```

#### 4.3 使用範例

**場景 1：Session 存在**
```bash
$ cd ~/projects/VibeGhostty
$ ta
✅ 連接到 session 'ai-VibeGhostty'...
[進入 tmux session]
```

**場景 2：Session 不存在**
```bash
$ cd ~/projects/new-project
$ ta
⚠️  Session 'ai-new-project' 不存在

是否使用 AI Workspace 布局建立新 session？
布局：左側 Codex (70%) + 右側 Claude/Monitor (30%)

確認建立？ [Y/n]: y

🚀 正在建立 AI Workspace...
✅ Session 建立完成！
[進入 tmux session]
```

**場景 3：在 tmux 內切換**
```bash
# 已經在 ai-project1 session 內
$ ta -n ai-project2
✅ 切換到 session 'ai-project2'...
[無縫切換，不會建立巢狀 tmux]
```

#### 4.4 命令參考

```bash
ta              # 自動偵測當前專案並 attach
ta -l           # 列出所有 tmux session
ta --list       # 同上
ta -n NAME      # attach 到指定 session
ta --name NAME  # 同上
ta -h           # 顯示幫助
ta --help       # 同上
```

#### 4.5 優勢

**效率提升**：
- 從 `tmux attach -t ai-VibeGhostty`（32 字元）
- 降到 `ta`（2 字元）
- **節省 93% 的輸入量！**

**智能化**：
- 自動偵測專案名稱（git repo 或目錄名）
- 自動判斷是否在 tmux 內（避免巢狀）
- 自動提示建立新 session

**人性化**：
- 彩色輸出，清楚易讀
- 友善的錯誤提示
- 完整的幫助系統

---

## 📋 快速參考卡

### 最小記憶集（只需記住這些！）

```
┌─────────────────────────────────────────┐
│  核心快捷鍵（最常用的 6 個）            │
├─────────────────────────────────────────┤
│  ta                  快速 attach        │
│  Cmd + T             開新 Tab           │
│  Cmd + 1/2/3         快速切換           │
│  Cmd + D             並排分割           │
│  Ctrl+Space ?        查看幫助           │
│  vibe-help           終端查看快捷鍵     │
└─────────────────────────────────────────┘
```

### 忘記快捷鍵時

```
方法 1: 在 Tmux 內按 Ctrl+Space ?
方法 2: 終端執行 vibe-help
方法 3: 查看 Status Bar 底部提示
方法 4: 查看 GUIDE.md 文檔
```

---

## 🚀 實際使用建議

### 新手路徑

**第一週：只用 Ghostty**
```
1. 只記 Cmd+T 和 Cmd+1/2/3
2. 用 Tab 分離不同任務
3. 不使用 Tmux，降低學習曲線
```

**第二週：加入分割視窗**
```
1. 學習 Cmd+D 並排分割
2. 比較 AI 輸出更方便
3. 依然不用 Tmux
```

**第三週：嘗試 Tmux**
```
1. 執行 tmux-launch 啟動預設布局
2. 只記 Ctrl+Space ? 查看幫助
3. 遇到問題執行 vibe-help
```

### 進階使用者路徑

**精通 Ghostty + 基本 Tmux**
```
1. 使用完整版 config（16 個快捷鍵）
2. 記住 Tmux 核心操作（|, -, h/j/k/l, z）
3. 自訂布局腳本
```

**完全自訂**
```
1. 修改 tmux.conf 加入自己的快捷鍵
2. 建立新的布局腳本
3. 整合其他工具（Neovim, fzf 等）
```

---

## 📊 改善效果對比

### 改善前

```
問題：
  ❌ 30+ 個命令需要記憶
  ❌ 沒有視覺提示，完全靠記憶
  ❌ 忘記快捷鍵需要查文檔（打斷工作流程）
  ❌ 新手學習曲線陡峭

使用體驗：
  😓 經常忘記快捷鍵
  😓 需要頻繁查閱文檔
  😓 認知負擔重，影響專注
```

### 改善後

```
改善：
  ✅ 精簡模式只需記 8 個核心快捷鍵
  ✅ Status Bar 永久顯示提示
  ✅ Ctrl+Space ? 隨時查看完整幫助
  ✅ vibe-help 命令快速參考
  ✅ tmux-launch 互動式選單
  ✅ ta 命令智能 session 管理（節省 93% 輸入）

使用體驗：
  😊 不需要背命令也能順暢使用
  😊 視覺提示隨時可見
  😊 新手友善，學習曲線平緩
  😊 進階用戶也能完全自訂
  😊 2 個字元快速切換專案
```

### 認知負擔降低

```
記憶需求：
  改善前: 30+ 個命令 → 😓 認知負擔重
  改善後: 5 個核心 + 視覺輔助 → 😊 輕鬆使用

查閱頻率：
  改善前: 每天 10+ 次查文檔
  改善後: 第一週 2-3 次，之後幾乎不需要
```

---

## 🛠️ 安裝改善功能

### 自動安裝（推薦）

```bash
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh
```

安裝腳本會自動：
- 複製 vibe-help 到 ~/.local/bin/
- 設定執行權限
- 更新 PATH（如需要）
- 安裝 Tmux 配置（包含 status bar 提示）

### 手動安裝

```bash
# 1. 複製 vibe-help
cp tmux/bin/vibe-help ~/.local/bin/vibe-help
chmod +x ~/.local/bin/vibe-help

# 2. 更新 PATH（如果 ~/.local/bin 不在 PATH 中）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 3. 使用精簡版 Ghostty 配置（可選）
cp config.minimal ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 4. 重新載入 Ghostty
# 按 Cmd+Shift+Comma 或重啟應用

# 5. 更新 Tmux 配置
cp tmux/tmux.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf
```

---

## 🎓 學習資源

### 文檔優先級

**第一步：基礎快速開始**
1. `QUICKSTART.md` - 5 分鐘快速安裝
2. `USABILITY_IMPROVEMENTS.md` - 本文檔

**第二步：進階使用**
3. `GUIDE.md` - Ghostty 詳細使用指南
4. `QUICKSTART_TMUX.md` - Tmux 快速開始

**第三步：完整掌握**
5. `TMUX_GUIDE.md` - Tmux 完整指南
6. `config` - 完整版配置檔案

### 視覺化學習資源

**命令行工具**：
- `vibe-help` - 快捷鍵速查表
- `tmux-launch` - 互動式選單
- `Ctrl+Space ?` - Tmux 內建幫助

**配置檔案**：
- `config` - 完整版（16 個快捷鍵）
- `config.minimal` - 精簡版（8 個快捷鍵）

---

## 💡 常見問題

### Q: 我應該用完整版還是精簡版配置？

**建議**：
- **新手**：先用精簡版（`config.minimal`），只需記 8 個快捷鍵
- **有經驗的使用者**：用完整版（`config`），功能更強大
- **進階用戶**：自訂配置，整合 Tmux 和其他工具

### Q: 我還是記不住快捷鍵怎麼辦？

**解決方案**：
1. **完全不用背**：只用 `tmux-launch` 互動式選單
2. **隨時查看**：在 Tmux 內按 `Ctrl+Space ?`
3. **終端查看**：執行 `vibe-help`
4. **視覺提示**：查看 Status Bar 底部提示

### Q: Ghostty 和 Tmux 的快捷鍵衝突怎麼辦？

**設計原則**：
- **Ghostty**：用 `Cmd` 修飾鍵，管理 Tab 和視窗
- **Tmux**：用 `Ctrl+Space` 前綴，管理 Pane 和 Session

**建議**：
- 日常使用 Ghostty 的 `Cmd+數字` 切換就夠了
- Tmux 用於複雜布局和會話保存
- 兩者互補，不衝突

### Q: 我可以自訂快捷鍵嗎？

**完全可以**：
1. 編輯 `config` 或 `~/.tmux.conf`
2. 參考現有快捷鍵的格式
3. 重新載入配置（`Cmd+Shift+,` 或 `Ctrl+Space r`）

---

## 🎉 總結

### 核心改善

✅ **視覺化提示** - Status Bar + 內建幫助系統
✅ **快速參考** - vibe-help 命令隨時查看
✅ **精簡模式** - 只需記 8 個核心快捷鍵
✅ **互動式操作** - tmux-launch 選單系統
✅ **智能管理** - ta 命令 2 字元快速 attach

### 使用建議

🎯 **新手**：用精簡版 + vibe-help + ta，不用背命令
🎯 **進階**：用完整版 + Tmux 布局 + ta，效率最高
🎯 **專家**：自訂配置 + 整合工具鏈 + ta

### 記住這句話

> **你不需要背所有快捷鍵，只需要知道在哪裡查！**
>
> - 快速切換專案：`ta`
> - 忘記了按 `Ctrl+Space ?`
> - 或者執行 `vibe-help`
> - 底部 Status Bar 也有提示

---

**建立日期**: 2025-10-17
**版本**: 1.1.0
**適用配置**: config (完整版) / config.minimal (精簡版)
