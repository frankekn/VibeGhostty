# Tmux AI 工作空間 - 5 分鐘快速開始

> **快速上手指南** - 專為 Frank Yang 打造的多 AI Agent 協作終端

---

## 🚀 安裝（2 分鐘）

### 步驟 1：執行安裝腳本

```bash
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh
```

**腳本會自動：**
- ✅ 檢查並安裝 Tmux
- ✅ 安裝 TPM（Plugin Manager）
- ✅ 複製所有配置文件
- ✅ 設定執行權限
- ✅ 更新 PATH（如需要）

### 步驟 2：重新載入 Shell

```bash
source ~/.zshrc
# 或
source ~/.bashrc
```

### 步驟 3：測試安裝

```bash
tmux -V          # 應該顯示 tmux 版本
tmux-launch      # 啟動選單
```

**看到選單就表示安裝成功！** 🎉

---

## 🎯 第一次使用（3 分鐘）

### 啟動工作空間

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
  2 │ AI Compare (比較模式)
  3 │ Full Focus (專注模式)
  4 │ Resume (恢復上次 session)
  q │ Exit (離開)
```

### 選擇布局 1（推薦新手）

按 `1` 然後按 `Enter`

**你會看到：**
```
┌─────────────────────────┬─────────────┐
│   🔧 Codex CLI         │  🤖 Claude  │
│                         │   Code      │
│                         ├─────────────┤
│                         │ 📊 Monitor  │
└─────────────────────────┴─────────────┘
```

**三個 Panes 自動設定完成：**
- **左側**：Codex CLI（自動啟動）
- **右上**：Claude Code（自動啟動）
- **右下**：Monitor（顯示使用提示）

---

## ⌨️ 必學的 5 個快捷鍵

### 1. Prefix Key（所有指令的開頭）

```
Ctrl+Space
```

所有 Tmux 指令都要先按這個！

### 2. 快速跳轉 Panes

```
Ctrl+Space 1    → 跳到 Codex CLI（左側）
Ctrl+Space 2    → 跳到 Claude Code（右上）
Ctrl+Space 3    → 跳到 Monitor（右下）
```

### 3. 暫時離開（Detach）

```
Ctrl+Space d
```

- Session 會繼續在背景執行
- 可以關閉 Ghostty 視窗
- 隨時用 `tmux attach` 回來

### 4. 全屏 Pane（Zoom）

```
Ctrl+Space z
```

- 第一次按：當前 pane 全屏
- 再按一次：還原布局

### 5. 重新載入配置

```
Ctrl+Space r
```

修改配置後使用

---

## 📝 基本使用流程

### 日常開發工作流程

```bash
# 1. 早上開始工作
tmux-launch
選擇 1 (AI Workspace)

# 2. 使用左側 Codex 編碼
Ctrl+Space 1
# 開始對話：「幫我實作一個...」

# 3. 使用右上 Claude 審查
Ctrl+Space 2
# 詢問：「審查這段程式碼...」

# 4. 在右下 Monitor 執行測試
Ctrl+Space 3
npm test --watch

# 5. 需要暫時離開
Ctrl+Space d

# 6. 回來繼續工作
tmux attach

# 7. 下班結束工作
Ctrl+Space :
輸入：kill-session
按 Enter
```

---

## 🎨 三種布局快速參考

### 布局 1：AI Workspace（日常工作）

**何時使用：**
- 日常開發
- 需要 AI 輔助
- 同時監控測試

**特點：**
- Codex CLI 70%（主力）
- Claude Code 30%（輔助）
- Monitor 30%（監控）

**啟動：**
```bash
tmux-launch → 選 1
# 或
~/.tmux-layouts/ai-workspace.sh
```

---

### 布局 2：AI Compare（比較模式）

**何時使用：**
- 比較兩個 AI 的解決方案
- 評估不同實作方式
- 學習 AI 思考差異

**特點：**
- Codex 和 Claude 各 50%
- 下方 25% 比較區

**啟動：**
```bash
tmux-launch → 選 2
# 或
~/.tmux-layouts/ai-compare.sh
```

**使用範例：**
```
問 Codex：實作一個排序函式
問 Claude：實作一個排序函式
在 Compare 區比較兩個實作
```

---

### 布局 3：Full Focus（專注模式）

**何時使用：**
- 深度思考
- 複雜問題
- 減少干擾

**特點：**
- 單一 AI 全屏 100%
- 可選 Codex 或 Claude

**啟動：**
```bash
tmux-launch → 選 3
# 然後選擇 AI：
1) Codex CLI
2) Claude Code
```

---

## 🔧 Monitor Pane 常用指令

Monitor pane（右下）用於即時監控和日誌：

### 測試監控

```bash
# Node.js 專案
npm test --watch
npm run test:watch

# Python 專案
pytest --watch
pytest -f

# 其他
jest --watch
```

### 日誌監控

```bash
# 應用日誌
tail -f app.log
tail -f error.log

# Docker 日誌
docker logs -f container_name

# 系統日誌
tail -f /var/log/system.log
```

### Git 狀態監控

```bash
# 即時 git 狀態
watch -n 2 -c 'git status --short'

# Git 狀態 + 最近 commits
watch -n 2 -c 'git status --short && echo "---" && git log --oneline -5'
```

### 系統監控

```bash
# 系統資源
htop

# Node 程序監控
watch -n 1 "ps aux | grep node"

# 網路連線
watch -n 1 "lsof -i :3000"
```

---

## 💡 實用技巧

### 技巧 1：快速切換 Panes

不用每次都按 `Ctrl+Space`：

```bash
Ctrl+Space 1    # 跳到 Codex
# 工作...
Ctrl+Space 2    # 跳到 Claude
# 工作...
Ctrl+Space 3    # 跳到 Monitor
```

### 技巧 2：Zoom 專注單一 Pane

```bash
Ctrl+Space z    # 全屏當前 pane
# 專心工作...
Ctrl+Space z    # 還原布局
```

### 技巧 3：複製 Pane 中的文字

**方法 1：使用滑鼠（最簡單）**
```
1. 用滑鼠選取文字
2. Cmd+C 複製
3. Cmd+V 貼上
```

**方法 2：使用 Copy Mode**
```
1. Ctrl+Space [    # 進入 copy mode
2. hjkl 移動
3. v 開始選取
4. 移動選取範圍
5. y 複製
6. 到目標位置 Cmd+V 貼上
```

### 技巧 4：調整 Pane 大小

```bash
Ctrl+Space H    # 向左擴展（注意是大寫）
Ctrl+Space J    # 向下擴展
Ctrl+Space K    # 向上擴展
Ctrl+Space L    # 向右擴展
```

**或用滑鼠：**
- 拖曳 pane 邊界調整大小

### 技巧 5：自訂 Pane 標題

```bash
Ctrl+Space :
輸入：select-pane -T "🚀 New Title"
按 Enter
```

範例：
```bash
# 設定 monitor pane 為「測試執行中」
Ctrl+Space 3
Ctrl+Space :
select-pane -T "🧪 Testing"
```

---

## 🆘 遇到問題？

### 問題 1：腳本無法執行

```bash
# 設定執行權限
chmod +x ~/.tmux-layouts/*.sh
chmod +x ~/.local/bin/tmux-launch
```

### 問題 2：tmux-launch 找不到指令

```bash
# 確認 PATH
echo $PATH | grep .local/bin

# 如果沒有，加入 ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### 問題 3：AI CLI 沒有自動啟動

```bash
# 檢查是否安裝
which codex
which claude

# 如果沒安裝，請先安裝 AI CLI
```

### 問題 4：顏色看起來不對

```bash
# 在 tmux 中執行
echo $TERM
# 應該顯示 screen-256color

# 如果不對，重新載入配置
Ctrl+Space r
```

### 問題 5：不知道按了什麼鍵，畫面亂了

```bash
# 萬用恢復大法
Ctrl+Space d        # 離開 session
tmux kill-session   # 殺掉 session
tmux-launch         # 重新啟動
```

---

## 📚 下一步學習

完成快速開始後，建議閱讀：

### 完整指南

```bash
# 查看完整使用指南
cat ~/Documents/GitHub/VibeGhostty/TMUX_GUIDE.md
```

**涵蓋內容：**
- 所有快捷鍵速查表
- 進階使用技巧
- 常見問題完整解答
- 最佳實踐建議

### 實驗建議

1. **第 1 天**：熟悉 AI Workspace 布局
   - 練習在 3 個 panes 間切換
   - 嘗試 zoom 功能

2. **第 2 天**：嘗試其他布局
   - 試用 AI Compare 模式
   - 體驗 Full Focus 專注模式

3. **第 3 天**：學習進階功能
   - 練習 detach 和 attach
   - 使用 copy mode 複製文字
   - 自訂 pane 標題

4. **第 1 週後**：建立個人工作流程
   - 找到最適合的布局
   - 客製化配置
   - 建立自己的腳本

---

## 🎯 快速指令速查卡

**列印或儲存這個部分，方便隨時查看！**

```
╔═══════════════════════════════════════════════════╗
║          Tmux AI 工作空間速查卡                   ║
╚═══════════════════════════════════════════════════╝

【啟動】
tmux-launch              啟動選單
tmux attach              連接最近的 session

【必學快捷鍵】（先按 Ctrl+Space）
1 / 2 / 3               快速跳轉 pane
d                       暫時離開（detach）
z                       全屏/還原當前 pane
r                       重新載入配置
?                       顯示所有快捷鍵

【Pane 控制】
|                       垂直分割
-                       水平分割
x                       關閉當前 pane
h/j/k/l                 Vim 風格移動
H/J/K/L                 調整 pane 大小

【Copy Mode】
[                       進入 copy mode
v                       開始選取
y                       複製
q                       退出 copy mode

【Session 管理】
s                       列出 sessions
$                       重新命名 session
:kill-session           結束當前 session

【緊急恢復】
Ctrl+Space d            離開
tmux kill-server        殺掉所有 sessions
tmux-launch             重新開始
```

---

## ✅ 完成檢查清單

確認你已經學會：

- [ ] 執行安裝腳本
- [ ] 啟動 tmux-launch
- [ ] 啟動 AI Workspace 布局
- [ ] 使用 `Ctrl+Space 1/2/3` 在 panes 間切換
- [ ] 使用 `Ctrl+Space z` zoom pane
- [ ] 使用 `Ctrl+Space d` detach session
- [ ] 使用 `tmux attach` 回到 session
- [ ] 在 Monitor pane 執行測試指令
- [ ] 使用滑鼠複製文字
- [ ] 結束 session

**全部完成？恭喜你已經掌握基礎！** 🎉

---

## 🚀 開始你的 AI 協作之旅

現在你已經準備好了：

```bash
tmux-launch
```

選擇你的布局，開始與 AI agents 協作吧！

**記住：**
- 左側是主要工作區
- 右上是輔助 AI
- 右下是監控區
- `Ctrl+Space` 是所有指令的開頭

---

**版本：** 1.0.0
**作者：** Claude Code for Frank Yang
**完整指南：** `TMUX_GUIDE.md`

祝使用愉快！有問題隨時查閱完整指南 📖
