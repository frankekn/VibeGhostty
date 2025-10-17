# ta 命令使用範例

## 快速開始

### 最常用：自動 attach
```bash
cd ~/projects/VibeGhostty
ta    # 自動偵測並 attach 到 ai-VibeGhostty
```

## 完整使用範例

### 1️⃣ 場景：第一次使用（Session 不存在）

```bash
$ cd ~/projects/new-project
$ ta
⚠️  Session 'ai-new-project' 不存在

是否使用 AI Workspace 布局建立新 session？
布局：左側 Codex (70%) + 右側 Claude/Monitor (30%)

確認建立？ [Y/n]: y

🚀 正在建立 AI Workspace...
✅ Session 建立完成！
[自動進入 tmux session]
```

### 2️⃣ 場景：日常使用（Session 已存在）

```bash
$ cd ~/projects/VibeGhostty
$ ta
✅ 連接到 session 'ai-VibeGhostty'...
[自動進入 tmux session]
```

**效率對比**：
- 傳統方式：`tmux attach -t ai-VibeGhostty` (32 字元)
- ta 命令：`ta` (2 字元)
- **節省 93.75% 輸入！**

### 3️⃣ 場景：查看所有 Session

```bash
$ ta -l
📋 可用的 Tmux Sessions:

  ● ai-VibeGhostty (1 windows, attached)
  ○ ai-another-project (2 windows)
  ○ ai-test (1 window)
  ○ 1 (1 windows)
```

**圖示說明**：
- ● 綠色 = 當前已 attached
- ○ 黃色 = detached

### 4️⃣ 場景：切換到指定 Session

```bash
$ ta -n ai-test
✅ 連接到 session 'ai-test'...
[自動進入 tmux session]
```

### 5️⃣ 場景：在 Tmux 內切換 Session

```bash
# 假設目前在 ai-project1 session 內
$ ta -n ai-project2
✅ 切換到 session 'ai-project2'...
[無縫切換，不會建立巢狀 tmux]
```

**智能偵測**：
- ta 會自動偵測是否已在 tmux 內
- 如果在 tmux 內：使用 `switch-client`
- 如果不在 tmux 內：使用 `attach-session`

### 6️⃣ 場景：取消建立 Session

```bash
$ cd ~/projects/new-project
$ ta
⚠️  Session 'ai-new-project' 不存在

是否使用 AI Workspace 布局建立新 session？
布局：左側 Codex (70%) + 右側 Claude/Monitor (30%)

確認建立？ [Y/n]: n

ℹ️  已取消

📋 可用的 Tmux Sessions:

  ● ai-VibeGhostty (1 windows, attached)
  ○ ai-test (1 window)
```

### 7️⃣ 場景：查看幫助

```bash
$ ta -h
╔════════════════════════════════════════════════════════════╗
║              ta - 智能 Tmux Session 管理工具               ║
╚════════════════════════════════════════════════════════════╝

用法：
  ta              自動偵測當前專案並 attach
  ta -l           列出所有 tmux session
  ta --list       同上
  ta -n NAME      attach 到指定名稱的 session
  ta --name NAME  同上
  ta -h           顯示此幫助
  ta --help       同上

...
```

## 工作流程範例

### 多專案協作工作流

```bash
# 早上開始工作
cd ~/projects/project-A
ta    # 快速進入 project-A

# 中午切換到另一個專案
cd ~/projects/project-B
ta    # 快速進入 project-B

# 下午需要比對兩個專案
ta -l    # 查看所有 session
ta -n ai-project-A    # 切換到 project-A
# 做一些工作...
ta -n ai-project-B    # 切換到 project-B
```

### Git Repo 自動偵測

```bash
# ta 會自動偵測 git repo 名稱
cd ~/projects/my-awesome-app
ta    # 自動 attach 到 ai-my-awesome-app

# 如果不是 git repo，使用目錄名稱
cd ~/work/temp-project
ta    # 自動 attach 到 ai-temp-project
```

## 常見問題

### Q: Session 名稱怎麼決定？

**自動規則**：
- Git repo：session 名稱 = `ai-{repo名稱}`
- 非 git：session 名稱 = `ai-{目錄名稱}`

**範例**：
```bash
# Git repo
/projects/VibeGhostty → ai-VibeGhostty

# 非 git
/work/my-project → ai-my-project
```

### Q: 如果我在錯誤的目錄執行 ta 會怎樣？

ta 會使用當前目錄名稱建立/尋找 session。如果不是你要的 session：

```bash
# 方法 1: 先切換到正確目錄
cd ~/projects/correct-project
ta

# 方法 2: 直接指定 session 名稱
ta -n ai-correct-project
```

### Q: 可以同時 attach 多個 session 嗎？

目前 ta 一次只能 attach 一個 session。如果需要同時查看多個 session：

```bash
# 使用 Ghostty 的 Tab 功能
Cmd+T    # 開新 Tab
cd ~/projects/project-A
ta

Cmd+T    # 再開一個 Tab
cd ~/projects/project-B
ta

Cmd+1    # 切換到 project-A
Cmd+2    # 切換到 project-B
```

### Q: Session 名稱可以自訂嗎？

目前 ta 使用固定的命名規則 `ai-{專案名稱}`。

如果需要自訂名稱，可以：
1. 手動建立 session：`~/.tmux-layouts/ai-workspace.sh`
2. 修改腳本中的 SESSION_NAME 變數
3. 使用 ta -n 指定自訂的 session 名稱

## 進階技巧

### 配合 Shell Alias

在 ~/.zshrc 加入：

```bash
# 快速切換專案
alias pa='cd ~/projects/project-A && ta'
alias pb='cd ~/projects/project-B && ta'
alias pc='cd ~/projects/project-C && ta'
```

使用：
```bash
pa    # 一鍵進入 project-A 的 tmux session
```

### 配合 fzf（未來功能）

```bash
# 互動式選擇 session（規劃中）
ta --fzf    # 使用 fzf 選擇 session
```

## 命令速查表

| 命令 | 說明 | 使用場景 |
|------|------|----------|
| `ta` | 自動偵測並 attach | 最常用！日常工作 |
| `ta -l` | 列出所有 session | 查看有哪些專案在運行 |
| `ta -n NAME` | Attach 到指定 session | 明確知道要進入哪個 session |
| `ta -h` | 顯示幫助 | 忘記用法時 |

## 提示訊息說明

### 成功訊息
- ✅ 連接到 session 'xxx' = 成功 attach
- ✅ 切換到 session 'xxx' = 在 tmux 內成功切換
- ✅ Session 建立完成 = 新 session 建立成功

### 警告訊息
- ⚠️  Session 'xxx' 不存在 = Session 不存在，詢問是否建立

### 錯誤訊息
- ❌ Tmux 未安裝 = 需要先安裝 tmux
- ❌ Session 'xxx' 不存在 = 指定的 session 找不到

### 資訊訊息
- ℹ️  已取消 = 使用者取消操作
- 📋 可用的 Tmux Sessions = 顯示 session 列表
- 🚀 正在建立 AI Workspace = 正在建立新 session

---

**版本**: v1.0
**最後更新**: 2025-10-17
