#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════
# Tmux AI Workspace Installation Script
# Created for Frank Yang - VibeGhostty Project
# ═══════════════════════════════════════════════════════

set -e

# ───────────────────────────────────────────────────────
# Colors
# ───────────────────────────────────────────────────────

BLUE="\033[34m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BOLD="\033[1m"
RESET="\033[0m"

# ───────────────────────────────────────────────────────
# Helper Functions
# ───────────────────────────────────────────────────────

print_header() {
    echo -e "${BLUE}${BOLD}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║       🚀 Tmux AI Workspace Installation 🤖               ║"
    echo "║                                                           ║"
    echo "║              Created for Frank Yang                       ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${RESET}"
    echo ""
}

print_step() {
    echo -e "${CYAN}${BOLD}▶ $1${RESET}"
}

print_success() {
    echo -e "${GREEN}✅ $1${RESET}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${RESET}"
}

print_error() {
    echo -e "${RED}❌ $1${RESET}"
}

# ───────────────────────────────────────────────────────
# Installation Steps
# ───────────────────────────────────────────────────────

print_header

# Step 1: Check if tmux is installed
print_step "檢查 Tmux 安裝狀態..."

if ! command -v tmux &> /dev/null; then
    print_warning "Tmux 未安裝"

    if command -v brew &> /dev/null; then
        echo "使用 Homebrew 安裝 Tmux..."
        brew install tmux
        print_success "Tmux 安裝完成"
    else
        print_error "找不到 Homebrew，請手動安裝 Tmux"
        echo "macOS: brew install tmux"
        echo "Ubuntu: sudo apt-get install tmux"
        exit 1
    fi
else
    TMUX_VERSION=$(tmux -V)
    print_success "Tmux 已安裝: $TMUX_VERSION"
fi

echo ""

# Step 2: Check AI CLI tools
print_step "檢查 AI CLI 工具..."

if command -v codex &> /dev/null; then
    print_success "Codex CLI 已安裝"
else
    print_warning "Codex CLI 未安裝（可選）"
fi

if command -v claude &> /dev/null; then
    print_success "Claude Code 已安裝"
else
    print_warning "Claude Code 未安裝（可選）"
fi

echo ""

# Step 3: Install TPM (Tmux Plugin Manager)
print_step "檢查 TPM (Tmux Plugin Manager)..."

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    print_success "TPM 已安裝"
else
    print_warning "TPM 未安裝，正在安裝..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_success "TPM 安裝完成"
fi

echo ""

# Step 4: Create necessary directories
print_step "創建必要目錄..."

mkdir -p "$HOME/.tmux-layouts"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.tmux/logs"

print_success "目錄創建完成"

echo ""

# Step 5: Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 6: Copy configuration files
print_step "複製配置文件..."

# Backup existing tmux.conf if it exists
if [[ -f "$HOME/.tmux.conf" ]]; then
    BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "備份現有配置到: $BACKUP_FILE"
    cp "$HOME/.tmux.conf" "$BACKUP_FILE"
fi

# Copy tmux.conf
cp "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
print_success "複製 tmux.conf"

# Copy layout scripts
cp "$SCRIPT_DIR/layouts/"*.sh "$HOME/.tmux-layouts/"
print_success "複製布局腳本"

# Copy launcher
cp "$SCRIPT_DIR/bin/tmux-launch" "$HOME/.local/bin/tmux-launch"
print_success "複製啟動器"

# Copy vibe-help
cp "$SCRIPT_DIR/bin/vibe-help" "$HOME/.local/bin/vibe-help"
print_success "複製快捷鍵速查工具"

# Copy ta (Tmux Attach wrapper)
cp "$SCRIPT_DIR/bin/ta" "$HOME/.local/bin/ta"
print_success "複製智能 session 管理工具"

echo ""

# Step 7: Set executable permissions
print_step "設定執行權限..."

chmod +x "$HOME/.tmux-layouts/"*.sh
chmod +x "$HOME/.local/bin/tmux-launch"
chmod +x "$HOME/.local/bin/vibe-help"
chmod +x "$HOME/.local/bin/ta"

print_success "權限設定完成"

echo ""

# Step 8: Check if ~/.local/bin is in PATH
print_step "檢查 PATH 設定..."

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin 不在 PATH 中"
    echo ""
    echo "請將以下內容加入你的 shell 配置文件："
    echo ""
    echo -e "${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    echo "對於 zsh: ~/.zshrc"
    echo "對於 bash: ~/.bashrc 或 ~/.bash_profile"
    echo ""
    read -p "是否現在自動加入 ~/.zshrc? [Y/n]: " add_to_path

    if [[ "$add_to_path" != "n" && "$add_to_path" != "N" ]]; then
        echo "" >> "$HOME/.zshrc"
        echo "# Added by VibeGhostty Tmux installer" >> "$HOME/.zshrc"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc"
        print_success "已加入 ~/.zshrc"
        echo "請執行: source ~/.zshrc"
    fi
else
    print_success "PATH 已正確設定"
fi

echo ""

# Step 9: Test syntax
print_step "測試腳本語法..."

bash -n "$HOME/.tmux-layouts/ai-workspace.sh" && print_success "ai-workspace.sh 語法正確"
bash -n "$HOME/.tmux-layouts/ai-compare.sh" && print_success "ai-compare.sh 語法正確"
bash -n "$HOME/.tmux-layouts/full-focus.sh" && print_success "full-focus.sh 語法正確"
bash -n "$HOME/.local/bin/tmux-launch" && print_success "tmux-launch 語法正確"

echo ""

# Step 10: Install TPM plugins
print_step "安裝 Tmux 插件..."

echo "請在 Tmux 中按 Ctrl+Space 然後按 I（大寫）來安裝插件"
print_warning "如果 Tmux 正在執行，請執行: tmux source-file ~/.tmux.conf"

echo ""

# ───────────────────────────────────────────────────────
# Installation Complete
# ───────────────────────────────────────────────────────

echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              ✅ 安裝完成！                                ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo ""
echo -e "${CYAN}${BOLD}快速開始：${RESET}"
echo ""
echo "  1️⃣  快速 attach 到專案 session（最常用！）："
echo -e "     ${YELLOW}ta${RESET}                    # 自動偵測當前專案"
echo -e "     ${YELLOW}ta -l${RESET}                 # 列出所有 session"
echo -e "     ${YELLOW}ta -n session名稱${RESET}     # 指定 session"
echo ""
echo "  2️⃣  查看所有快捷鍵（不用背！）："
echo -e "     ${YELLOW}vibe-help${RESET}"
echo -e "     或在 Tmux 中按 ${YELLOW}Ctrl+Space ?${RESET}"
echo ""
echo "  3️⃣  啟動互動式選單："
echo -e "     ${YELLOW}tmux-launch${RESET}"
echo ""
echo "  4️⃣  直接啟動特定布局："
echo -e "     ${YELLOW}~/.tmux-layouts/ai-workspace.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/ai-compare.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/full-focus.sh${RESET}"
echo ""
echo "  5️⃣  重新載入 Tmux 配置："
echo -e "     ${YELLOW}tmux source-file ~/.tmux.conf${RESET}"
echo -e "     或在 Tmux 中按 ${YELLOW}Ctrl+Space r${RESET}"
echo ""
echo "  6️⃣  安裝 Tmux 插件："
echo -e "     在 Tmux 中按 ${YELLOW}Ctrl+Space I${RESET} (大寫 I)"
echo ""
echo -e "${CYAN}${BOLD}更多資訊：${RESET}"
echo ""
echo "  📖 完整使用指南："
echo "     $SCRIPT_DIR/../TMUX_GUIDE.md"
echo ""
echo "  🚀 快速開始："
echo "     $SCRIPT_DIR/../QUICKSTART_TMUX.md"
echo ""
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${RESET}"
echo ""
echo "🎉 享受你的 AI 工作空間！"
echo ""
