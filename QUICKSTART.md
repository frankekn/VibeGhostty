# 快速開始 ⚡

5 分鐘內完成 VibeGhostty 配置！

---

## 🚀 一鍵安裝

```bash
# 1. 安裝字體
brew install --cask font-jetbrains-mono-nerd-font

# 2. 備份現有配置（如果有）
[ -f ~/Library/Application\ Support/com.mitchellh.ghostty/config ] && \
  cp ~/Library/Application\ Support/com.mitchellh.ghostty/config ~/ghostty-config.backup

# 3. 複製 VibeGhostty 配置
cp ~/Documents/GitHub/VibeGhostty/config \
   ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 4. 重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

完成！🎉

---

## ⌨️ 最常用的 3 個快捷鍵

1. **Cmd+T** - 開新 tab
2. **Cmd+1~9** - 快速跳轉 tab
3. **Cmd+D** - 分割視窗

記住這三個，就能開始高效工作了！

---

## 🎯 第一個工作流程

```bash
# Tab 1: 啟動 Claude Code
claude

# Cmd+T 開新 tab
# Tab 2: 啟動另一個工具
codex

# Cmd+1: 切回 Claude
# Cmd+2: 切到 Codex
```

就這麼簡單！

---

## 📚 深入學習

- [完整指南](GUIDE.md) - 詳細使用說明
- [安裝文檔](INSTALL.md) - 詳細安裝步驟
- [更新日誌](CHANGELOG.md) - 版本歷史

---

## 🐛 遇到問題？

### 字體沒顯示？
```bash
brew reinstall --cask font-jetbrains-mono-nerd-font
pkill -9 ghostty && open -a Ghostty
```

### 快捷鍵不工作？
在 Ghostty 按 `Cmd+Shift+Comma` 重新載入配置

### 還是有錯誤？
完全重啟：
```bash
pkill -9 ghostty && open -a Ghostty
```

---

**搞定！開始享受高效的 AI 協作吧！** 🚀
