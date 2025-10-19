#!/usr/bin/env bash
set -e

# ═══════════════════════════════════════════════════
# Pane 術語統一修正腳本
# ═══════════════════════════════════════════════════
#
# 目的: 將中文敘述中的 "pane" 英文原文改為「窗格」
# 範圍: docs/user-guide/*.zh-TW.md
# 保留: tmux 命令名稱中的 "pane"（如 select-pane）
#
# 執行方式:
#   bash fix-pane-terminology.sh
#
# 備份:
#   自動備份到 .bak 文件
# ═══════════════════════════════════════════════════

# 色彩定義
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 專案根目錄
PROJECT_ROOT="/Users/termtek/Documents/GitHub/VibeGhostty"
DOCS_DIR="$PROJECT_ROOT/docs/user-guide"

echo -e "${BLUE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}║          🔧 Pane 術語統一修正腳本 📝                     ║${NC}"
echo -e "${BLUE}║                                                           ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# 檢查文件存在
if [ ! -d "$DOCS_DIR" ]; then
    echo -e "${RED}❌ 錯誤: 找不到文檔目錄 $DOCS_DIR${NC}"
    exit 1
fi

cd "$DOCS_DIR"

echo -e "${YELLOW}📂 工作目錄: $DOCS_DIR${NC}"
echo ""

# ═══════════════════════════════════════════════════
# 步驟 1: 備份所有文件
# ═══════════════════════════════════════════════════

echo -e "${BLUE}[步驟 1/4] 📦 備份原始文件...${NC}"

for file in tmux-guide.zh-TW.md workflows.zh-TW.md; do
    if [ -f "$file" ]; then
        cp "$file" "$file.bak"
        echo -e "  ✅ 已備份: $file → $file.bak"
    else
        echo -e "  ${RED}⚠️  找不到: $file${NC}"
    fi
done

echo ""

# ═══════════════════════════════════════════════════
# 步驟 2: 修正 tmux-guide.zh-TW.md (32 處)
# ═══════════════════════════════════════════════════

echo -e "${BLUE}[步驟 2/4] 🔧 修正 tmux-guide.zh-TW.md...${NC}"

FILE="tmux-guide.zh-TW.md"

if [ -f "$FILE" ]; then
    # 統計修正前的 "pane" 數量（排除命令中的）
    BEFORE_COUNT=$(grep -o "pane" "$FILE" | wc -l | tr -d ' ')

    # 修正中文敘述中的 "pane"
    # 注意: 不替換 tmux 命令本身

    # 1. 窗格（panes） → 窗格
    sed -i '' 's/窗格（panes）/窗格/g' "$FILE"

    # 2. X pane → X 窗格（在中文語境中）
    sed -i '' 's/Compare pane/Compare 窗格/g' "$FILE"
    sed -i '' 's/關閉 pane/關閉窗格/g' "$FILE"
    sed -i '' 's/縮放 pane/縮放窗格/g' "$FILE"
    sed -i '' 's/側 pane/側窗格/g' "$FILE"
    sed -i '' 's/跳到 Pane/跳到窗格/g' "$FILE"
    sed -i '' 's/每個 pane/每個窗格/g' "$FILE"
    sed -i '' 's/記錄 pane/記錄窗格/g' "$FILE"
    sed -i '' 's/當前 pane/當前窗格/g' "$FILE"
    sed -i '' 's/monitor pane/monitor 窗格/g' "$FILE"
    sed -i '' 's/底部 pane/底部窗格/g' "$FILE"
    sed -i '' 's/右側 pane/右側窗格/g' "$FILE"
    sed -i '' 's/左側 pane/左側窗格/g' "$FILE"
    sed -i '' 's/上方 pane/上方窗格/g' "$FILE"
    sed -i '' 's/下方 pane/下方窗格/g' "$FILE"
    sed -i '' 's/新 pane/新窗格/g' "$FILE"

    # 統計修正後的 "pane" 數量
    AFTER_COUNT=$(grep -o "pane" "$FILE" | wc -l | tr -d ' ')
    FIXED_COUNT=$((BEFORE_COUNT - AFTER_COUNT))

    echo -e "  ✅ 修正前: ${BEFORE_COUNT} 次 \"pane\""
    echo -e "  ✅ 修正後: ${AFTER_COUNT} 次 \"pane\"（保留命令中的）"
    echo -e "  ✅ 已修正: ${GREEN}${FIXED_COUNT} 處${NC}"
else
    echo -e "  ${RED}❌ 找不到文件: $FILE${NC}"
fi

echo ""

# ═══════════════════════════════════════════════════
# 步驟 3: 修正 workflows.zh-TW.md (1 處)
# ═══════════════════════════════════════════════════

echo -e "${BLUE}[步驟 3/4] 🔧 修正 workflows.zh-TW.md...${NC}"

FILE="workflows.zh-TW.md"

if [ -f "$FILE" ]; then
    BEFORE_COUNT=$(grep -o "Compare pane" "$FILE" | wc -l | tr -d ' ')

    sed -i '' 's/Compare pane/Compare 窗格/g' "$FILE"

    AFTER_COUNT=$(grep -o "Compare pane" "$FILE" | wc -l | tr -d ' ')
    FIXED_COUNT=$((BEFORE_COUNT - AFTER_COUNT))

    echo -e "  ✅ 修正: ${GREEN}${FIXED_COUNT} 處${NC} \"Compare pane\" → \"Compare 窗格\""
else
    echo -e "  ${RED}❌ 找不到文件: $FILE${NC}"
fi

echo ""

# ═══════════════════════════════════════════════════
# 步驟 4: 驗證修正結果
# ═══════════════════════════════════════════════════

echo -e "${BLUE}[步驟 4/4] ✅ 驗證修正結果...${NC}"

echo ""
echo -e "${YELLOW}=== tmux-guide.zh-TW.md ===${NC}"
echo "中文語境中的 pane 出現次數（應該大幅減少）:"
grep -n "pane" tmux-guide.zh-TW.md | grep -v "select-pane" | grep -v "kill-pane" | grep -v "resize-pane" | grep -v "split-window" | grep -v "pane_current_path" | grep -v "pane_id" | head -10
echo ""

echo -e "${YELLOW}=== workflows.zh-TW.md ===${NC}"
echo "應該沒有 \"Compare pane\" (檢查是否為空):"
grep -n "Compare pane" workflows.zh-TW.md || echo "  ✅ 無 \"Compare pane\"，修正成功！"

echo ""

# ═══════════════════════════════════════════════════
# 完成
# ═══════════════════════════════════════════════════

echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}║          ✅ 術語修正完成！                                ║${NC}"
echo -e "${GREEN}║                                                           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"

echo ""
echo -e "${YELLOW}📋 下一步:${NC}"
echo ""
echo "1. 檢查修正結果:"
echo "   ${BLUE}git diff docs/user-guide/tmux-guide.zh-TW.md${NC}"
echo "   ${BLUE}git diff docs/user-guide/workflows.zh-TW.md${NC}"
echo ""
echo "2. 如果修正正確，提交變更:"
echo "   ${BLUE}git add docs/user-guide/*.zh-TW.md${NC}"
echo "   ${BLUE}git commit -m \"docs: unify pane terminology to 窗格 in Chinese context\"${NC}"
echo ""
echo "3. 如果需要恢復，使用備份:"
echo "   ${BLUE}cp docs/user-guide/tmux-guide.zh-TW.md.bak docs/user-guide/tmux-guide.zh-TW.md${NC}"
echo "   ${BLUE}cp docs/user-guide/workflows.zh-TW.md.bak docs/user-guide/workflows.zh-TW.md${NC}"
echo ""
echo -e "${GREEN}🎉 完成！${NC}"
