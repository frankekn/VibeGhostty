# 故障排除指南

**版本**: 1.1.0
**最後更新**: 2025-10-19
**預估閱讀時間**: 12 分鐘

---

## 目錄

1. [Ghostty 問題](#ghostty-問題)
2. [Tmux 問題](#tmux-問題)
3. [整合問題](#整合問題)
4. [效能問題](#效能問題)
5. [已知問題與限制](#已知問題與限制)
6. [尋求幫助](#尋求幫助)

---

## Ghostty 問題

### 問題 1: 配置不生效

**症狀**: 修改 `config` 後沒有變化

**可能原因**:
1. 配置文件位置錯誤
2. 語法錯誤
3. 沒有重新載入配置

**解決步驟**:

```bash
# 步驟 1: 確認配置文件位置
ls -lh ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 應該看到類似輸出:
# -rw-r--r--  1 user  staff   5.2K Oct 19 14:30 config

# 步驟 2: 檢查語法錯誤
# 常見錯誤：拼寫錯誤、等號前後多餘空格

# 錯誤範例:
font-size= 13           # ❌ 等號後不應有空格
font-size = 13          # ✅ 正確

fornt-size = 13         # ❌ 拼寫錯誤（fornt）
font-size = 13          # ✅ 正確

# 步驟 3: 重新載入配置
# 方法 1: 使用快捷鍵
Cmd+Shift+Comma

# 方法 2: 完全重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

**驗證配置生效**:

```bash
# 檢查字體大小變更
# 修改 font-size，重新載入，應立即看到變化

# 檢查主題變更
# 修改 background 色彩，重新載入，背景應改變
```

---

### 問題 2: 字體圖標顯示為方塊

**症狀**: Ghostty 中圖標顯示為 □ 或亂碼

**原因**: Nerd Font 未正確安裝或未套用

**解決步驟**:

```bash
# 步驟 1: 重新安裝 Nerd Font
brew reinstall --cask font-jetbrains-mono-nerd-font

# 步驟 2: 驗證字體安裝
ls ~/Library/Fonts/ | grep -i jetbrains

# 應該看到:
# JetBrainsMono Nerd Font Complete.ttf（或類似）

# 步驟 3: 確認 Ghostty 配置使用正確字體名稱
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 檢查這一行:
font-family = JetBrains Mono        # ✅ 正確
font-family = JetBrains Mono NF     # ❌ 錯誤（應該不含 NF）

# 步驟 4: 完全重啟 Ghostty
pkill -9 ghostty && open -a Ghostty
```

**測試圖標顯示**:

```bash
# 執行這個命令，應該看到圖標而非方塊
echo " 📁 📂 🔧 ⚡ 🚀"
```

---

### 問題 3: 快捷鍵不工作

**症狀**: 按 `Cmd+D` 或其他快捷鍵沒反應

**可能原因**:
1. macOS 系統快捷鍵衝突
2. Ghostty 配置錯誤

**解決步驟**:

```bash
# 步驟 1: 檢查系統快捷鍵衝突
# 系統偏好設定 → 鍵盤 → 快速鍵
# 查找是否有 Cmd+D、Cmd+T 等快捷鍵被系統佔用

# 常見衝突:
# - Cmd+D: Dock 的「隱藏/顯示」
# - Cmd+Space: Spotlight 搜尋

# 步驟 2: 檢查 Ghostty 配置
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 檢查快捷鍵語法
keybind = super+d=new_split:right    # ✅ 正確
keybind = cmd+d=new_split:right      # ❌ 錯誤（應為 super）

# 步驟 3: 測試快捷鍵
# 在 Ghostty 中按 Cmd+D
# 應該看到視窗向右分割

# 如果仍不工作，嘗試其他快捷鍵
keybind = super+backslash=new_split:right
```

**系統快捷鍵衝突解決**:

| 快捷鍵 | 衝突應用 | 解決方案 |
|--------|---------|---------|
| `Cmd+D` | Dock | 系統偏好設定 → 取消 Dock 快捷鍵 |
| `Cmd+Space` | Spotlight | 改為 `Cmd+Option+Space` |
| `Cmd+Shift+D` | 無（通常安全） | - |

---

### 問題 4: Scrollback 歷史記錄消失

**症狀**: 無法捲動查看之前的輸出

**原因**: Scrollback limit 設定過小

**解決步驟**:

```bash
# 步驟 1: 檢查當前設定
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 找到這一行
scrollback-limit = 50000    # 預設值

# 步驟 2: 根據需求調整
scrollback-limit = 100000   # 增加到 10 萬行

# 步驟 3: 重新載入
Cmd+Shift+Comma

# 步驟 4: 測試
# 執行產生大量輸出的命令
seq 1 100000

# 應該可以捲動查看所有 10 萬行
```

**記憶體考量**:

| Scrollback | 記憶體使用 | 適合情境 |
|-----------|-----------|---------|
| 10,000 | ~5 MB | 輕度使用 |
| 50,000 | ~25 MB | 標準使用（預設） |
| 100,000 | ~50 MB | AI 長對話 |
| 200,000 | ~100 MB | 日誌分析 |

---

## Tmux 問題

### 問題 1: Prefix 鍵不工作

**症狀**: 按 `Ctrl+Space` 沒有反應

**原因**: macOS Spotlight 佔用 `Ctrl+Space`

**解決步驟**:

```bash
# 步驟 1: 取消 Spotlight 快捷鍵
# 系統偏好設定 → 鍵盤 → 快速鍵 → Spotlight
# 取消勾選「顯示 Spotlight 搜尋」
# 或改為其他快捷鍵（如 Cmd+Space）

# 步驟 2: 測試 Tmux Prefix
# 啟動 Tmux
tmux

# 按 Ctrl+Space ?
# 應該顯示快捷鍵幫助畫面

# 步驟 3: 如果仍不工作，改用其他 Prefix
vim ~/.tmux.conf

# 改為 Ctrl+A
unbind C-Space
set -g prefix C-a
bind C-a send-prefix

# 重新載入
tmux source-file ~/.tmux.conf
```

---

### 問題 2: TPM 插件安裝失敗

**症狀**: 按 `Ctrl+Space I` 沒有反應或顯示錯誤

**原因**: TPM (Tmux Plugin Manager) 未正確安裝

**解決步驟**:

```bash
# 步驟 1: 檢查 TPM 是否安裝
ls -la ~/.tmux/plugins/tpm

# 如果不存在，手動安裝
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# 步驟 2: 確認 ~/.tmux.conf 包含 TPM 設定
vim ~/.tmux.conf

# 檢查文件末尾是否有:
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
# ... 其他插件

# 初始化 TPM（必須在最後一行）
run '~/.tmux/plugins/tpm/tpm'

# 步驟 3: 重啟 Tmux
tmux kill-server
tmux

# 步驟 4: 安裝插件
Ctrl+Space I        # 大寫 I

# 或手動執行
~/.tmux/plugins/tpm/bin/install_plugins
```

**驗證插件安裝**:

```bash
# 檢查插件目錄
ls -la ~/.tmux/plugins/

# 應該看到:
# tmux-sensible/
# tmux-resurrect/
# tmux-continuum/
# tmux-logging/
```

---

### 問題 3: Session 無法恢復

**症狀**: `Ctrl+Space Ctrl+r` 沒有恢復任何東西

**原因**: tmux-resurrect 未正確安裝或儲存

**診斷與解決**:

```bash
# 步驟 1: 檢查 resurrect 檔案
ls -la ~/.tmux/resurrect/

# 應該看到 last 符號連結和時間戳檔案
# lrwxr-xr-x  1 user  staff  tmux_resurrect_20251019T143000.txt
# -rw-r--r--  1 user  staff  tmux_resurrect_20251019T143000.txt

# 步驟 2: 確認插件已安裝
ls ~/.tmux/plugins/tmux-resurrect

# 步驟 3: 如果不存在，重新安裝插件
Ctrl+Space I

# 步驟 4: 手動儲存測試
Ctrl+Space Ctrl+s

# 應該看到訊息: "Tmux environment saved!"

# 步驟 5: 手動恢復測試
Ctrl+Space Ctrl+r

# 應該看到訊息: "Tmux restore complete!"
```

**自動儲存設定**（tmux-continuum）:

```bash
# 檢查 ~/.tmux.conf 中有這行
set -g @continuum-restore 'on'
set -g @continuum-save-interval '15'    # 每 15 分鐘自動儲存
```

---

### 問題 4: 窗格標題不顯示 Emoji

**症狀**: 看到 `?` 或方塊而不是 emoji

**原因**: 字體不支援 emoji

**解決步驟**:

```bash
# 步驟 1: 確認 Ghostty 使用支援 emoji 的字體
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 推薦字體（支援 emoji）:
font-family = JetBrains Mono        # ✅ 支援
font-family = Fira Code Nerd Font   # ✅ 支援
font-family = SF Mono               # ✅ 支援（macOS 預設）

# 步驟 2: 重新載入 Ghostty
Cmd+Shift+Comma

# 步驟 3: 測試 emoji 顯示
echo "🚀 🤖 📊 ⚡"

# 應該正確顯示圖標
```

---

### 問題 5: 布局腳本執行失敗

**症狀**:

```bash
$ ~/.tmux-layouts/ai-workspace.sh
bash: permission denied
```

**原因**: 腳本沒有執行權限

**解決步驟**:

```bash
# 步驟 1: 檢查權限
ls -la ~/.tmux-layouts/

# 應該看到 -rwxr-xr-x（有 x 執行權限）

# 步驟 2: 設定執行權限
chmod +x ~/.tmux-layouts/*.sh
chmod +x ~/.local/bin/tmux-launch
chmod +x ~/.local/bin/vibe-help
chmod +x ~/.local/bin/ta

# 步驟 3: 驗證權限
ls -la ~/.tmux-layouts/

# 步驟 4: 測試執行
~/.tmux-layouts/ai-workspace.sh
```

---

## 整合問題

### 問題 1: Ghostty + Tmux 色彩不一致

**症狀**: Tmux 中的色彩與 Ghostty 不一致或看起來奇怪

**原因**: Tmux 的 256 色或真彩色模式配置問題

**解決步驟**:

```bash
# 步驟 1: 檢查 TERM 變數
echo $TERM

# 在 Ghostty 中應該是:
xterm-256color

# 在 Tmux 中應該是:
screen-256color 或 tmux-256color

# 步驟 2: 確認 ~/.tmux.conf 配置
vim ~/.tmux.conf

# 確認有這些行:
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# 步驟 3: 測試真彩色支援
# 在 Tmux 中執行
printf "\x1b[38;2;255;100;0mTRUECOLOR\x1b[0m\n"

# 應該顯示橘色的 "TRUECOLOR"

# 步驟 4: 重新載入配置
Ctrl+Space r
```

---

### 問題 2: PATH 設定問題

**症狀**: `tmux-launch`, `ta`, `vibe-help` 找不到命令

**原因**: `~/.local/bin` 不在 PATH 中

**解決步驟**:

```bash
# 步驟 1: 檢查 PATH
echo $PATH | grep -q "$HOME/.local/bin" && echo "✅ PATH OK" || echo "❌ 需要加入 PATH"

# 步驟 2: 加入 PATH（如果需要）
# 對於 Zsh（macOS 預設）
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# 對於 Bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# 步驟 3: 驗證
which tmux-launch
which ta
which vibe-help

# 應該顯示:
# /Users/xxx/.local/bin/tmux-launch
# /Users/xxx/.local/bin/ta
# /Users/xxx/.local/bin/vibe-help
```

---

### 問題 3: AI CLI 在 Tmux 中行為異常

**症狀**: Codex 或 Claude 在 Tmux 中顯示不正常

**診斷步驟**:

```bash
# 步驟 1: 在 Tmux 外測試
codex
claude

# 步驟 2: 在 Tmux 內測試
tmux
codex
claude

# 步驟 3: 檢查 TERM 變數
echo $TERM

# 步驟 4: 檢查 PATH
which codex
which claude
```

**可能原因與解決**:

**原因 1: TERM 變數問題**

```bash
# 編輯 ~/.tmux.conf
set -g default-terminal "screen-256color"

# 重新載入
tmux source-file ~/.tmux.conf
```

**原因 2: PATH 問題**

```bash
# 確保 ~/.zshrc 或 ~/.bashrc 正確載入
echo $PATH | grep local

# 如果沒有看到包含 AI CLI 的路徑，檢查 shell 初始化文件
```

**原因 3: Shell 初始化問題**

```bash
# 確保 Tmux 使用正確的 shell
# 編輯 ~/.tmux.conf
set -g default-command "${SHELL}"
```

---

## 效能問題

### 問題 1: Ghostty 記憶體使用過高

**症狀**: Ghostty 佔用大量 RAM（>1GB）

**可能原因**:
1. Scrollback 限制過高
2. 過多 tabs 同時開啟

**解決步驟**:

```bash
# 步驟 1: 檢查當前 scrollback 設定
vim ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 步驟 2: 根據 RAM 調整

# < 8GB RAM
scrollback-limit = 10000

# 8-16GB RAM
scrollback-limit = 50000

# 16GB+ RAM
scrollback-limit = 100000

# 步驟 3: 管理 tabs
# 定期關閉不需要的 tabs
Cmd+W

# 檢查當前 tabs 數量
# 建議不超過 10 個
```

**記憶體使用估算**:

```
每個 tab 記憶體 = scrollback-limit × 行寬 × 字元大小

範例（10 個 tabs）:
- 10,000 行 × 10 tabs = ~50 MB
- 50,000 行 × 10 tabs = ~250 MB
- 100,000 行 × 10 tabs = ~500 MB
```

---

### 問題 2: Tmux 延遲明顯

**症狀**: Tmux 操作有明顯延遲（>100ms）

**可能原因**:
1. history-limit 過高
2. 插件過多

**解決步驟**:

```bash
# 步驟 1: 調整 history-limit
vim ~/.tmux.conf

# 找到這行
set -g history-limit 50000

# 降低到合理值
set -g history-limit 10000

# 步驟 2: 檢查插件數量
# 只保留必要插件
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-resurrect'
# 註解掉不常用的插件

# 步驟 3: 重新載入
Ctrl+Space r

# 步驟 4: 測試延遲
# 快速按 Ctrl+Space h/j/k/l
# 應該立即切換窗格
```

---

## 已知問題與限制

### Ghostty 限制

**來源**: CHANGELOG.md（已知問題章節）

1. **無法自訂滑鼠綁定**
   - 症狀: 無法改變滑鼠點擊、拖曳的行為
   - 原因: Ghostty 限制
   - 替代方案: 使用鍵盤快捷鍵

2. **某些 keybind 動作名稱與文檔不符**
   - 症狀: 配置中的動作名稱可能與官方文檔略有差異
   - 解決: 參考實際運行的 VibeGhostty config 文件

3. **macOS 獨占配置**
   - 症狀: config 文件在 Linux/Windows 上需要調整
   - 解決: 使用平台特定的配置文件

---

### Tmux 已知問題

**來源**: TMUX_GUIDE.md（故障排除章節）

1. **Copy mode 複製到系統剪貼簿失敗（macOS）**

   **症狀**: 在 Tmux 中複製後，無法在其他程式貼上

   **解決**:
   ```bash
   # 安裝 reattach-to-user-namespace
   brew install reattach-to-user-namespace

   # 在 ~/.tmux.conf 加入
   set -g default-command "reattach-to-user-namespace -l $SHELL"

   # 重新載入
   Ctrl+Space r
   ```

2. **Session 名稱衝突**

   **症狀**: 腳本說 session 已存在，但找不到

   **解決**:
   ```bash
   # 列出所有 sessions
   tmux list-sessions

   # 刪除衝突的 session
   tmux kill-session -t ai-work

   # 或刪除所有
   tmux kill-server
   ```

---

## 尋求幫助

如果以上解決方案都無法解決你的問題：

### 1. 檢查 GitHub Issues

**VibeGhostty 專案**:
- [已關閉 Issues](https://github.com/frankekn/VibeGhostty/issues?q=is%3Aissue+is%3Aclosed) - 查看是否有人遇過類似問題
- [開放 Issues](https://github.com/frankekn/VibeGhostty/issues) - 查看當前已知問題

**上游專案**:
- [Ghostty Issues](https://github.com/ghostty-org/ghostty/issues)
- [Tmux Issues](https://github.com/tmux/tmux/issues)

---

### 2. 創建新 Issue

**在 VibeGhostty 提 Issue 時，請包含**:

```markdown
**環境資訊**:
- macOS 版本: （如 macOS 14.5）
- Ghostty 版本: （執行 `ghostty --version`）
- Tmux 版本: （執行 `tmux -V`）
- VibeGhostty 版本: （如 v1.1.0）

**問題描述**:
（詳細描述問題）

**重現步驟**:
1.
2.
3.

**預期行為**:
（你期望發生什麼）

**實際行為**:
（實際發生了什麼）

**錯誤訊息**（如果有）:
```
完整錯誤訊息或截圖
```

**已嘗試的解決方案**:
（列出你已經嘗試過的故障排除步驟）
```

---

### 3. 緊急重置

**如果一切都出問題，完整重置**:

```bash
# 步驟 1: 備份當前配置
BACKUP_DIR=~/vibeghostty-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

cp ~/Library/Application\ Support/com.mitchellh.ghostty/config \
   "$BACKUP_DIR/ghostty-config"
cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf"
cp -r ~/.tmux-layouts "$BACKUP_DIR/tmux-layouts"

echo "✅ 備份完成: $BACKUP_DIR"

# 步驟 2: 停止所有 Tmux sessions
tmux kill-server

# 步驟 3: 清理 Tmux 目錄
rm -rf ~/.tmux/

# 步驟 4: 重新安裝 VibeGhostty
cd ~/Documents/GitHub/VibeGhostty

# Ghostty
cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Tmux
cd tmux
bash install.sh

# 步驟 5: 重啟 Ghostty
pkill -9 ghostty && open -a Ghostty

# 步驟 6: 啟動測試
tmux-launch
```

---

## 延伸閱讀

**官方文檔**:
- [Ghostty 文檔](https://ghostty.org/docs) - Ghostty 官方文檔
- [Ghostty 配置參考](https://ghostty.org/docs/config) - 完整配置選項
- [Tmux Wiki](https://github.com/tmux/tmux/wiki) - Tmux 官方 Wiki
- [Tmux Manual](https://man7.org/linux/man-pages/man1/tmux.1.html) - Tmux 完整手冊

**社群資源**:
- [Ghostty Discussions](https://github.com/ghostty-org/ghostty/discussions) - Ghostty 討論區
- [Tmux Google Group](https://groups.google.com/forum/#!forum/tmux-users) - Tmux 使用者群組

**相關指南**:
- [Ghostty 使用指南](../../GUIDE.md) - Ghostty 完整功能
- [Tmux 使用指南](../../TMUX_GUIDE.md) - Tmux 深度指南
- [自訂配置](customization.zh-TW.md) - 進階配置選項
- [工作流程範例](workflows.zh-TW.md) - AI 協作實戰

---

**文檔版本**: 1.1.0
**最後更新**: 2025-10-19
**貢獻者**: Claude Code

希望這份指南能幫助你解決所有問題！ 🔧
