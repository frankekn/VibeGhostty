# Ghostty 使用指南

**版本**: 1.1.0
**最後更新**: 2025-10-19
**前置閱讀**: [快速開始](quickstart.zh-TW.md)

---

## 目錄

- [配置系統](#配置系統)
- [主題與視覺](#主題與視覺)
- [快捷鍵系統](#快捷鍵系統)
- [進階功能](#進階功能)
- [工作流程範例](#工作流程範例)
- [效能優化](#效能優化)
- [常見問題](#常見問題)
- [延伸閱讀](#延伸閱讀)

---

## 配置系統

### 配置檔案位置

Ghostty 的配置檔案位於：

```
~/Library/Application Support/com.mitchellh.ghostty/config
```

**檢查配置檔案**:
```bash
# 查看配置檔案路徑
ls -lh ~/Library/Application\ Support/com.mitchellh.ghostty/config

# 查看配置內容
cat ~/Library/Application\ Support/com.mitchellh.ghostty/config
```

### 配置檔案結構

VibeGhostty 配置檔案組織為 7 個主要區塊：

```bash
# ═══════════════════════════════════════════
# 1. 主題與色彩
# ═══════════════════════════════════════════
theme = tokyo-night-storm
background = 24283b
foreground = c0caf5
# ... ANSI palette

# ═══════════════════════════════════════════
# 2. 字體設定
# ═══════════════════════════════════════════
font-family = JetBrains Mono
font-size = 13
adjust-cell-height = 15%

# ═══════════════════════════════════════════
# 3. 視窗與外觀
# ═══════════════════════════════════════════
window-padding-x = 8
window-padding-y = 8
tab-bar-position = top

# ═══════════════════════════════════════════
# 4. 終端機行為
# ═══════════════════════════════════════════
scrollback-limit = 50000
copy-on-select = clipboard
shell-integration = detect

# ═══════════════════════════════════════════
# 5. 快捷鍵
# ═══════════════════════════════════════════
keybind = super+t=new_tab
keybind = super+1=goto_tab:1
# ... 等等

# ═══════════════════════════════════════════
# 6. 進階功能
# ═══════════════════════════════════════════
shell-integration-features = cursor,sudo,title

# ═══════════════════════════════════════════
# 7. macOS 特定設定
# ═══════════════════════════════════════════
macos-option-as-alt = true
```

### 重新載入配置

修改配置後，有 3 種方式套用變更：

**方法 1: 快捷鍵重新載入**（推薦）
```bash
# 在 Ghostty 視窗按
Cmd+Shift+Comma
```

**方法 2: 完全重啟**（最可靠）
```bash
pkill -9 ghostty && open -a Ghostty
```

**方法 3: 開新視窗**（測試配置）
```bash
# 按 Cmd+Shift+T 開新視窗
# 新視窗會載入新配置
# 舊視窗保持原配置（方便比較）
```

---

## 主題與視覺

### Tokyo Night Storm 主題

VibeGhostty 預設使用 Tokyo Night Storm 配色方案，專為長時間編碼設計：

**核心色彩**:

| 用途 | 色碼 | 說明 |
|------|------|------|
| 背景 | `#24283b` | 深藍灰色，低對比護眼 |
| 前景 | `#c0caf5` | 柔和白色，舒適閱讀 |
| 游標 | `#ff9e64` | 橙色，易於定位 |
| 選取 | `#364a82` | 藍灰色，不刺眼 |
| 活動分頁 | `#7aa2f7` | 藍色，明確標示 |

**ANSI 色彩**（程式碼高亮）:

| ANSI 色 | 色碼 | 用途 |
|---------|------|------|
| Red | `#f7768e` | 錯誤訊息、警告 |
| Green | `#9ece6a` | 成功訊息、通過測試 |
| Yellow | `#e0af68` | 警告、提示 |
| Blue | `#7aa2f7` | 資訊、連結 |
| Magenta | `#bb9af7` | 特殊標記 |
| Cyan | `#7dcfff` | 輸出、路徑 |

### 字體配置

**當前字體**: JetBrains Mono Nerd Font

**為什麼選擇 JetBrains Mono？**
- ✅ 專為程式設計師設計（數字 0 與字母 O 明確區分）
- ✅ 支援連字（ligatures）：`=>`, `!=`, `===` 顯示為單一符號
- ✅ Nerd Font 版本包含 3,600+ 圖標和符號
- ✅ 開源且免費

**調整字體大小**:

編輯 `~/Library/Application Support/com.mitchellh.ghostty/config`：

```bash
# 當前設定
font-size = 13

# 調整選項
font-size = 11  # 極小（適合高解析度螢幕，4K+）
font-size = 12  # 較小（適合 2K 螢幕）
font-size = 13  # 預設（推薦，平衡閱讀與資訊密度）
font-size = 14  # 較大（適合遠距離閱讀）
font-size = 15  # 大（適合演示或視力輔助）
```

**更換字體**:

```bash
# 安裝其他 Nerd Font
brew install --cask font-fira-code-nerd-font      # 連字支援強
brew install --cask font-hack-nerd-font           # 簡潔風格
brew install --cask font-meslo-lg-nerd-font       # 傳統等寬
brew install --cask font-source-code-pro          # Adobe 出品

# 修改配置
# 將 font-family 改為新字體名稱
font-family = Fira Code
font-family = Hack
font-family = Meslo LG
font-family = Source Code Pro
```

**調整行高**:

```bash
# 當前設定
adjust-cell-height = 15%

# 調整選項（根據個人喜好）
adjust-cell-height = 0%      # 標準行高（緊湊）
adjust-cell-height = 10%     # 略增加（舒適）
adjust-cell-height = 15%     # 預設（推薦，易於閱讀）
adjust-cell-height = 20%     # 寬鬆（適合長時間閱讀）
```

### 自訂主題

詳細的主題自訂指南請參考 [自訂配置指南](customization.zh-TW.md#主題自訂)。

**快速修改色彩**:

```bash
# 修改背景色（改為更深的顏色）
background = 1a1b26

# 修改前景色（改為更亮的白色）
foreground = ffffff

# 修改游標色（改為綠色）
cursor-color = 9ece6a
```

---

## 快捷鍵系統

### Tab 管理

**完整快捷鍵列表**:

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+T` | 新建分頁 | 在當前視窗創建新分頁 |
| `Cmd+W` | 關閉分頁 | 關閉當前分頁或分割窗格 |
| `Cmd+Shift+T` | 新視窗 | 開啟全新的 Ghostty 視窗 |
| `Cmd+1` | 跳轉分頁 1 | 快速跳轉到第一個分頁 |
| `Cmd+2` | 跳轉分頁 2 | 快速跳轉到第二個分頁 |
| `Cmd+3` | 跳轉分頁 3 | 快速跳轉到第三個分頁 |
| `Cmd+4` | 跳轉分頁 4 | 快速跳轉到第四個分頁 |
| `Cmd+5` | 跳轉分頁 5 | 快速跳轉到第五個分頁 |
| `Cmd+6` | 跳轉分頁 6 | 快速跳轉到第六個分頁 |
| `Cmd+7` | 跳轉分頁 7 | 快速跳轉到第七個分頁 |
| `Cmd+8` | 跳轉分頁 8 | 快速跳轉到第八個分頁 |
| `Cmd+9` | 跳轉分頁 9 | 快速跳轉到第九個分頁 |
| `Cmd+Shift+]` | 下一個分頁 | 循環切換到右邊的分頁 |
| `Cmd+Shift+[` | 上一個分頁 | 循環切換到左邊的分頁 |

**使用技巧**:

```bash
# 專案組織範例
Tab 1 (Cmd+1): Claude Code - 主開發
Tab 2 (Cmd+2): Codex CLI - 輔助分析
Tab 3 (Cmd+3): npm run dev - 開發伺服器
Tab 4 (Cmd+4): npm test -- --watch - 測試監控
Tab 5 (Cmd+5): git status - 版本控制

# 快速切換
Cmd+1: 回到主開發 (Claude)
Cmd+3: 查看開發伺服器狀態
Cmd+4: 檢查測試結果
```

### Split 視窗管理

**分割快捷鍵**:

| 快捷鍵 | 功能 | 使用場景 |
|--------|------|---------|
| `Cmd+D` | 向右分割 | 並排比較（左右） |
| `Cmd+Shift+D` | 向下分割 | 上下對照 |
| `Cmd+W` | 關閉窗格 | 關閉當前分割窗格 |

**分割策略**:

```bash
# 水平比較（Cmd+D）
┌─────────────┬─────────────┐
│  Claude     │  Codex      │
│  (左)       │  (右)       │
└─────────────┴─────────────┘
用途: 比較兩個 AI 的回應

# 垂直分割（Cmd+Shift+D）
┌─────────────────────────┐
│  Claude Code            │
├─────────────────────────┤
│  測試輸出               │
└─────────────────────────┘
用途: 上方編碼，下方即時測試

# 複合分割
┌─────────────┬─────────────┐
│  Claude     │  Codex      │
│  (左)       │  (右)       │
├─────────────┴─────────────┤
│  測試結果 (底部)          │
└─────────────────────────┘
1. Cmd+D 先左右分割
2. 選擇右側窗格
3. Cmd+Shift+D 再向下分割
```

### 系統功能快捷鍵

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+Shift+Comma` | 重新載入配置 | 即時套用配置檔案更改 |
| `Cmd+Q` | 退出 Ghostty | 完全關閉應用程式 |
| `Cmd+N` | 新視窗 | 開啟新的 Ghostty 視窗 |

### 自訂快捷鍵

編輯 `~/Library/Application Support/com.mitchellh.ghostty/config`：

**快捷鍵格式**:
```bash
keybind = <modifier>+<key>=<action>

# 修飾鍵（modifier）
super    # macOS 的 Cmd 鍵
ctrl     # Control 鍵
alt      # Option/Alt 鍵
shift    # Shift 鍵

# 組合修飾鍵
super+shift
ctrl+alt
```

**範例**:

```bash
# 改變分割方向快捷鍵
keybind = super+d=new_split:down        # Cmd+D 改為向下分割
keybind = super+shift+d=new_split:right # Cmd+Shift+D 改為向右分割

# 新增自訂快捷鍵
keybind = super+k=clear_screen          # Cmd+K 清空螢幕
keybind = ctrl+shift+c=copy_to_clipboard # Ctrl+Shift+C 複製
keybind = ctrl+shift+v=paste_from_clipboard # Ctrl+Shift+V 貼上
```

**注意事項**:
- ⚠️ 修改後必須執行 `Cmd+Shift+Comma` 重新載入
- ⚠️ 檢查是否與系統快捷鍵衝突（系統偏好設定 → 鍵盤 → 快速鍵）
- ⚠️ 避免覆蓋常用的系統快捷鍵（如 `Cmd+C`, `Cmd+V`）

---

## 進階功能

### Shell Integration

**功能**: 追蹤命令狀態、工作目錄、執行結果

**配置**:
```bash
shell-integration = detect               # 自動偵測 shell 類型
shell-integration-features = cursor,sudo,title
```

**啟用的功能**:

1. **Cursor 形狀變化**:
   - 一般模式: 方塊游標
   - 插入模式: 豎線游標
   - 命令執行中: 底線游標

2. **Sudo 支援**:
   - 執行 `sudo` 命令時自動提示密碼
   - 無需手動輸入密碼多次

3. **Title 更新**:
   - 分頁標題自動顯示當前目錄
   - 顯示正在執行的命令

**驗證 Shell Integration 是否啟用**:

```bash
# 執行此命令，標題應顯示當前目錄
cd ~/Documents
# 分頁標題應更新為 "~/Documents"

# 執行長時間命令，標題應顯示命令名稱
npm install
# 分頁標題應顯示 "npm install"
```

### Copy on Select

**功能**: 選取文字自動複製到剪貼簿

**配置**:
```bash
copy-on-select = clipboard
```

**使用方式**:

1. 用滑鼠選取 AI 生成的代碼
2. 自動複製（無需 `Cmd+C`）
3. 直接 `Cmd+V` 貼上到編輯器

**優點**:
- ✅ 減少一個快捷鍵操作
- ✅ 符合直覺（選取即複製）
- ✅ 提升工作效率（特別是頻繁複製時）

**注意**:
- ⚠️ 若不習慣自動複製，可設為 `copy-on-select = false`

### Scrollback Buffer

**功能**: 儲存歷史輸出，方便回溯查看

**配置**:
```bash
scrollback-limit = 50000  # 預設 50,000 行
```

**調整建議**（根據 RAM 容量）:

| RAM 容量 | 建議值 | 用途 |
|---------|--------|------|
| < 8GB | 10,000-20,000 行 | 省記憶體，適合輕量使用 |
| 8-16GB | 50,000 行 | 預設值，平衡效能與容量 |
| 16GB+ | 100,000-200,000 行 | 大容量，適合長時間 AI 對話 |

**範例**:

```bash
# 輕量級配置（<8GB RAM）
scrollback-limit = 10000

# 高效能配置（16GB+ RAM）
scrollback-limit = 100000
```

**注意**:
- ⚠️ 數值越大，記憶體使用越多
- ⚠️ 每個分頁維護獨立的 scrollback buffer

### 視窗 Padding

**功能**: 調整視窗內容與邊框的間距

**配置**:
```bash
window-padding-x = 8  # 水平邊距（像素）
window-padding-y = 8  # 垂直邊距（像素）
```

**調整選項**:

```bash
# 無邊距（最大化內容空間）
window-padding-x = 0
window-padding-y = 0

# 緊湊（適合小螢幕）
window-padding-x = 4
window-padding-y = 4

# 預設（推薦，平衡美觀與空間）
window-padding-x = 8
window-padding-y = 8

# 寬鬆（適合大螢幕）
window-padding-x = 16
window-padding-y = 16
```

---

## 工作流程範例

完整的工作流程範例請參考 [工作流程範例](workflows.zh-TW.md)。

**快速範例**:

### 單一 AI 工具工作流程

```bash
# 分頁 1: Claude Code 主工作區
claude

# 分頁 2: 測試監控
# Cmd+T
npm test -- --watch

# 分頁 3: 開發伺服器
# Cmd+T
npm run dev

# 快速切換
Cmd+1: 回到 Claude 討論
Cmd+2: 查看測試結果
Cmd+3: 檢查伺服器狀態
```

### 多 AI 並行工作流程

```bash
# 分頁 1: Claude Code（主要開發）
claude

# 分頁 2: Codex CLI（輔助分析）
# Cmd+T
codex

# 需要比較？使用 split
# 在分頁 1 按 Cmd+D
# 左側: Claude Code
# 右側: codex
```

詳細的工作流程策略和最佳實踐，請參考 [工作流程範例](workflows.zh-TW.md)。

---

## 效能優化

### 記憶體管理

**推薦配置組合**（根據系統 RAM）:

```bash
# 輕量級（<8GB RAM）
scrollback-limit = 10000
# 建議: 3-5 個分頁

# 標準（8-16GB RAM）
scrollback-limit = 50000
# 建議: 5-8 個分頁

# 高效能（16GB+ RAM）
scrollback-limit = 100000
# 建議: 8-12 個分頁
```

### Tab/Split 管理建議

**最佳實踐**:

| 數量 | 狀態 | 建議 |
|------|------|------|
| 3-5 個分頁 | ✅ 正常 | 舒適使用 |
| 6-10 個分頁 | ⚠️ 注意 | 定期清理不活躍的分頁 |
| >10 個分頁 | 🔴 建議清理 | 影響效能，考慮使用多視窗 |
| 2-3 個 split | ✅ 正常 | 適合比較 |
| >3 個 split | ⚠️ 注意 | 降低可讀性 |

**優化策略**:

```bash
# 1. 定期清理完成的分頁
Cmd+W 關閉不需要的分頁

# 2. 優先使用分頁而非過多 split
分頁 > split（當需要保留歷史記錄時）

# 3. 長時間運行的任務放在獨立分頁
監控、日誌 → 獨立分頁
臨時測試 → split 即可

# 4. 使用多視窗分離專案
專案 A → 視窗 1（分頁 1-3）
專案 B → 視窗 2（分頁 1-3）
Cmd+Shift+T 開新視窗
```

---

## 常見問題

### Q1: Ghostty 找不到配置檔案

**解決方法**: 手動創建目錄

```bash
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty
cp ~/Documents/GitHub/VibeGhostty/config \
   ~/Library/Application\ Support/com.mitchellh.ghostty/
```

### Q2: 字體沒有正確顯示

**檢查步驟**:

1. 確認 Nerd Font 已安裝
   ```bash
   ls ~/Library/Fonts/ | grep -i jetbrains
   ```

2. 重新安裝字體
   ```bash
   brew reinstall --cask font-jetbrains-mono-nerd-font
   ```

3. 完全重啟 Ghostty
   ```bash
   pkill -9 ghostty && open -a Ghostty
   ```

### Q3: 快捷鍵不工作

**可能原因**:
- 與系統快捷鍵衝突
- 配置檔案語法錯誤
- Ghostty 版本過舊

**解決方法**:

1. 檢查系統偏好設定 → 鍵盤 → 快速鍵
2. 驗證配置檔案無錯誤
   ```bash
   cat ~/Library/Application\ Support/com.mitchellh.ghostty/config
   ```
3. 更新 Ghostty 到最新版本
   ```bash
   brew upgrade --cask ghostty
   ```

更多問題解決方案，請參考 [故障排除](troubleshooting.zh-TW.md)。

---

## 延伸閱讀

**進階主題**:
- [Tmux 使用指南](tmux-guide.zh-TW.md) - Tmux 工作空間整合
- [工作流程範例](workflows.zh-TW.md) - AI 協作實戰
- [自訂配置](customization.zh-TW.md) - 深度自訂指南

**問題排除**:
- [故障排除](troubleshooting.zh-TW.md) - 完整問題解決方案

**官方資源**:
- [Ghostty 官方文檔](https://ghostty.org/docs) - Ghostty 完整參考
- [Ghostty 配置參考](https://ghostty.org/docs/config) - 所有配置選項
- [Nerd Fonts 官網](https://www.nerdfonts.com/) - 字體下載與說明
- [Tokyo Night 主題](https://github.com/enkia/tokyo-night-vscode-theme) - 配色方案

**社群資源**:
- [VibeGhostty GitHub](https://github.com/frankekn/VibeGhostty) - 專案首頁
- [提交問題](https://github.com/frankekn/VibeGhostty/issues) - 報告錯誤或建議

---

**享受高效的 AI 協作體驗！** 🚀
