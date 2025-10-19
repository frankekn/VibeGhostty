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
print_step "Checking tmux installation..."

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
    TMUX_VERSION=$(tmux -V)
    print_success "tmux detected: $TMUX_VERSION"
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

# Step 6: Copy configuration files
print_step "Copying configuration files..."

# Backup existing tmux.conf if it exists
if [[ -f "$HOME/.tmux.conf" ]]; then
    BACKUP_FILE="$HOME/.tmux.conf.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backing up existing config to: $BACKUP_FILE"
    cp "$HOME/.tmux.conf" "$BACKUP_FILE"
fi

# Copy tmux.conf
cp "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
print_success "Copied tmux.conf"

# Copy layout scripts
cp "$SCRIPT_DIR/layouts/"*.sh "$HOME/.tmux-layouts/"
print_success "Copied layout scripts"

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
bash -n "$HOME/.tmux-layouts/ai-compare.sh" && print_success "ai-compare.sh passed syntax check"
bash -n "$HOME/.tmux-layouts/full-focus.sh" && print_success "full-focus.sh passed syntax check"
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
echo "  3️⃣  Launch the interactive selector"
echo -e "     ${YELLOW}tmux-launch${RESET}"
echo ""
echo "  4️⃣  Launch layouts directly"
echo -e "     ${YELLOW}~/.tmux-layouts/ai-workspace.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/ai-compare.sh${RESET}"
echo -e "     ${YELLOW}~/.tmux-layouts/full-focus.sh${RESET}"
echo ""
echo "  5️⃣  Reload your tmux configuration"
echo -e "     ${YELLOW}tmux source-file ~/.tmux.conf${RESET}"
echo -e "     or inside tmux press ${YELLOW}Ctrl+Space r${RESET}"
echo ""
echo "  6️⃣  Install tmux plugins"
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
echo -e "${YELLOW}═══════════════════════════════════════════════════════════${RESET}"
echo ""
echo "🎉 Enjoy your AI workspace!"
echo ""
