# VibeGhostty 🚀

> Ghostty 終端機多 AI Agent 協作配置專案

專為 Claude Code、Codex CLI 等多 AI 工具同時運行優化的 Ghostty 終端機配置。

---

## ✨ 特色

- 🎨 **Tokyo Night Storm 主題** - 護眼深色配色
- 🔤 **JetBrains Mono Nerd Font** - 完整符號支援
- ⌨️ **高效快捷鍵** - 快速 tab 切換和視窗管理
- 🤖 **AI 協作優化** - 針對多 AI agent 工作流程設計
- 📊 **大容量 Scrollback** - 保存完整 AI 對話歷史

---

## 🚀 快速開始

### 1. 安裝字體

```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### 2. 複製配置

```bash
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

### 3. 重新載入 Ghostty

在 Ghostty 中按 `Cmd+Shift+Comma` 或重啟應用程式。

---

## ⌨️ 快捷鍵

### Tab 管理
| 快捷鍵 | 功能 |
|--------|------|
| `Cmd+T` | 新建 tab |
| `Cmd+W` | 關閉 tab |
| `Cmd+1~9` | 跳轉到指定 tab |
| `Cmd+Shift+]` | 下一個 tab |
| `Cmd+Shift+[` | 上一個 tab |

### Split（分割視窗）
| 快捷鍵 | 功能 |
|--------|------|
| `Cmd+D` | 向右分割 |
| `Cmd+Shift+D` | 向下分割 |

### 其他
| 快捷鍵 | 功能 |
|--------|------|
| `Cmd+Shift+Comma` | 重新載入配置 |

---

## 💡 工作流程範例

### 場景 1: Claude Code + Codex CLI 並行

```bash
# Tab 1 - Claude Code 主工作區
claude

# Cmd+T 開新 tab
# Tab 2 - Codex CLI 輔助
codex

# 用 Cmd+1/2 快速切換
```

### 場景 2: 並排比較 AI 輸出

```bash
# Claude Code 在左側
claude

# Cmd+D 分割右側
codex

# 並排比較兩個 AI 的輸出
```

### 場景 3: 多專案同時進行

```
Tab 1: 專案 A - Claude Code
Tab 2: 專案 A - 測試輸出
Tab 3: 專案 B - Codex CLI
Tab 4: 專案 B - 監控日誌

→ 用 Cmd+1/2/3/4 快速跳轉
```

---

## 🎨 配色方案

### Tokyo Night Storm
- **背景**: `#24283b` - 深藍灰
- **前景**: `#c0caf5` - 柔和白
- **Cursor**: `#ff9e64` - 橙色
- **選取**: `#364a82` - 藍色高亮

### ANSI 顏色
- 🔴 紅色 (`#f7768e`) - 錯誤、警告
- 🟢 綠色 (`#9ece6a`) - 成功、完成
- 🔵 藍色 (`#7aa2f7`) - 資訊、連結
- 🟡 黃色 (`#e0af68`) - 警示、注意
- 🟣 紫色 (`#bb9af7`) - 關鍵字、特殊
- 🔷 青色 (`#7dcfff`) - 函式、方法

---

## 🔧 自訂設定

### 調整字體大小

編輯 `config` 文件：

```bash
# 找到這行
font-size = 13

# 改為你喜歡的大小
font-size = 12  # 更小
font-size = 14  # 更大
```

然後按 `Cmd+Shift+Comma` 重新載入。

### 更換字體

```bash
# 安裝其他 Nerd Font
brew install --cask font-fira-code-nerd-font

# 修改 config
font-family = Fira Code
```

### 調整 Scrollback

```bash
# 增加歷史記錄
scrollback-limit = 100000

# 減少記憶體使用
scrollback-limit = 20000
```

---

## 🔥 Tmux AI 工作空間整合

**NEW!** 現在支援進階的 Tmux 多 AI 協作環境！

### 為什麼需要 Tmux？

Ghostty 提供優秀的終端體驗，而 Tmux 為多 AI 協作提供：

- 📐 **智能布局管理** - 預設 3 種專業布局（Workspace、Compare、Focus）
- 💾 **Session 持久化** - 自動保存工作狀態，隨時恢復
- ⚡ **快速導航** - Vim-style 快捷鍵，一鍵跳轉 panes
- 🎨 **主題一致性** - Tokyo Night Storm 主題與 Ghostty 完美配合
- 🤖 **AI 協作優化** - Codex CLI + Claude Code 並行工作流程

### 快速開始 Tmux

```bash
# 1. 安裝 Tmux 配置
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh

# 2. 啟動互動式選單
tmux-launch
```

### 三種預設布局

**1. AI Workspace（主要工作模式）**
```
┌─────────────────────────┬─────────────┐
│   Codex CLI (70%)       │  Claude     │
│                         │  Code (30%) │
│   主要工作區            ├─────────────┤
│                         │  Monitor    │
│                         │  (30%)      │
└─────────────────────────┴─────────────┘
```
適合：日常開發、需要 AI 輔助、同時監控測試

**2. AI Compare（比較模式）**
```
┌────────────────┬────────────────┐
│  Codex CLI     │  Claude Code   │
│  (50%)         │  (50%)         │
├────────────────┴────────────────┤
│  Compare/Monitor (25%)          │
└─────────────────────────────────┘
```
適合：比較兩個 AI 的解決方案、評估不同實作

**3. Full Focus（專注模式）**
```
┌─────────────────────────────────┐
│  Codex CLI 或 Claude Code       │
│  (100% 全屏)                    │
└─────────────────────────────────┘
```
適合：深度思考、複雜問題、減少視覺干擾

### Tmux 快速指令

```bash
# 啟動選單
tmux-launch

# 直接啟動特定布局
~/.tmux-layouts/ai-workspace.sh
~/.tmux-layouts/ai-compare.sh
~/.tmux-layouts/full-focus.sh

# 恢復上次工作
tmux attach
```

### 必學 Tmux 快捷鍵

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Ctrl+Space 1/2/3` | 快速跳轉 pane | 跳到特定區域 |
| `Ctrl+Space d` | Detach | 暫時離開（保留 session）|
| `Ctrl+Space z` | Zoom | 全屏/還原當前 pane |
| `Ctrl+Space r` | 重新載入配置 | 修改配置後使用 |

### Tmux 完整文檔

- 📖 **[TMUX_GUIDE.md](TMUX_GUIDE.md)** - 完整使用指南（快捷鍵、進階技巧、FAQ）
- 🚀 **[QUICKSTART_TMUX.md](QUICKSTART_TMUX.md)** - 5 分鐘快速開始

### Ghostty vs Tmux 使用建議

| 場景 | 建議工具 | 原因 |
|------|----------|------|
| 簡單任務、單一 AI | Ghostty Tabs | 更輕量、視覺更清晰 |
| 多 AI 協作、複雜專案 | Tmux Sessions | 強大布局、狀態保存 |
| 需要長期保留工作狀態 | Tmux Sessions | 自動保存、隨時恢復 |
| 臨時測試、快速查看 | Ghostty Splits | 快速分割、即開即用 |

**最佳實踐：** Ghostty 提供視窗，Tmux 管理工作空間，兩者配合使用！

---

## 📁 檔案結構

```
VibeGhostty/
├── README.md              # 本文件
├── config                 # Ghostty 配置文件
├── GUIDE.md               # Ghostty 詳細使用指南
├── INSTALL.md             # Ghostty 安裝說明
├── QUICKSTART.md          # Ghostty 快速開始
├── TMUX_GUIDE.md          # Tmux 完整使用指南（NEW!）
├── QUICKSTART_TMUX.md     # Tmux 快速開始（NEW!）
└── tmux/                  # Tmux 配置目錄（NEW!）
    ├── tmux.conf          # Tmux 主配置
    ├── install.sh         # 一鍵安裝腳本
    ├── layouts/           # 布局腳本
    │   ├── ai-workspace.sh
    │   ├── ai-compare.sh
    │   └── full-focus.sh
    └── bin/
        └── tmux-launch    # 互動式啟動器
```

---

## 🐛 疑難排解

### Q: 字體沒有正確顯示圖標
**A**: 確認已安裝 Nerd Font：
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Q: 快捷鍵沒有作用
**A**:
1. 檢查是否與系統快捷鍵衝突
2. 重新載入配置 (`Cmd+Shift+Comma`)
3. 重啟 Ghostty

### Q: 配置重新載入後仍有錯誤
**A**: 完全重啟 Ghostty：
```bash
pkill -9 ghostty && open -a Ghostty
```

---

## 📚 資源

- [Ghostty 官方文檔](https://ghostty.org/docs)
- [完整配置選項](https://ghostty.org/docs/config)
- [Nerd Fonts 下載](https://www.nerdfonts.com/)
- [Tokyo Night 主題](https://github.com/enkia/tokyo-night-vscode-theme)

---

## 📄 授權

MIT License

---

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

---

**配置版本**: 1.0.0
**最後更新**: 2025-10-16
**相容 Ghostty 版本**: 1.0+

享受高效的多 AI agent 協作體驗！ 🎉
