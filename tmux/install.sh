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

# 版本比較函數
# 使用方法: version_gte "3.2" "3.0" 會返回 true
version_gte() {
    local current="$1"
    local required="$2"

    # 移除非數字字符（除了點）
    current=$(echo "$current" | sed 's/[^0-9.]//g')
    required=$(echo "$required" | sed 's/[^0-9.]//g')

    # 使用 sort -V 進行版本比較
    if printf '%s\n%s\n' "$required" "$current" | sort -V -C; then
        return 0
    else
        return 1
    fi
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
print_step "Checking tmux installation..."

REQUIRED_TMUX_VERSION="3.0"

if ! command -v tmux &> /dev/null; then
    print_warning "tmux is not installed"

    if command -v brew &> /dev/null; then
        echo "Installing tmux via Homebrew..."
        brew install tmux
        print_success "tmux installation completed"
    else
        print_error "Homebrew not found. Please install tmux manually"
        echo "macOS: brew install tmux"
        echo "Ubuntu: sudo apt-get install tmux"
        exit 1
    fi
else
    TMUX_VERSION=$(tmux -V | awk '{print $2}')
    print_success "tmux detected: $TMUX_VERSION"

    # 檢查版本是否符合要求
    if ! version_gte "$TMUX_VERSION" "$REQUIRED_TMUX_VERSION"; then
        print_warning "tmux version $TMUX_VERSION is below recommended $REQUIRED_TMUX_VERSION"
        echo "Some features may not work correctly"
        echo "Upgrade: brew upgrade tmux"
        echo ""
        read -p "Continue anyway? [y/N]: " continue_install
        if [[ "$continue_install" != "y" && "$continue_install" != "Y" ]]; then
            print_error "Installation cancelled"
            exit 1
        fi
    fi
fi

echo ""

# Step 2: Check AI CLI tools
print_step "Checking AI CLI tools..."

if command -v codex &> /dev/null; then
    print_success "Codex CLI detected"
else
    print_warning "Codex CLI not found (optional)"
fi

if command -v claude &> /dev/null; then
    print_success "Claude Code detected"
else
    print_warning "Claude Code not found (optional)"
fi

echo ""

# Step 2.5: Check Git (required for TPM)
print_step "Checking Git installation..."

REQUIRED_GIT_VERSION="2.0"

if ! command -v git &> /dev/null; then
    print_error "Git is not installed"
    echo "Git is required for TPM (tmux plugin manager)"
    echo "Install: brew install git"
    exit 1
else
    GIT_VERSION=$(git --version | awk '{print $3}')
    print_success "Git detected: $GIT_VERSION"

    # 檢查版本
    if ! version_gte "$GIT_VERSION" "$REQUIRED_GIT_VERSION"; then
        print_warning "Git version $GIT_VERSION is below recommended $REQUIRED_GIT_VERSION"
        echo "Upgrade: brew upgrade git"
    fi
fi

echo ""

# Step 3: Install TPM (Tmux Plugin Manager)
print_step "Checking TPM (tmux plugin manager)..."

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [[ -d "$TPM_DIR" ]]; then
    print_success "TPM already installed"
else
    print_warning "TPM not found. Installing..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    print_success "TPM installed"
fi

echo ""

# Step 4: Create necessary directories
print_step "Creating directories..."

mkdir -p "$HOME/.tmux-layouts"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.tmux/logs"

print_success "Directories ready"

echo ""

# Step 5: Get the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Step 5.5: Create backup directory
BACKUP_DIR="$HOME/.vibeghostty-backups/backup-$(date +%Y%m%d_%H%M%S)"

print_step "Preparing backup location..."
mkdir -p "$BACKUP_DIR"
print_success "Backup directory: $BACKUP_DIR"

echo ""

# Step 6: Copy configuration files
print_step "Copying configuration files..."

# Backup existing files before overwriting
BACKUP_COUNT=0

# Backup tmux.conf
if [[ -f "$HOME/.tmux.conf" ]]; then
    cp "$HOME/.tmux.conf" "$BACKUP_DIR/tmux.conf"
    ((BACKUP_COUNT++))
    print_warning "Backed up: .tmux.conf"
fi

# Backup layout目錄
if [[ -d "$HOME/.tmux-layouts" ]]; then
    cp -R "$HOME/.tmux-layouts" "$BACKUP_DIR/tmux-layouts"
    ((BACKUP_COUNT++))
    print_warning "Backed up: .tmux-layouts/"
fi

# Backup bin tools
for tool in tmux-launch vibe-help ta; do
    if [[ -f "$HOME/.local/bin/$tool" ]]; then
        mkdir -p "$BACKUP_DIR/bin"
        cp "$HOME/.local/bin/$tool" "$BACKUP_DIR/bin/"
        ((BACKUP_COUNT++))
        print_warning "Backed up: .local/bin/$tool"
    fi
done

if [[ $BACKUP_COUNT -gt 0 ]]; then
    echo ""
    print_success "Backed up $BACKUP_COUNT file(s) to $BACKUP_DIR"
else
    print_success "No existing files to backup (fresh installation)"
fi

echo ""

# Copy tmux.conf
cp "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
print_success "Copied tmux.conf"

# Copy layout scripts & shared libs
cp -R "$SCRIPT_DIR/layouts/." "$HOME/.tmux-layouts/"
print_success "Copied layout assets"

# Copy launcher
cp "$SCRIPT_DIR/bin/tmux-launch" "$HOME/.local/bin/tmux-launch"
print_success "Copied tmux-launch"

# Copy vibe-help
cp "$SCRIPT_DIR/bin/vibe-help" "$HOME/.local/bin/vibe-help"
print_success "Copied vibe-help"

# Copy ta (Tmux Attach wrapper)
cp "$SCRIPT_DIR/bin/ta" "$HOME/.local/bin/ta"
print_success "Copied ta helper"

echo ""

# Step 7: Set executable permissions
print_step "Setting executable permissions..."

chmod +x "$HOME/.tmux-layouts/"*.sh
chmod +x "$HOME/.local/bin/tmux-launch"
chmod +x "$HOME/.local/bin/vibe-help"
chmod +x "$HOME/.local/bin/ta"

print_success "Permissions updated"

echo ""

# Step 8: Check if ~/.local/bin is in PATH
print_step "Checking PATH configuration..."

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    print_warning "~/.local/bin is not in PATH"
    echo ""
    echo "Add the following line to your shell profile:"
    echo ""
    echo -e "${CYAN}export PATH=\"\$HOME/.local/bin:\$PATH\"${RESET}"
    echo ""
    echo "For zsh: ~/.zshrc"
    echo "For bash: ~/.bashrc or ~/.bash_profile"
    echo ""
    read -p "Automatically append to ~/.zshrc now? [Y/n]: " add_to_path

    if [[ "$add_to_path" != "n" && "$add_to_path" != "N" ]]; then
        echo "" >> "$HOME/.zshrc"
        echo "# Added by VibeGhostty Tmux installer" >> "$HOME/.zshrc"
        echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc"
        print_success "Added to ~/.zshrc"
        echo "Run: source ~/.zshrc"
    fi
else
    print_success "PATH already includes ~/.local/bin"
fi

echo ""

# Step 9: Test syntax
print_step "Linting shell scripts..."

bash -n "$HOME/.tmux-layouts/ai-workspace.sh" && print_success "ai-workspace.sh passed syntax check"
bash -n "$HOME/.tmux-layouts/ai-split.sh" && print_success "ai-split.sh passed syntax check"
bash -n "$HOME/.tmux-layouts/full-focus.sh" && print_success "full-focus.sh passed syntax check"
bash -n "$HOME/.tmux-layouts/lib/layout-common.sh" && print_success "layout-common.sh passed syntax check"
bash -n "$HOME/.local/bin/tmux-launch" && print_success "tmux-launch passed syntax check"

echo ""

# Step 10: Install TPM plugins
print_step "Install tmux plugins"

echo "Inside tmux press Ctrl+Space then capital I to install plugins"
print_warning "If tmux is already running, reload with: tmux source-file ~/.tmux.conf"

echo ""

# ───────────────────────────────────────────────────────
# Installation Complete
# ───────────────────────────────────────────────────────

echo -e "${GREEN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║              ✅ Installation complete!                    ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${RESET}"

echo ""
echo -e "${CYAN}${BOLD}Quick start:${RESET}"
echo ""
echo "  1️⃣  Smart attach (ta)"
echo -e "     ${YELLOW}ta${RESET}                    # auto-detect current project"
echo -e "     ${YELLOW}ta -l${RESET}                 # list all sessions"
echo -e "     ${YELLOW}ta -n session-name${RESET}    # attach by name"
echo ""
echo "  2️⃣  Keyboard reference"
echo -e "     ${YELLOW}vibe-help${RESET}"
echo -e "     or inside tmux press ${YELLOW}Ctrl+Space ?${RESET}"
echo ""
echo "  3️⃣  Launch vibe-start"
echo -e "     ${YELLOW}vibe-start${RESET}              # auto-detect and start workspace"
echo "     or specify a mode:"
echo -e "     ${YELLOW}vibe-start --mode dev${RESET}"
echo -e "     ${YELLOW}vibe-start --mode review${RESET}"
echo ""
echo "  4️⃣  Launch the interactive selector"
echo -e "     ${YELLOW}tmux-launch${RESET}              # menu-based layout picker"
echo ""
echo "  5️⃣  Launch layouts directly"
echo -e "     ${YELLOW}~/.tmux-layouts/ai-workspace.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/ai-split.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/full-focus.sh${RESET}"
echo ""
echo "  6️⃣  Reload your tmux configuration"
echo -e "     ${YELLOW}tmux source-file ~/.tmux.conf${RESET}"
echo -e "     or inside tmux press ${YELLOW}Ctrl+Space r${RESET}"
echo ""
echo "  7️⃣  Install tmux plugins"
echo -e "     Inside tmux press ${YELLOW}Ctrl+Space I${RESET} (capital I)"
echo ""
echo -e "${CYAN}${BOLD}More resources:${RESET}"
echo ""
echo "  📖 Full guide:"
echo "     $SCRIPT_DIR/../TMUX_GUIDE.md"
echo ""
echo "  🚀 Quick start:"
echo "     $SCRIPT_DIR/../QUICKSTART_TMUX.md"
echo ""
echo "  ⚙️  Environment variables:"
echo "     $SCRIPT_DIR/../ENVIRONMENT.md"
echo ""
if [[ $BACKUP_COUNT -gt 0 ]]; then
    echo "  💾 Backup location:"
    echo "     $BACKUP_DIR"
    echo ""
fi
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${RESET}"
echo ""
echo "🎉 Enjoy your AI workspace!"
echo ""
