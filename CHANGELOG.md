# Changelog

All notable changes to VibeGhostty will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [1.1.0] - 2025-10-17

### 🎉 重大易用性改善

針對「命令太多、難記憶」問題的完整解決方案。

#### Added
- **視覺化快捷鍵提示系統**
  - Tmux Status Bar 快捷鍵提示（底部永久顯示）
  - 內建幫助系統：`Ctrl+Space ?` 顯示完整快捷鍵表
  - vibe-help 命令：獨立的彩色快捷鍵速查工具

- **精簡模式配置**
  - config.minimal：只保留 8 個核心快捷鍵
  - 減少 50% 認知負擔（16 個 → 8 個）
  - 適合新手或不想記太多命令的使用者

- **完整易用性文檔**
  - USABILITY_IMPROVEMENTS.md：易用性改善完整指南
  - 問題分析、改善方案、學習路徑
  - 新手到進階的使用建議

#### Changed
- **tmux.conf**
  - Status Bar 加入快捷鍵提示（`?:help | r:reload | |:vsplit | -:hsplit`）
  - 增加 `bind ?` 顯示完整幫助彈出視窗
  - 優化 status-right-length 為 120

- **install.sh**
  - 自動安裝 vibe-help 到 ~/.local/bin/
  - 更新快速開始說明（優先提示 vibe-help）
  - 加入 vibe-help 執行權限設定

#### 效果對比

**改善前**：
- ❌ 30+ 個命令需要記憶
- ❌ 忘記快捷鍵需要查文檔（打斷工作流程）
- 😓 認知負擔重，影響專注

**改善後**：
- ✅ 精簡模式只需記 8 個核心快捷鍵
- ✅ 視覺提示隨時可見（Status Bar + 內建幫助）
- ✅ vibe-help 命令快速參考
- 😊 不需要背命令也能順暢使用

#### 使用方式

查看快捷鍵：
```bash
# 終端執行（任何時候）
vibe-help

# 或在 Tmux 內按
Ctrl+Space ?
```

使用精簡版配置：
```bash
cp config.minimal ~/Library/Application\ Support/com.mitchellh.ghostty/config
# 重新載入 Ghostty（Cmd+Shift+Comma）
```

更新現有安裝：
```bash
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh
tmux source-file ~/.tmux.conf  # 如果 Tmux 正在運行
```

---

## [1.0.0] - 2025-10-16

### 🎉 Initial Release

#### Added
- Tokyo Night Storm 配色主題
- JetBrains Mono Nerd Font 完整支援
- 多 AI Agent 協作優化配置
- 快速 Tab 切換快捷鍵 (Cmd+1~9)
- Split 視窗管理功能
- 50,000 行 Scrollback buffer
- 選取即複製功能
- Shell integration 支援
- 完整文檔（README, GUIDE, INSTALL）

#### Configuration
- Font size: 13pt
- Cell height adjustment: 15%
- Window padding: 8px
- Auto copy on select: enabled
- Shell integration: enabled

#### Keyboard Shortcuts
- Tab management (Cmd+T, Cmd+W, Cmd+1~9)
- Split management (Cmd+D, Cmd+Shift+D)
- Config reload (Cmd+Shift+Comma)

---

## [Unreleased]

### Planned Features
- [ ] 更多配色主題選項（Catppuccin, Nord, Dracula, Gruvbox）
- [ ] 主題切換 CLI 工具
- [ ] 更多布局腳本（開發模式、測試模式）
- [ ] 自動化測試（Bats 框架）
- [ ] Linux 平台支援

### Under Consideration
- [ ] 多語言文檔（English, 日本語）
- [ ] VS Code 整合
- [ ] 配置視覺化編輯器
- [ ] 螢幕錄影展示
- [ ] 社群插件系統

---

## Version History

### Version Numbering
We use Semantic Versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: 不相容的 API 變更
- **MINOR**: 向後相容的新功能
- **PATCH**: 向後相容的問題修正

### Release Notes
- **1.0.0**: 初始版本發布，包含核心功能和完整文檔

---

## Migration Guides

### From Default Ghostty Config
如果你正在使用預設的 Ghostty 配置：

1. 備份現有配置
```bash
cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   ~/ghostty-config.backup
```

2. 安裝 JetBrains Mono Nerd Font
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

3. 套用 VibeGhostty 配置
```bash
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

4. 重新載入或重啟 Ghostty

### From Other Terminal Configs
如果你從其他終端機（iTerm2, Alacritty, Kitty）遷移：

**注意事項**：
- 快捷鍵映射可能不同
- 字體渲染可能略有差異
- Split 行為與 tmux 不同

**建議**：
- 先在副本視窗測試
- 逐步調整習慣
- 保留原終端機作為備用

---

## Known Issues

### Current Limitations
- 無法自訂滑鼠綁定（Ghostty 限制）
- 某些 keybind 動作名稱與文檔不符
- macOS 獨占配置（Linux/Windows 需調整）

### Workarounds
詳見 [GUIDE.md](GUIDE.md) 的疑難排解章節

---

## Feedback & Contributions

歡迎提交：
- Bug 報告
- 功能建議
- 文檔改進
- 配置優化

請透過 [GitHub Issues](https://github.com/frankekn/VibeGhostty/issues) 聯繫我們。

---

**Last Updated**: 2025-10-17
