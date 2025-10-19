# AI 協作工作流程範例

**版本**: 1.1.0
**最後更新**: 2025-10-19
**預估閱讀時間**: 10 分鐘
**前置閱讀**: [Ghostty 快速開始](../../QUICKSTART.md) 或 [Tmux 使用指南](../../TMUX_GUIDE.md)

---

## 目錄

1. [工作流程概覽](#工作流程概覽)
2. [工作流程 1: Claude Code + Codex CLI 並行開發](#工作流程-1-claude-code--codex-cli-並行開發)
3. [工作流程 2: AI 建議並排比較](#工作流程-2-ai-建議並排比較)
4. [工作流程 3: 深度專注模式](#工作流程-3-深度專注模式)
5. [工作流程 4: 多專案並行管理](#工作流程-4-多專案並行管理)
6. [工作流程 5: 測試驅動開發 (TDD)](#工作流程-5-測試驅動開發-tdd)
7. [選擇合適的工作流程](#選擇合適的工作流程)

---

## 工作流程概覽

VibeGhostty 提供 **Ghostty** 和 **Tmux** 兩種工具組合，適用於不同複雜度的 AI 協作場景。本指南提供 5 個實戰工作流程範例，幫助你快速上手。

### 工具選擇快速參考

| 場景 | 推薦工具 | 原因 |
|------|---------|------|
| 簡單任務、臨時測試 | Ghostty Tabs | 設定快速、視覺清晰 |
| 複雜專案、需持久化 | Tmux Sessions | 可 detach、布局靈活 |
| 並排比較 AI 建議 | Ghostty Splits 或 Tmux Compare | 兩者皆可 |
| 多專案同時開發 | Tmux Sessions | Session 隔離、易切換 |
| 需要保持執行狀態 | Tmux Sessions | Detach 後繼續運行 |

---

## 工作流程 1: Claude Code + Codex CLI 並行開發

### 場景描述

同時使用兩個 AI 工具進行開發：
- **Claude Code**: 負責架構設計、程式碼審查
- **Codex CLI**: 負責快速實作、程式碼生成

### 方法 A: Ghostty Tab 模式（簡單專案）

**適用情況**: 單一專案、任務簡單、不需要持久化

**設定步驟**:

```bash
# Tab 1: 啟動 Claude Code
claude

# Cmd+T 創建新 tab
# Tab 2: 啟動 Codex CLI
codex

# Cmd+T 創建第三個 tab
# Tab 3: 監控測試
npm test -- --watch

# 使用 Cmd+1/2/3 快速切換
```

**工作區布局**:

```
┌─────────┬─────────┬─────────┐
│ Tab 1   │ Tab 2   │ Tab 3   │
│ Claude  │ Codex   │ Tests   │
│ Code    │ CLI     │         │
└─────────┴─────────┴─────────┘
```

**實際工作流程**:

1. **Tab 1 (Claude)**: 詢問架構設計
   ```
   > "我想建立一個使用者認證系統，應該如何設計？"
   ```

2. **Tab 2 (Codex)**: 實作 Claude 建議的架構
   ```
   > "根據 JWT 架構，幫我實作登入 API"
   ```

3. **Tab 3 (Tests)**: 持續監控測試結果
   ```bash
   npm test -- --watch
   # 看到測試失敗立即知道問題
   ```

4. **快速切換**:
   - `Cmd+1`: 回到 Claude 詢問問題
   - `Cmd+2`: 切換到 Codex 繼續實作
   - `Cmd+3`: 查看測試狀態

**優點**:
- ✅ 設定簡單，無需學習 Tmux
- ✅ 視覺清晰，tab 標題明確
- ✅ 適合短期任務

**缺點**:
- ❌ 無法持久化（關閉 Ghostty 即遺失）
- ❌ 無法彈性調整窗格大小

---

### 方法 B: Tmux Session 模式（複雜專案）

**適用情況**: 多專案並行、需要持久化、複雜布局

**設定步驟**:

```bash
# 啟動 AI Workspace 布局
~/.tmux-layouts/ai-workspace.sh

# 或使用互動式選單
tmux-launch
# → 選擇 "1. AI Workspace"
```

**工作區布局**:

```
┌─────────────────────────┬─────────────┐
│   Codex CLI (70%)       │  Claude     │
│   主要實作工作區        │  Code (30%) │
│   - 程式碼生成          │  - 審查建議 │
│   - 快速迭代            │  - 架構指導 │
│                         ├─────────────┤
│                         │  Monitor    │
│                         │  - 測試結果 │
│                         │  - Git 狀態 │
└─────────────────────────┴─────────────┘
```

**實際操作流程**:

```bash
# 窗格 1 (左側 70%): Codex 實作
Ctrl+Space 1                    # 跳到主工作區
codex
> "幫我實作 user authentication"

# 窗格 2 (右上 30%): Claude 審查
Ctrl+Space 2                    # 跳到輔助區
claude
> "審查這個 auth 實作的安全性"

# 窗格 3 (右下 30%): 監控
Ctrl+Space 3                    # 跳到監控區
npm test -- --watch
# 持續監控測試結果
```

**核心快捷鍵**:

| 快捷鍵 | 功能 | 使用時機 |
|--------|------|---------|
| `Ctrl+Space 1` | 跳到 Codex CLI | 主要編碼工作 |
| `Ctrl+Space 2` | 跳到 Claude Code | 獲取建議、審查 |
| `Ctrl+Space 3` | 跳到監控窗格 | 查看測試、Git 狀態 |
| `Ctrl+Space z` | 窗格全屏切換 | 專注某個窗格 |
| `Ctrl+Space d` | Detach session | 暫時離開、保持執行 |

**最佳實踐**:

1. **主工作區 (70%)**: 用於主要編碼和 AI 對話
2. **輔助區 (30%)**: 用於第二意見、架構建議
3. **監控區**: 保持測試或 Git 狀態可見

**優點**:
- ✅ 持久化（可 detach 後繼續執行）
- ✅ 黃金比例布局（70/30）符合視覺習慣
- ✅ 快捷鍵快速切換窗格
- ✅ 適合長期專案

**缺點**:
- ⚠️ 初次設定需要學習 Tmux 快捷鍵

---

## 工作流程 2: AI 建議並排比較

### 場景描述

對於關鍵決策（如架構選擇、演算法設計），同時諮詢兩個 AI 工具，並排比較建議。

### 方法 A: Ghostty Split 模式

**設定步驟**:

```bash
# 開啟 Ghostty
ghostty

# 啟動 Claude Code
claude

# Cmd+D 向右分割
# 啟動 Codex CLI
codex
```

**視覺布局**:

```
┌──────────────────┬──────────────────┐
│  Claude Code     │  Codex CLI       │
│  (50%)           │  (50%)           │
│                  │                  │
│  > 問題:         │  > 問題:         │
│  如何實作快取？  │  如何實作快取？  │
│                  │                  │
│  建議 A:         │  建議 B:         │
│  使用 Redis      │  使用 Memory     │
└──────────────────┴──────────────────┘
```

**使用範例**:

**情境: 選擇快取策略**

```
左側 (Claude):
> "React 應用中，如何實作高效的資料快取？"

回答: 建議使用 React Query + Redux
- 優點: 自動背景更新、錯誤處理
- 缺點: 增加依賴、學習曲線

右側 (Codex):
> "React 應用中，如何實作高效的資料快取？"

回答: 建議使用 SWR
- 優點: 輕量、API 簡單
- 缺點: 功能較少

決策: 根據專案規模選擇
- 小型專案 → SWR
- 大型專案 → React Query
```

---

### 方法 B: Tmux AI Compare 模式

**設定步驟**:

```bash
# 啟動 AI Compare 布局
~/.tmux-layouts/ai-compare.sh
```

**視覺布局**:

```
┌────────────────┬────────────────┐
│  Codex CLI     │  Claude Code   │
│  (50%)         │  (50%)         │
│                │                │
│  問題: ...     │  問題: ...     │
│  方案 A        │  方案 B        │
├────────────────┴────────────────┤
│  Compare/Monitor (25%)          │
│  - 實際測試兩種方案              │
│  - 記錄決策理由                  │
└─────────────────────────────────┘
```

**實際使用案例**:

**案例 1: 演算法比較**

```bash
# 左右窗格輸入相同問題
問題: "實作一個高效的陣列去重函式"

左側 (Codex):
const unique = arr => [...new Set(arr)];
# 優點: 簡潔、ES6 標準
# 缺點: 不支援物件去重

右側 (Claude):
const unique = arr => arr.filter((v, i, a) => a.indexOf(v) === i);
# 優點: 相容性好、易理解
# 缺點: O(n²) 複雜度

# 底部窗格: 實際測試
Ctrl+Space 3
node benchmark.js
# 測試結果: Set 方法快 10 倍
# 決策: 使用 Set 方法
```

**案例 2: API 設計**

```bash
問題: "設計一個 RESTful API 處理使用者認證"

左側 (Codex):
POST /auth/login
POST /auth/logout
POST /auth/refresh

右側 (Claude):
POST /api/v1/sessions      # 登入
DELETE /api/v1/sessions    # 登出
POST /api/v1/tokens/refresh

# 比較重點
- URL 命名風格（動詞 vs 名詞）
- 版本控制（有 vs 無）
- RESTful 程度

# 決策: Claude 的方案更符合 REST 原則
```

**最佳實踐**:
1. 左右窗格輸入**完全相同**的問題
2. 仔細比較**思考過程**和**最終方案**
3. 在監控窗格**實際測試**兩種方案
4. 記錄決策理由（為何選 A 而非 B）

---

## 工作流程 3: 深度專注模式

### 場景描述

需要深度思考或長時間與單一 AI 工具互動，減少視覺干擾。

### Tmux Full Focus 模式

**設定步驟**:

```bash
# 預設使用 Codex
~/.tmux-layouts/full-focus.sh

# 指定使用 Claude
~/.tmux-layouts/full-focus.sh ~/my-project claude
```

**視覺布局**:

```
┌─────────────────────────────────┐
│  Claude Code (100%)             │
│                                 │
│  專注於單一任務：               │
│  - 複雜問題分析                 │
│  - 大規模重構                   │
│  - 深度學習新技術               │
│                                 │
│  無干擾、全屏幕                 │
└─────────────────────────────────┘
```

**使用時機**:

| 任務類型 | 為何需要 Full Focus |
|---------|-------------------|
| 學習新框架 | 需要連續對話、深入理解 |
| 複雜問題分析 | 多輪對話、邏輯推理 |
| 大規模重構 | 長時間專注、避免干擾 |
| 架構設計 | 深度思考、系統性規劃 |

**實際案例: 學習 Rust**

```bash
# 啟動 Full Focus
~/.tmux-layouts/full-focus.sh ~/learning/rust claude

# 連續對話流程
> "我是 JavaScript 開發者，如何開始學習 Rust？"
> "Ownership 概念與 JavaScript 的垃圾回收有何不同？"
> "請給我一個 Rust 的實際範例，包含 borrowing"
> "這個範例中，為何需要使用 &？"
# ... 持續深入對話

# 需要測試程式碼時
Ctrl+Space |        # 臨時分割右側視窗
rustc example.rs
./example

# 測試完畢
Ctrl+Space x        # 關閉測試視窗
# 回到全屏專注
```

**專注模式哲學**:

單一 AI、單一任務、深度思考。

**彈性使用**:

```bash
# 在 Full Focus 中，隨時可以臨時分割
Ctrl+Space |    # 垂直分割（右側）
Ctrl+Space -    # 水平分割（下方）

# 完成後關閉分割
Ctrl+Space x    # 關閉當前窗格

# 或使用 Zoom 切換
Ctrl+Space z    # 全屏當前窗格
# 工作完畢
Ctrl+Space z    # 還原布局
```

---

## 工作流程 4: 多專案並行管理

### Tmux Session 隔離策略

**設定**:

```bash
# 專案 A: VibeGhostty
cd ~/projects/vibeghostty
~/.tmux-layouts/ai-workspace.sh
# Session 自動命名為 "ai-vibeghostty"

Ctrl+Space d        # Detach

# 專案 B: Blog 網站
cd ~/projects/blog
~/.tmux-layouts/ai-workspace.sh
# Session 自動命名為 "ai-blog"

Ctrl+Space d        # Detach

# 專案 C: API Server
cd ~/projects/api-server
~/.tmux-layouts/ai-workspace.sh
# Session 自動命名為 "ai-api-server"
```

**Session 管理**:

```bash
# 查看所有 sessions
tmux list-sessions
# 或使用快捷鍵
Ctrl+Space s

# 輸出範例:
# ai-vibeghostty: 3 windows (created Mon Oct 19 10:30:00 2025)
# ai-blog: 3 windows (created Mon Oct 19 11:15:00 2025)
# ai-api-server: 3 windows (created Mon Oct 19 14:00:00 2025)

# 快速切換到特定專案
tmux attach -t ai-blog

# 或使用 ta 命令（智能 attach）
ta -n ai-blog
```

**工作流程架構**:

```
Session: ai-vibeghostty
├─ Pane 1: Codex CLI (vibeghostty 開發)
├─ Pane 2: Claude Code (文檔審查)
└─ Pane 3: npm test

Session: ai-blog
├─ Pane 1: Codex CLI (部落格功能)
├─ Pane 2: Claude Code (內容建議)
└─ Pane 3: gatsby develop

Session: ai-api-server
├─ Pane 1: Codex CLI (API 開發)
├─ Pane 2: Claude Code (架構設計)
└─ Pane 3: pytest --watch
```

**快速切換技巧**:

```bash
# 方法 1: 使用 ta 命令
ta -l                   # 列出所有 sessions
ta -n ai-blog          # 切換到 blog 專案

# 方法 2: 使用 Tmux 內建
Ctrl+Space s           # 顯示 session 列表
# 上下鍵選擇，Enter 切換

# 方法 3: 使用快捷鍵
Ctrl+Space (           # 切換到上一個 session
Ctrl+Space )           # 切換到下一個 session
```

**最佳實踐**:

1. **命名規範**: 一個專案一個 session，命名與專案目錄一致
2. **使用 `ta` 智能 attach**: 自動偵測當前目錄專案
3. **定期清理**: 完成的專案及時 `tmux kill-session -t <name>`

---

## 工作流程 5: 測試驅動開發 (TDD)

### Tmux 3-Pane 布局

**設定**:

```bash
# 使用 AI Workspace 布局
~/.tmux-layouts/ai-workspace.sh
```

**布局分工**:

```
┌─────────────────┬─────────────┐
│  Codex CLI      │  Claude     │
│  寫實作程式碼   │  Code       │
│                 │  寫測試     │
├─────────────────┼─────────────┤
│  Test Watcher   │             │
│  持續監控       │             │
└─────────────────┴─────────────┘
```

**TDD 工作流程**:

**步驟 1: Claude 先寫測試（紅燈）**

```bash
Ctrl+Space 2        # 跳到 Claude Code
claude

> "我要實作一個 add(a, b) 函式，請先寫測試"

# Claude 生成測試
test('add should return sum of two numbers', () => {
  expect(add(2, 3)).toBe(5);
  expect(add(-1, 1)).toBe(0);
});

# 複製測試到專案
```

**步驟 2: 啟動測試監控（看到紅燈）**

```bash
Ctrl+Space 3        # 跳到監控窗格
npm test -- --watch

# 輸出: FAIL - add is not defined
```

**步驟 3: Codex 實作功能（綠燈）**

```bash
Ctrl+Space 1        # 跳到 Codex CLI
codex

> "根據測試，實作 add 函式"

# Codex 生成實作
const add = (a, b) => a + b;

# 儲存檔案
```

**步驟 4: 查看測試通過（綠燈）**

```bash
# 監控窗格自動顯示
# 輸出: PASS - 2 tests passed
```

**步驟 5: Claude 重構（保持綠燈）**

```bash
Ctrl+Space 2        # 跳到 Claude
> "這個實作可以改進嗎？加入型別檢查"

# Claude 建議
const add = (a, b) => {
  if (typeof a !== 'number' || typeof b !== 'number') {
    throw new TypeError('Both arguments must be numbers');
  }
  return a + b;
};

# 更新程式碼，測試依然通過
```

**循環流程**:

```
1. Claude 寫測試 (紅燈)
   ↓
2. Codex 實作功能 (綠燈)
   ↓
3. Claude 重構 (保持綠燈)
   ↓
4. 監控窗格持續顯示測試狀態
   ↓
5. 重複步驟 1-4
```

---

## 選擇合適的工作流程

### 決策樹

```
你的需求是什麼？
│
├─ 簡單任務，單一專案
│  └─ 使用 Ghostty Tabs（Cmd+1/2/3）
│
├─ 需要並排比較 AI 建議
│  ├─ 暫時性比較 → Ghostty Splits（Cmd+D）
│  └─ 需要持久化 → Tmux AI Compare
│
├─ 深度專注，單一 AI 工具
│  └─ Tmux Full Focus
│
├─ 複雜專案，多工作區
│  └─ Tmux AI Workspace (70/30)
│
└─ 多專案並行開發
   └─ Tmux Sessions（每專案一個 session）
```

### 工具選擇矩陣

| 場景 | Ghostty | Tmux | 原因 |
|------|---------|------|------|
| 快速實驗 | ✅ | ❌ | Tabs 快速切換 |
| 長期專案 | ❌ | ✅ | Session 持久化 |
| 並排比較 | ✅ Splits | ✅ Compare | 兩者皆可 |
| 多專案並行 | ⚠️ 可行但混亂 | ✅ | Session 隔離 |
| 需要保持執行 | ❌ | ✅ | Tmux detach 功能 |
| TDD 工作流程 | ⚠️ 可行 | ✅ | 3-pane 布局更適合 |

---

## 延伸閱讀

**基礎知識**:
- [Ghostty 使用指南](../../GUIDE.md) - Ghostty 完整功能說明
- [Tmux 使用指南](../../TMUX_GUIDE.md) - Tmux 深度指南

**進階主題**:
- [自訂配置](customization.zh-TW.md) - 調整布局、主題、快捷鍵
- [故障排除](troubleshooting.zh-TW.md) - 常見問題解決

**實戰工具**:
- `tmux-launch` - 互動式布局選擇
- `ta` - 智能 session 管理
- `vibe-help` - 快捷鍵速查

---

**文檔版本**: 1.1.0
**最後更新**: 2025-10-19
**貢獻者**: Claude Code

祝你享受高效的 AI 協作工作流程！ 🚀
