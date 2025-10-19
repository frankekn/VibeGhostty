# Ghostty 快速開始（5 分鐘）

**預估閱讀時間**: 5 分鐘
**目標**: 快速安裝並啟動 Ghostty 配置
**版本**: 1.1.0
**最後更新**: 2025-10-19

---

## 前置需求

- macOS 11.0 或更新版本
- [Homebrew](https://brew.sh/) 套件管理器

---

## 安裝步驟

### 步驟 1: 安裝 Ghostty

```bash
# 使用 Homebrew 安裝
brew install --cask ghostty

# 或從官網下載
# https://ghostty.org/
```

### 步驟 2: 安裝 JetBrains Mono Nerd Font

```bash
# 安裝字體（必須）
brew install --cask font-jetbrains-mono-nerd-font
```

**為什麼需要 Nerd Font？**
Nerd Font 包含圖標和符號，讓終端機能正確顯示 AI 工具的輸出（emoji、進度條、圖示等）。

### 步驟 3: 複製配置檔案

```bash
# Clone 專案（如果從 GitHub）
git clone https://github.com/frankekn/VibeGhostty.git
cd VibeGhostty

# 備份現有配置（如果有）
[ -f ~/Library/Application\ Support/com.mitchellh.ghostty/config ] && \
  cp ~/Library/Application\ Support/com.mitchellh.ghostty/config ~/ghostty-config.backup

# 複製 VibeGhostty 配置
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

### 步驟 4: 啟動 Ghostty

**首次啟動**:
```bash
open -a Ghostty
```

**重新載入配置**（如果 Ghostty 已開啟）:
```bash
# 方法 1: 按快捷鍵
Cmd+Shift+Comma

# 方法 2: 完全重啟
pkill -9 ghostty && open -a Ghostty
```

### 驗證安裝

開啟 Ghostty 後確認：

- ✅ 無錯誤訊息
- ✅ 字體顯示為 JetBrains Mono（等寬字體）
- ✅ 背景為深藍灰色（Tokyo Night Storm 主題）
- ✅ 游標為橙色
- ✅ 分頁列在視窗頂部

---

## 基本使用

### 核心快捷鍵（最常用的 7 個）

| 快捷鍵 | 功能 | 使用場景 |
|--------|------|---------|
| `Cmd+T` | 新建分頁 | 開啟新任務 |
| `Cmd+1~9` | 跳轉分頁 1-9 | 快速切換專案 |
| `Cmd+W` | 關閉分頁 | 完成任務後清理 |
| `Cmd+D` | 向右分割 | 並排比較輸出 |
| `Cmd+Shift+D` | 向下分割 | 上下對照 |
| `Cmd+Shift+Comma` | 重新載入配置 | 修改配置後生效 |
| `Cmd+Shift+]` / `[` | 下一個/上一個分頁 | 循環切換 |

**記住這 7 個，就能開始高效工作了！**

### 第一個工作流程

```bash
# 開啟 Ghostty

# 分頁 1: 啟動 Claude Code
claude

# 按 Cmd+T 開新分頁
# 分頁 2: 啟動 Codex CLI
codex

# 快速切換
# Cmd+1: 切回 Claude Code
# Cmd+2: 切到 Codex CLI

# 需要並排比較？
# 在分頁 1 按 Cmd+D
# 左側：Claude Code
# 右側：執行 codex
```

---

## 常見問題速解

### 字體沒有正確顯示？

```bash
# 重新安裝字體
brew reinstall --cask font-jetbrains-mono-nerd-font

# 完全重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

### 快捷鍵不工作？

1. 檢查系統快捷鍵衝突（系統偏好設定 → 鍵盤 → 快速鍵）
2. 在 Ghostty 按 `Cmd+Shift+Comma` 重新載入配置
3. 若仍無效，完全重啟 Ghostty

### 配置載入後出現錯誤？

```bash
# 使用乾淨的配置
cp ~/Documents/GitHub/VibeGhostty/config \
   ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 完全重啟
pkill -9 ghostty && open -a Ghostty
```

---

## 下一步

完成快速開始後，你可以：

**深入學習**:
- 📚 [Ghostty 完整指南](ghostty-guide.zh-TW.md) - 深入了解所有功能
- 🎨 [自訂配置](customization.zh-TW.md) - 調整主題、字體、快捷鍵
- 💡 [工作流程範例](workflows.zh-TW.md) - AI 協作實戰案例

**進階整合**:
- 🔧 [Tmux 使用指南](tmux-guide.zh-TW.md) - 強大的工作空間管理

**問題排除**:
- 🐛 [故障排除](troubleshooting.zh-TW.md) - 解決常見問題

---

## 延伸閱讀

**官方資源**:
- [Ghostty 官方文檔](https://ghostty.org/docs) - Ghostty 完整參考
- [Ghostty 配置參考](https://ghostty.org/docs/config) - 所有配置選項
- [Nerd Fonts 官網](https://www.nerdfonts.com/) - 字體下載與說明
- [Tokyo Night 主題](https://github.com/enkia/tokyo-night-vscode-theme) - 配色方案

**社群資源**:
- [VibeGhostty GitHub](https://github.com/frankekn/VibeGhostty) - 專案首頁
- [提交問題](https://github.com/frankekn/VibeGhostty/issues) - 報告錯誤或建議

---

**安裝完成！開始享受高效的 AI 協作吧！** 🚀
