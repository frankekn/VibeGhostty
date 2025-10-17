# 使用指南

完整的 VibeGhostty 使用說明和最佳實踐。

---

## 📖 目錄

- [快捷鍵完整列表](#快捷鍵完整列表)
- [工作流程範例](#工作流程範例)
- [配置自訂](#配置自訂)
- [效能優化](#效能優化)
- [進階技巧](#進階技巧)

---

## ⌨️ 快捷鍵完整列表

### Tab 管理

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+T` | 新建 tab | 在當前視窗創建新 tab |
| `Cmd+W` | 關閉 tab | 關閉當前 tab 或 split |
| `Cmd+Shift+T` | 新視窗 | 開啟全新的 Ghostty 視窗 |
| `Cmd+1` | 跳轉 tab 1 | 快速跳轉到第一個 tab |
| `Cmd+2` | 跳轉 tab 2 | 快速跳轉到第二個 tab |
| `Cmd+3` | 跳轉 tab 3 | 快速跳轉到第三個 tab |
| `Cmd+4` | 跳轉 tab 4 | 快速跳轉到第四個 tab |
| `Cmd+5` | 跳轉 tab 5 | 快速跳轉到第五個 tab |
| `Cmd+6` | 跳轉 tab 6 | 快速跳轉到第六個 tab |
| `Cmd+7` | 跳轉 tab 7 | 快速跳轉到第七個 tab |
| `Cmd+8` | 跳轉 tab 8 | 快速跳轉到第八個 tab |
| `Cmd+9` | 跳轉 tab 9 | 快速跳轉到第九個 tab |
| `Cmd+Shift+]` | 下一個 tab | 循環切換到右邊的 tab |
| `Cmd+Shift+[` | 上一個 tab | 循環切換到左邊的 tab |

### Split 視窗

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+D` | 向右分割 | 將當前視窗分割為左右兩部分 |
| `Cmd+Shift+D` | 向下分割 | 將當前視窗分割為上下兩部分 |

### 系統功能

| 快捷鍵 | 功能 | 說明 |
|--------|------|------|
| `Cmd+Shift+Comma` | 重新載入配置 | 即時套用配置文件更改 |
| `Cmd+Q` | 退出 Ghostty | 完全關閉應用程式 |

---

## 🎯 工作流程範例

### 1. Claude Code + Codex CLI 並行工作

**適用場景**：需要同時使用兩個 AI 工具輔助開發

```bash
# Tab 1 - Claude Code 主工作區
claude

# Cmd+T 開新 tab
# Tab 2 - Codex CLI 代碼分析
codex

# Tab 3 - 測試監控
npm test -- --watch

# 快速切換
# Cmd+1: 回到 Claude Code
# Cmd+2: 查看 Codex 分析
# Cmd+3: 檢查測試結果
```

**工作區標記**：
```
Tab 1: 🤖 Claude Code - 主開發
Tab 2: 🔧 Codex CLI - 分析
Tab 3: ✅ Tests - 監控
```

### 2. 並排比較 AI 輸出

**適用場景**：需要同時查看兩個 AI 的回應進行比較

```bash
# 開啟 Claude Code
claude

# Cmd+D 向右分割
# 左側：Claude Code
# 右側：執行 codex

# 現在可以並排比較兩個 AI 的輸出
```

**優點**：
- 即時比較不同 AI 的建議
- 無需切換 tab
- 適合做決策分析

### 3. 多專案平行開發

**適用場景**：同時處理多個專案

```bash
# 專案組織
Tab 1-2: 專案 A
  Tab 1: Claude Code - 專案 A 開發
  Tab 2: npm run dev - 專案 A 伺服器

Tab 3-4: 專案 B
  Tab 3: Codex CLI - 專案 B 分析
  Tab 4: pytest --watch - 專案 B 測試

Tab 5: 共用工具
  Tab 5: 監控、日誌、資料庫等

# 快速跳轉
Cmd+1: 專案 A 開發
Cmd+3: 專案 B 分析
Cmd+5: 查看監控
```

### 4. AI 輸出研究模式

**適用場景**：深入研究 AI 生成的解決方案

```bash
# Tab 1: Claude Code 生成解決方案
claude
# 讓 AI 生成完整方案

# Cmd+D: 分割視窗測試方案
# 在右側測試 AI 生成的代碼

# 發現問題？
# Cmd+W 關閉右側測試視窗
# 回到左側 Claude 繼續討論

# Tab 2: 文檔查詢
# Cmd+T 開新 tab
# 查詢相關技術文檔

# Cmd+1/2 快速切換確認
```

### 5. Debug 工作流程

**適用場景**：使用 AI 輔助 debug

```bash
# Tab 1: Claude Code - 主要 debug 對話
claude
# 向 AI 描述問題

# Tab 2: 執行和測試
# Cmd+T
# 執行 AI 建議的修正

# Tab 3: 日誌監控
# Cmd+T
tail -f app.log

# Split 比較
# Cmd+D 在 Tab 1 分割
# 左側：Claude 建議
# 右側：實際程式碼

# 快速迭代
# Cmd+1: 看 AI 建議
# Cmd+2: 測試執行
# Cmd+3: 查看日誌
```

---

## 🔧 配置自訂

### 調整字體大小

編輯 `~/Library/Application Support/com.mitchellh.ghostty/config`：

```bash
# 當前設定
font-size = 13

# 調整選項
font-size = 11  # 極小（適合高解析度螢幕）
font-size = 12  # 較小
font-size = 13  # 預設（推薦）
font-size = 14  # 較大
font-size = 15  # 大（適合遠距離閱讀）
```

重新載入：`Cmd+Shift+Comma`

### 更換字體

```bash
# 安裝其他 Nerd Font
brew install --cask font-fira-code-nerd-font
brew install --cask font-hack-nerd-font
brew install --cask font-meslo-lg-nerd-font

# 修改配置
font-family = Fira Code      # 連字支援
font-family = Hack           # 簡潔風格
font-family = Meslo LG       # 傳統風格
```

### 調整行高

```bash
# 當前設定
adjust-cell-height = 15%

# 調整選項
adjust-cell-height = 0%      # 標準行高
adjust-cell-height = 10%     # 緊湊
adjust-cell-height = 15%     # 預設（推薦）
adjust-cell-height = 20%     # 寬鬆
adjust-cell-height = 25%     # 極寬鬆
```

### 調整 Scrollback

```bash
# 當前設定
scrollback-limit = 50000

# 根據需求調整
scrollback-limit = 10000     # 省記憶體
scrollback-limit = 50000     # 預設（推薦）
scrollback-limit = 100000    # 大容量
scrollback-limit = 200000    # 極大（需注意記憶體）
```

### 視窗 Padding

```bash
# 當前設定
window-padding-x = 8
window-padding-y = 8

# 調整選項
window-padding-x = 0         # 無邊距
window-padding-y = 0

window-padding-x = 4         # 緊湊
window-padding-y = 4

window-padding-x = 8         # 預設（推薦）
window-padding-y = 8

window-padding-x = 16        # 寬鬆
window-padding-y = 16
```

---

## 🚀 效能優化

### 記憶體管理

**推薦配置組合**：

```bash
# 輕量級（<8GB RAM）
scrollback-limit = 10000

# 標準（8-16GB RAM）
scrollback-limit = 50000

# 高效能（16GB+ RAM）
scrollback-limit = 100000
```

### Tab/Split 管理建議

**最佳實踐**：

1. **3-5 個 Tab**：正常使用 ✅
2. **6-10 個 Tab**：注意記憶體 ⚠️
3. **>10 個 Tab**：建議清理 🔴

**原因**：
- 每個 tab 維護獨立的 scrollback buffer
- Split 會共享資源但增加渲染負擔

**優化策略**：
```bash
# 定期清理完成的 tab
Cmd+W 關閉不需要的 tab

# 優先使用 tab 而非過多 split
Tab > Split（當需要保留歷史記錄時）

# 長時間運行的任務放在獨立 tab
監控、日誌 → 獨立 tab
臨時測試 → split 即可
```

---

## 💡 進階技巧

### 1. 選取即複製

**功能**：選取文字自動複製到剪貼簿

```bash
# 配置中已啟用
copy-on-select = clipboard

# 使用方式
1. 用滑鼠選取 AI 生成的代碼
2. 自動複製（無需 Cmd+C）
3. 直接 Cmd+V 貼上
```

### 2. Shell Integration

**功能**：追蹤命令狀態和工作目錄

```bash
# 配置中已啟用
shell-integration = detect
shell-integration-features = cursor,sudo,title

# 好處
- Tab 標題自動顯示當前目錄
- 命令執行狀態追蹤
- 更好的 sudo 支援
```

### 3. 快速原型測試

**工作流程**：

```bash
# Tab 1: Claude Code 討論方案
claude

# Cmd+D: 右側測試
# 快速測試 AI 建議

# 有用？保留程式碼
# 沒用？Cmd+W 關閉 split
# 繼續討論新方案
```

### 4. 多重 Ghostty 視窗

**適用場景**：不同專案或客戶

```bash
# 視窗 1：個人專案
Cmd+1~3: 不同 tab

# Cmd+Shift+T: 新視窗
# 視窗 2：工作專案
Cmd+1~3: 不同 tab

# 好處
- 完全分離的工作空間
- 獨立的 tab 組織
- 可在不同桌面
```

### 5. 配色主題自訂

**當前主題**：Tokyo Night Storm

**自訂方式**：

編輯 `config` 文件中的色彩：

```bash
# 背景/前景
background = 24283b
foreground = c0caf5

# Cursor
cursor-color = ff9e64

# ANSI 色彩
palette = 0=#1d202f
palette = 1=#f7768e
# ... 等等
```

**流行主題方案**：
- **Catppuccin Mocha**: 柔和莫蘭迪色
- **Nord**: 冷色調極簡風
- **Dracula**: 高對比度紫色系
- **Gruvbox**: 暖色調復古風

---

## 📚 最佳實踐總結

### ✅ 推薦做法

1. **專案分離** - 每個專案使用獨立 tab
2. **Agent 分類** - Claude Code (Tab 1), Codex (Tab 2), 測試 (Tab 3)
3. **Split 用於比較** - 需要並排查看時才用 split
4. **定期清理** - 完成的任務及時關閉 tab
5. **善用快捷鍵** - Cmd+1~9 比滑鼠點擊快 10 倍

### ❌ 避免做法

1. **過多 Split** - 超過 3 個 split 會降低可讀性
2. **忘記關閉 Tab** - 累積太多 tab 影響效能
3. **全螢幕模式** - 失去 tab bar 不利快速切換
4. **忽略 Scrollback** - 設定太小會遺失重要輸出

---

## 🎓 學習曲線

### 第一週：基礎操作

- [ ] 熟悉 `Cmd+T` 和 `Cmd+W`
- [ ] 學會 `Cmd+1~9` 快速跳轉
- [ ] 嘗試 `Cmd+D` split 功能

### 第二週：工作流程

- [ ] 建立個人的 tab 組織系統
- [ ] 練習 Claude Code + Codex 並行
- [ ] 優化自己的快捷鍵習慣

### 第三週：進階技巧

- [ ] 自訂配色和字體
- [ ] 建立多專案工作流程
- [ ] 掌握 split 的使用時機

### 第四週：效能優化

- [ ] 調整 scrollback 適合自己的需求
- [ ] 優化 tab/split 數量
- [ ] 建立高效的工作模式

---

## 📞 獲取幫助

- 查看 [安裝指南](INSTALL.md)
- 查看 [Ghostty 官方文檔](https://ghostty.org/docs)
- 提交 [GitHub Issue](https://github.com/frankekn/VibeGhostty/issues)

---

**享受高效的 AI 協作體驗！** 🚀
