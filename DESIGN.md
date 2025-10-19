# vibe-start 設計文檔

**專案**: VibeGhostty - 智能專案啟動系統
**版本**: 1.0.0-MVP
**作者**: Frank Yang
**最後更新**: 2025-10-19

> **設計哲學**: 從零配置開始，漸進式增強。遵循 YAGNI (You Aren't Gonna Need It) 原則，僅實作確實需要的功能。

---

## 📋 目錄

- [專案概述](#專案概述)
- [MVP 範圍](#mvp-範圍)
- [技術架構](#技術架構)
- [配置系統](#配置系統)
- [專案偵測](#專案偵測)
- [布局生成](#布局生成)
- [命令 API](#命令-api)
- [實施路線圖](#實施路線圖)

---

## 專案概述

### 問題陳述

現有 VibeGhostty 提供優秀的終端配置和 Tmux 布局系統，但缺乏「專案感知」能力：
- ❌ 用戶需要手動選擇布局
- ❌ 需要手動執行多個命令（dev server, tests, db tools）
- ❌ 每次啟動專案都重複相同操作
- ❌ 缺乏專案類型智能識別

### 解決方案

`vibe-start` - 一行命令啟動完整開發環境：

```bash
# 傳統方式（8+ 步驟，2-3 分鐘）
cd my-project
tmux new -s my-project
# 手動分割 panes...
claude
# 切換 pane
npm run dev
# ...更多手動操作

# vibe-start 方式（1 步驟，< 5 秒）
cd my-project
vibe-start
# 完成！
```

### 核心價值

1. **零配置啟動** - 90% 場景無需任何配置
2. **智能偵測** - 自動識別專案類型和推薦布局
3. **快速啟動** - < 5 秒完成環境準備
4. **低學習成本** - 新用戶 < 1 分鐘上手

---

## MVP 範圍

### v1.0 目標（1-2 週完成）

**核心功能**：
- ✅ 偵測 3-5 種主流專案類型（Next.js, Node.js, Python）
- ✅ 單一布局生成（ai-workspace）
- ✅ Port 衝突檢查（3000, 5432）
- ✅ 互動式預覽和確認
- ✅ 基礎錯誤處理

**明確不做**（v1.1+）：
- ❌ 多模式支援（dev, debug, review）
- ❌ 自訂模板系統
- ❌ 記憶系統
- ❌ 配置文件（.vibeproject）
- ❌ 進階健康檢查
- ❌ Post-start actions
- ❌ Hooks 系統

### 功能優先級矩陣

| 功能 | 價值 | 成本 | 風險 | MVP分數 | 版本 |
|------|------|------|------|---------|------|
| 零配置啟動 | 10 | 4 | 2 | 9.0 | v1.0 |
| 專案類型偵測 | 10 | 4 | 3 | 8.7 | v1.0 |
| package.json 解析 | 9 | 3 | 2 | 8.3 | v1.0 |
| Port 衝突檢查 | 8 | 2 | 1 | 8.7 | v1.0 |
| 互動式預覽 | 6 | 3 | 2 | 5.7 | v1.0 |
| 記憶系統 | 7 | 5 | 3 | 6.0 | v1.1 |
| .vibeproject 支援 | 9 | 6 | 4 | 6.3 | v1.1 |
| 多模式支援 | 8 | 7 | 5 | 4.7 | v1.1 |
| 自訂模板系統 | 6 | 8 | 6 | 2.7 | v2.0 |
| Hooks 系統 | 5 | 7 | 5 | 1.7 | v2.0 |

**評分公式**: `MVP分數 = (價值 × 2 - 成本 - 風險) / 3`

---

## 技術架構

### 核心組件

```
vibe-start (主執行檔)
├── lib/
│   ├── detect_project.sh      # 專案類型偵測
│   ├── parse_package_json.sh  # 命令解析
│   ├── check_port.sh           # Port 檢查
│   ├── generate_layout.sh      # 布局生成
│   └── show_preview.sh         # 互動式預覽
└── tests/
    ├── test_detect.sh
    ├── test_nextjs.sh
    └── test_python.sh
```

### 執行流程（MVP）

```bash
vibe-start
│
├─ 1. 偵測專案類型
│   ├─ 檢查 package.json → Next.js
│   ├─ 檢查 requirements.txt → Python
│   └─ 否則 → Generic
│
├─ 2. 解析專案命令
│   ├─ package.json scripts.dev
│   └─ package.json scripts.test
│
├─ 3. Port 衝突檢查
│   ├─ 檢查 3000 (dev server)
│   └─ 檢查 5432 (Prisma)
│
├─ 4. 顯示預覽
│   ├─ 專案類型
│   ├─ 即將執行的命令
│   └─ 布局預覽 (ASCII art)
│
├─ 5. 確認啟動 [Y/n]
│   └─ Y → 繼續，n → 取消
│
└─ 6. 生成布局
    └─ 呼叫 ai-workspace.sh 邏輯
```

### 依賴關係

**必需**：
- Bash >= 4.0
- Tmux >= 3.0
- Git（專案偵測）

**可選**：
- jq（JSON 解析，v1.0 使用 grep 替代）

**複用現有資源**：
- `~/.tmux-layouts/ai-workspace.sh`
- `~/.local/bin/ta`
- 環境變數系統（VIBE_AI_PRIMARY, VIBE_AI_SECONDARY）

---

## 配置系統

### v1.0 策略：零配置 + 環境變數

**設計原則**：
- v1.0 **不支援配置文件**
- 使用現有環境變數系統
- 提供合理預設值（90% 場景夠用）

**可用環境變數**：

```bash
# AI 工具選擇（複用現有）
export VIBE_AI_PRIMARY=claude     # 主要 AI 工具
export VIBE_AI_SECONDARY=codex    # 輔助 AI 工具

# 行為控制（新增）
export VIBE_AUTO_START=true       # 跳過確認自動啟動
export VIBE_CHECK_PORTS=true      # 啟用 port 檢查
```

**為什麼不做配置文件？**
1. **開發成本高**: 需要 YAML 解析器、驗證器（+3-5 天）
2. **學習成本高**: 用戶需要學習配置格式
3. **非核心需求**: 環境變數已足夠靈活
4. **可延後**: v1.1 再評估實際需求

### v1.1+ 配置系統（未來）

**兩級配置**：
- 全局：`~/.vibe/config`
- 專案：`.vibe/config`

**格式**（Shell Source）：
```bash
# .vibe/config
VIBE_AI_PRIMARY=claude
VIBE_AI_SECONDARY=codex
VIBE_DEFAULT_LAYOUT=ai-workspace
```

**優先級**：
```
命令列參數 > 環境變數 > 專案配置 > 全局配置 > 預設值
```

詳細設計見：`VIBE_CONFIG_DESIGN.md`

---

## 專案偵測

### 支援的專案類型（v1.0）

#### 1. Next.js 專案

**偵測規則**：
```bash
# 檢查 package.json
grep -q '"next"' package.json

# 偵測 Prisma
grep -q '"@prisma/client"' package.json
```

**提取命令**：
```bash
dev_command=$(grep '"dev"' package.json | sed 's/.*: "\(.*\)".*/\1/')
test_command=$(grep '"test"' package.json | sed 's/.*: "\(.*\)".*/\1/')
```

**推薦布局**：ai-workspace
- Pane 1 (70%): Claude/Codex
- Pane 2 (30%): `npm run dev`
- Pane 3 (30%): `npx prisma studio` (如果有 Prisma)

#### 2. Node.js 專案

**偵測規則**：
```bash
# 有 package.json 但沒有 next
[ -f package.json ] && ! grep -q '"next"' package.json
```

**提取命令**：同 Next.js

**推薦布局**：ai-workspace

#### 3. Python 專案

**偵測規則**：
```bash
# 檢查 requirements.txt 或 pyproject.toml
[ -f requirements.txt ] || [ -f pyproject.toml ]
```

**提取命令**：
```bash
# 檢查 常見啟動方式
if [ -f manage.py ]; then
  dev_command="python manage.py runserver"  # Django
elif [ -f main.py ]; then
  dev_command="python main.py"
else
  dev_command="python -m pytest"  # 預設跑測試
fi
```

**推薦布局**：ai-workspace

#### 4. Generic（預設）

**偵測規則**：
```bash
# 以上都不符合
else
```

**推薦布局**：ai-workspace（僅啟動 AI 工具，監控 pane 空白）

### 偵測結果格式

```bash
# 輸出格式（用於 --detect）
Project Type: nextjs-prisma
Dev Command:  npm run dev
Test Command: npm test
DB Command:   npx prisma studio
Recommended:  ai-workspace
```

---

## 布局生成

### v1.0 策略：複用 ai-workspace.sh

**為什麼只支援單一布局？**
1. **ai-workspace 已驗證可用**（Phase 2 完成測試）
2. **70/30 分割適用 90% 場景**
3. **減少測試組合**（單一布局 vs 多布局）
4. **降低實作複雜度**

**生成邏輯**：

```bash
generate_layout() {
  local project_type="$1"
  local dev_command="$2"
  local session_name="ai-$(basename "$PWD")"

  # 複用 ai-workspace.sh 邏輯
  tmux new-session -d -s "$session_name" -c "$PWD"

  # Pane 0: 主要 AI 工具 (70%)
  tmux select-pane -t 0 -T "🔧 ${VIBE_AI_PRIMARY:-codex}"
  if command -v "${VIBE_AI_PRIMARY:-codex}" &>/dev/null; then
    tmux send-keys -t "$session_name:0.0" "${VIBE_AI_PRIMARY:-codex}" C-m
  else
    tmux send-keys -t "$session_name:0.0" "echo '⚠️  AI 工具未安裝'" C-m
  fi

  # Pane 1: 輔助 AI 工具 (30%)
  tmux split-window -h -p 30 -t "$session_name:0" -c "$PWD"
  tmux select-pane -t 1 -T "🤖 ${VIBE_AI_SECONDARY:-claude}"
  # ... 同上

  # Pane 2: 監控 (30%)
  tmux split-window -v -p 50 -t "$session_name:0.1" -c "$PWD"
  tmux select-pane -t 2 -T "📊 Monitor"

  # 如果有 dev_command，在監控 pane 執行
  if [ -n "$dev_command" ]; then
    tmux send-keys -t "$session_name:0.2" "$dev_command" C-m
  fi

  # Attach
  tmux select-pane -t 0
  tmux attach-session -t "$session_name"
}
```

**與 ai-workspace.sh 的差異**：
- 自動填入 `dev_command`（而非手動）
- Session 名稱基於專案名稱（`ai-{project}`）
- 監控 pane 自動執行 dev 命令（可選）

---

## 命令 API

### v1.0 命令集（精簡）

```bash
vibe-start                  # 零配置啟動
vibe-start --help          # 顯示幫助
vibe-start --version       # 顯示版本
vibe-start --detect        # 僅顯示偵測結果（不啟動）
vibe-start --dry-run       # 預覽不執行
```

**移除的選項**（v1.1+）：
- ❌ `--mode <mode>` - 多模式支援
- ❌ `--config <file>` - 配置文件
- ❌ `--yes` - 自動確認
- ❌ `--init` - 初始化配置
- ❌ 子命令系統（config, template, memory, check）

### 幫助訊息範例

```
vibe-start - 智能專案啟動系統

用法:
  vibe-start                零配置啟動開發環境
  vibe-start --detect       顯示專案偵測結果
  vibe-start --dry-run      預覽即將執行的命令
  vibe-start --help         顯示此幫助訊息
  vibe-start --version      顯示版本資訊

環境變數:
  VIBE_AI_PRIMARY          主要 AI 工具 (預設: codex)
  VIBE_AI_SECONDARY        輔助 AI 工具 (預設: claude)
  VIBE_AUTO_START          跳過確認 (預設: false)
  VIBE_CHECK_PORTS         啟用 port 檢查 (預設: true)

範例:
  # 基礎使用
  cd my-nextjs-project
  vibe-start

  # 查看偵測結果
  vibe-start --detect

  # 預覽不執行
  vibe-start --dry-run

  # 自訂 AI 工具
  export VIBE_AI_PRIMARY=claude
  vibe-start

更多資訊: README.md, QUICKSTART_VIBESTART.md
```

### 互動式預覽

```
╭─────────────────────────────────────────────────────────╮
│  🔍 專案偵測結果                                        │
╰─────────────────────────────────────────────────────────╯

  專案類型:   Next.js + Prisma
  專案路徑:   /Users/frank/my-project
  Dev 命令:   npm run dev
  Test 命令:  npm test
  DB 工具:    npx prisma studio

╭─────────────────────────────────────────────────────────╮
│  📐 布局預覽                                            │
╰─────────────────────────────────────────────────────────╯

  ┌─────────────────────────┬─────────────┐
  │   Claude (70%)          │  Codex      │
  │   主要 AI 工具          │  (30%)      │
  │                         ├─────────────┤
  │                         │  npm run dev│
  │                         │  (30%)      │
  └─────────────────────────┴─────────────┘

╭─────────────────────────────────────────────────────────╮
│  ⚠️  Port 檢查                                          │
╰─────────────────────────────────────────────────────────╯

  ✅ Port 3000 可用
  ✅ Port 5432 可用

─────────────────────────────────────────────────────────

啟動此環境? [Y/n/c]
  Y - 確認啟動
  n - 取消
  c - 自訂 (v1.1 支援)

>
```

---

## Port 檢查

### v1.0 實作

**僅檢查 2 個 ports**：
- 3000: Next.js/Vite dev server
- 5432: PostgreSQL (僅 Prisma 專案)

**檢查流程**：

```bash
check_port() {
  local port="$1"
  local service="$2"

  if lsof -ti:$port > /dev/null 2>&1; then
    echo "⚠️  Port $port 被佔用 ($service)"
    echo "   是否 kill 佔用進程? [Y/n]"
    read -r choice

    if [[ "$choice" != "n" && "$choice" != "N" ]]; then
      kill -9 $(lsof -ti:$port)
      echo "✅ Port $port 已釋放"
    else
      echo "⚠️  啟動可能失敗"
    fi
  else
    echo "✅ Port $port 可用"
  fi
}

# 使用
check_port 3000 "Next.js dev server"
[ "$HAS_PRISMA" = true ] && check_port 5432 "PostgreSQL"
```

**為什麼只檢查 2 個？**
1. **覆蓋 90% 場景**：大部分專案只用這兩個
2. **降低複雜度**：不需要 port 範圍掃描
3. **快速執行**：< 0.5 秒完成檢查

**v1.1+ 可擴展**：
- 從 .vibeproject 讀取額外 ports
- 支援 port 範圍掃描
- 自動偵測常見服務 ports（8080, 27017...）

---

## 錯誤處理

### 基礎錯誤處理

```bash
# 1. Tmux 未安裝
if ! command -v tmux &>/dev/null; then
  echo "❌ 錯誤：未安裝 tmux"
  echo "   安裝方法：brew install tmux"
  exit 1
fi

# 2. AI 工具未安裝（警告但繼續）
if ! command -v "${VIBE_AI_PRIMARY:-codex}" &>/dev/null; then
  echo "⚠️  警告：'${VIBE_AI_PRIMARY:-codex}' 未安裝"
  echo "   安裝方法：npm install -g @codexhq/cli"
  echo "   將顯示提示訊息而非啟動工具"
fi

# 3. Session 已存在
if tmux has-session -t "$session_name" 2>/dev/null; then
  echo "📌 Session '$session_name' 已存在"
  echo "   1) Attach 到現有 session"
  echo "   2) Kill 並重新建立"
  echo "   3) 取消"
  read -p "選擇 [1/2/3]: " choice
  # ... 處理邏輯
fi

# 4. Port kill 失敗
if ! kill -9 $(lsof -ti:$port) 2>/dev/null; then
  echo "❌ 無法 kill port $port"
  echo "   請手動處理：lsof -ti:$port | xargs kill -9"
fi
```

**錯誤處理原則**：
- 清晰的錯誤訊息
- 提供解決建議
- 永遠不要無提示崩潰
- 嚴重錯誤退出（exit 1），警告繼續（exit 0）

---

## 實施路線圖

### Week 1: 核心實作

**Day 1-2: 專案偵測引擎**
```bash
✅ lib/detect_project.sh
  - detect_nextjs()
  - detect_nodejs()
  - detect_python()
  - detect_generic()

✅ lib/parse_package_json.sh
  - get_dev_command()
  - get_test_command()
  - has_prisma()
```

**Day 3: 布局生成 + Port 檢查**
```bash
✅ lib/generate_layout.sh
  - 複用 ai-workspace.sh 邏輯
  - 動態填入 dev_command

✅ lib/check_port.sh
  - check_port()
  - kill_port()
```

**Day 4: CLI + 互動式預覽**
```bash
✅ vibe-start (主腳本)
  - 參數解析
  - 流程編排

✅ lib/show_preview.sh
  - show_detection_result()
  - show_layout_preview()
  - confirm_start()
```

**Day 5: 錯誤處理 + 整合測試**
```bash
✅ 錯誤處理邏輯
✅ 端到端測試（3 種專案類型）
✅ Bug fixes
```

---

### Week 2: 優化和文檔

**Day 6: 優化體驗**
- 優化輸出訊息和色彩
- 改進 ASCII 預覽圖
- 效能優化（< 5 秒啟動）

**Day 7: 文檔和範例**
- 撰寫 `QUICKSTART_VIBESTART.md`
- 更新 `README.md`
- 建立 3 個範例專案配置

**檢查點**：
- ✅ 能否在 < 5 秒內啟動 Next.js 專案？
- ✅ 新用戶能否零學習成本使用？
- ✅ 錯誤訊息是否清晰？

---

## 版本規劃

### v1.0 MVP（1-2 週）✅ 當前

**核心功能**：
- 零配置啟動
- 專案類型偵測（3-5 種）
- 單一布局（ai-workspace）
- Port 檢查（2 個）
- 互動式預覽

**交付標準**：
- 能偵測 90% 的 Next.js 專案
- < 5 秒完成啟動
- 錯誤率 < 5%
- 新用戶成功率 > 95%

---

### v1.1 增強版（2-3 週後）

**新增功能**：
- 記憶系統（~/.vibe/memory.json）
- .vibeproject 配置文件支援
- 多模式支援（dev, debug, review）
- 環境變數檢查（.env）
- `--yes`, `--mode`, `--config` 選項

**工時估計**: 5-7 天

---

### v2.0 進階版（未來）

**新增功能**：
- 自訂模板系統
- Post-start Actions
- Hooks 系統
- 智能學習引擎
- 服務啟動管理

**工時估計**: 10-15 天

---

## 技術決策記錄

### 決策 1: 為什麼 v1.0 不支援配置文件？

**背景**：原設計包含 380 行 YAML 配置

**決策**：v1.0 僅使用環境變數，配置文件延後到 v1.1

**理由**：
1. **開發成本**：YAML 解析 + 驗證 = +3-5 天
2. **學習成本**：用戶需要學習配置格式
3. **非核心需求**：環境變數已足夠
4. **風險控制**：先驗證用戶需求

**影響**：
- ✅ v1.0 可在 2 週內完成
- ✅ 降低用戶學習成本
- ⚠️ v1.1 需要實作配置系統

---

### 決策 2: 為什麼只支援單一布局？

**背景**：設計包含多模式支援（dev, debug, review）

**決策**：v1.0 僅 ai-workspace，其他布局延後

**理由**：
1. **ai-workspace 已驗證可用**
2. **70/30 分割適用 90% 場景**
3. **減少測試組合**
4. **降低實作複雜度**

**影響**：
- ✅ 實作時間 -3 天
- ✅ 測試複雜度降低
- ⚠️ 少數用戶可能需要其他布局

---

### 決策 3: 為什麼移除健康檢查系統？

**背景**：設計包含 9 種檢查類型（port, service, env_file, python_venv...）

**決策**：v1.0 僅 port 檢查，其他延後

**理由**：
1. **實作成本高**：9 種檢查 = +6-8 天
2. **邊緣案例多**：PostgreSQL, Docker 等環境差異大
3. **非核心需求**：port 檢查覆蓋 90% 場景

**影響**：
- ✅ 實作時間 -6 天
- ✅ 降低維護成本
- ⚠️ 少數場景可能需要手動處理

---

### 決策 4: 為什麼不實作記憶系統？

**背景**：設計包含使用統計、學習演算法、歷史記錄

**決策**：v1.0 不實作，v1.1 簡化版本

**理由**：
1. **過度設計**：統計和學習非核心需求
2. **實作成本高**：+4-6 天
3. **資料結構複雜**：維護困難

**影響**：
- ✅ 實作時間 -5 天
- ✅ 降低複雜度
- ⚠️ 用戶需要每次選擇（v1.1 解決）

---

## 成功標準

### 功能完整性
- ✅ 能偵測 90% 的 Next.js 專案
- ✅ 能在 < 5 秒內完成啟動（零配置）
- ✅ 錯誤率 < 5%（100 次測試，< 5 次失敗）
- ✅ 首次使用成功率 > 95%

### 用戶體驗
- ✅ 新用戶能在 < 1 分鐘內理解如何使用
- ✅ 錯誤訊息清晰，提供解決建議
- ✅ 無需閱讀文檔即可完成基礎使用

### 技術品質
- ✅ 腳本語法檢查通過（`bash -n`）
- ✅ 支援 Bash 4.0+, Tmux 3.0+
- ✅ 無硬編碼路徑（除 ~/.vibe/）
- ✅ 錯誤處理覆蓋率 > 80%

---

## 附錄

### 相關文檔

- `VIBE_CONFIG_DESIGN.md` - 兩級配置系統設計（v1.1+）
- `MVP_ANALYSIS.md` - 完整 MVP 分析報告
- `COMPLEXITY_ANALYSIS.md` - 過度設計分析報告

### 設計演進

| 版本 | 配置行數 | 功能數量 | 實作時間 | 狀態 |
|------|---------|---------|---------|------|
| 原設計 | 380 行 | 30+ 個 | 8 週 | ❌ 棄用 |
| MVP 設計 | 0 行（環境變數） | 6 個 | 2 週 | ✅ 當前 |
| v1.1 設計 | < 30 行 | 12 個 | 1 週 | 🔵 未來 |

---

**最後更新**: 2025-10-19
**狀態**: ✅ 設計完成，等待實作
**下一步**: Week 1 Day 1 - 建立專案偵測引擎
