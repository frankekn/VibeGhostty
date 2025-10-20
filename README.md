# VibeGhostty 🚀

> A Ghostty terminal configuration tuned for multi-AI collaboration

VibeGhostty delivers a ready-to-use Ghostty and Tmux setup crafted for pairing tools such as Claude Code and Codex CLI. It focuses on fast workspace switching, consistent visuals, and workflows tailored for AI-assisted development.

---

## ✨ Highlights

- 🎨 **Tokyo Night Storm theme** for cohesive, low-contrast visuals
- 🔤 **JetBrains Mono Nerd Font** with full glyph and icon support
- ⌨️ **Productive keybindings** for tabs, splits, and window management
- 🤖 **AI-friendly layouts** that keep assistants and monitors in view
- 📊 **Large scrollback buffers** so conversations stay at your fingertips
- 🚀 **Intelligent project startup** (vibe-start) - zero-config workspace creation *(Coming in v1.0)*

---

## 🚀 Ghostty Quick Start

1. **Install the font**
   ```bash
   brew install --cask font-jetbrains-mono-nerd-font
   ```

2. **Copy the configuration**
   ```bash
   cp config ~/Library/Application\ Support/com.mitchellh.ghostty/config
   ```

3. **Reload Ghostty**
   Press `Cmd+Shift+Comma` inside Ghostty or restart the app.

---

## ⌨️ Ghostty Keybindings

### Tab management
| Shortcut | Action |
|----------|--------|
| `Cmd+T` | Open a new tab |
| `Cmd+W` | Close the current tab |
| `Cmd+1~9` | Jump directly to tabs 1-9 |
| `Cmd+Shift+]` | Next tab |
| `Cmd+Shift+[` | Previous tab |

### Split management
| Shortcut | Action |
|----------|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split down |

### Miscellaneous
| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+Comma` | Reload configuration |

---

## 💡 Workflow Examples

### Claude Code + Codex CLI in parallel
```bash
# Tab 1 – Claude Code primary workspace
claude

# Cmd+T → new tab
# Tab 2 – Codex CLI assistant
codex

# Switch between them with Cmd+1 / Cmd+2
```

### Side-by-side AI comparison
```bash
# Keep Claude on the left
claude

# Cmd+D to split right for Codex
codex

# Compare outputs without leaving the terminal
```

### Multi-project juggling
```
Tab 1: Project A – Claude Code
Tab 2: Project A – test watcher
Tab 3: Project B – Codex CLI
Tab 4: Project B – log tailing

Use Cmd+1/2/3/4 to hop instantly
```

---

## 🎨 Color Palette

- **Background**: `#24283b`
- **Foreground**: `#c0caf5`
- **Cursor**: `#ff9e64`
- **Selection**: `#364a82`

ANSI accents follow the Tokyo Night Storm palette (`#f7768e`, `#7aa2f7`, `#9ece6a`, etc.) to keep text, warnings, and highlights consistent across Ghostty and Tmux.

---

## 🔧 Customization Tips

### Font size
```bash
# Locate this line in config
font-size = 13

# Adjust to taste
font-size = 12
font-size = 14
```
Reload Ghostty afterwards (`Cmd+Shift+Comma`).

### Alternative Nerd Font
```bash
brew install --cask font-fira-code-nerd-font
# Then update the config
font-family = Fira Code
```

### Scrollback history
```bash
scrollback-limit = 100000   # more history
scrollback-limit = 20000    # lighter memory footprint
```

---

## 🔥 Tmux AI Workspace Integration

Ghostty covers the UI layer, while Tmux manages long-lived sessions and complex layouts. Together they unlock:

- 📐 **Preset AI layouts** (Workspace, Compare, Focus)
- 💾 **Persistent sessions** that survive restarts
- ⚡ **Vim-style navigation** for panes and windows
- 🎨 **Shared theme** for a consistent look

### Tmux Quick Start

```bash
# Option 1: install from the repo (recommended when cloning locally)
cd ~/Documents/GitHub/VibeGhostty/tmux
bash install.sh

# Option 2: one-liner installer (macOS/Linux)
bash <(curl -fsSL https://raw.githubusercontent.com/frankekn/VibeGhostty/master/tmux/install.sh)

# Launch the interactive workspace picker
tmux-launch

# Start a workspace (auto-detect project) - COMING SOON in v1.0
# vibe-start

# Zero-configuration startup - auto-detects Next.js, Node.js, Python projects
# Automatically generates AI workspace (70/30 split) based on project type
# See DESIGN.md for detailed MVP roadmap
```

### vibe-start: Intelligent Project Startup *(In Development)*

`vibe-start` is an upcoming feature that eliminates manual setup by automatically detecting your project type and launching the appropriate AI workspace.

**Key Features** (v1.0 MVP):
- 🔍 **Smart Detection**: Automatically identifies Next.js, Node.js, and Python projects
- ⚡ **Zero Configuration**: Uses environment variables—no config files needed
- 🎯 **Single Command**: `vibe-start` and you're ready to code
- 🚦 **Port Checking**: Automatically handles port conflicts (3000, 5432)
- 👁️ **Interactive Preview**: Shows what will be launched before execution

**Current Status**: Design complete, implementation scheduled for Week 1-2
- 📖 Full design: [DESIGN.md](DESIGN.md)
- 📊 MVP analysis: [docs/MVP_ANALYSIS.md](docs/MVP_ANALYSIS.md)
- 🔍 Complexity analysis: [docs/COMPLEXITY_ANALYSIS.md](docs/COMPLEXITY_ANALYSIS.md)

**Roadmap**:
- **v1.0 MVP** (2 weeks): Zero-config startup, project detection, single layout
- **v1.1** (1 week later): Memory system, `.vibeproject` config, multi-mode support
- **v2.0** (future): Custom templates, hooks, advanced features

### Default layouts

**AI Workspace (70/30 split)** – Claude or Codex on the left, assistant + monitor panes on the right.

```
┌─────────────────────────┬─────────────┐
│   Codex CLI (70%)       │  Claude     │
│                         │  Code (30%) │
│                         ├─────────────┤
│                         │  Monitor    │
└─────────────────────────┴─────────────┘
```

**AI Split (50/50)** – direct comparison between two AI tools with a shared monitor pane.

```
┌────────────────┬────────────────┐
│  Codex CLI     │  Claude Code   │
│  (50%)         │  (50%)         │
├────────────────┴────────────────┤
│  Compare/Monitor (25%)          │
└─────────────────────────────────┘
```

**Full Focus (100%)** – dedicate the entire window to a single tool for deep work.

```
┌─────────────────────────────────┐
│  Claude Code or Codex CLI       │
└─────────────────────────────────┘
```

### Essential tmux commands

```bash
tmux-launch                 # interactive layout picker
~/.tmux-layouts/ai-workspace.sh  # launch a layout directly
tmux attach                 # resume the last session
```

### Core tmux shortcuts (prefix = Ctrl+Space)

| Shortcut | Action | Notes |
|----------|--------|-------|
| `Ctrl+Space 1/2/3` | Jump to pane | Pane index navigation |
| `Ctrl+Space d` | Detach | Leave session running |
| `Ctrl+Space m` | Mode menu | Opens a temporary control pane and auto-cleans |
| `Ctrl+Space r` | Reload config | Apply edits to `.tmux.conf` |
| `Ctrl+Space z` | Zoom pane | Toggle fullscreen |

For the full reference, see **[TMUX_GUIDE.md](TMUX_GUIDE.md)** and **[QUICKSTART_TMUX.md](QUICKSTART_TMUX.md)**.

### Choosing Ghostty vs Tmux

| Scenario | Tool | Why |
|----------|------|-----|
| Lightweight tasks, single AI | Ghostty tabs | Fast and visually clean |
| Complex collaboration | Tmux sessions | Sophisticated layouts, persistence |
| Need to preserve state | Tmux sessions | Resurrect panes after restarts |
| Quick experiments | Ghostty splits | Minimal setup, instant teardown |

Use Ghostty for structure and Tmux for orchestration—the combination delivers the best experience.

---

## 📁 Repository Layout

```
VibeGhostty/
├── README.md              # This quickstart document (English)
├── config                 # Primary Ghostty configuration
├── DESIGN.md              # vibe-start feature design (v1.0 MVP)
├── GUIDE.md               # In-depth Ghostty guide (Traditional Chinese)
├── INSTALL.md             # Installation walk-through (Traditional Chinese)
├── QUICKSTART.md          # Five-minute Ghostty setup (Traditional Chinese)
├── TMUX_GUIDE.md          # Complete tmux manual (Traditional Chinese)
├── QUICKSTART_TMUX.md     # tmux quickstart (Traditional Chinese)
├── VIBE_CONFIG_DESIGN.md  # Two-tier config system design (v1.1+)
├── docs/
│   ├── MVP_ANALYSIS.md         # Feature prioritization and MVP scope
│   └── COMPLEXITY_ANALYSIS.md  # Design simplification analysis
└── tmux/
    ├── tmux.conf          # Main tmux configuration
    ├── install.sh         # Automated installer
    ├── layouts/           # Workspace scripts
    └── bin/               # Helper utilities (tmux-launch, vibe-help, ta)
```

---

## 🐛 Troubleshooting

### Glyphs or icons look broken
Install the Nerd Font and restart Ghostty:
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Keybindings don’t respond
1. Check for global macOS shortcut conflicts
2. Reload the config with `Cmd+Shift+Comma`
3. Restart Ghostty if needed

### Ghostty didn’t reload properly
Force restart:
```bash
pkill -9 ghostty && open -a Ghostty
```

---

## 📚 Resources

- [Ghostty documentation](https://ghostty.org/docs)
- [Ghostty configuration reference](https://ghostty.org/docs/config)
- [Nerd Fonts](https://www.nerdfonts.com/)
- [Tokyo Night theme](https://github.com/enkia/tokyo-night-vscode-theme)

---

## 📄 License

MIT License

---

## 🤝 Contributing

Issues and pull requests are welcome—feel free to share improvements or new layouts!

---

**Configuration version**: 1.0.0
**Last updated**: 2025-10-19
**Tested Ghostty version**: 1.0+

Enjoy a smoother AI-assisted terminal workflow! 🎉
