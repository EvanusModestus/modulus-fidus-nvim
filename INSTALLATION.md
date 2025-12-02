# Installation Guide for Modulus Fidus

This guide will walk you through installing Modulus Fidus on any platform (Linux, macOS, Windows, WSL).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation by Platform](#installation-by-platform)
  - [Linux/macOS](#linuxmacos)
  - [Windows](#windows)
  - [WSL (Windows Subsystem for Linux)](#wsl-windows-subsystem-for-linux)
- [Clipboard Setup (Important)](#clipboard-setup-important)
- [Post-Installation Steps](#post-installation-steps)
- [Troubleshooting](#troubleshooting)
- [Updating](#updating)
- [Uninstallation](#uninstallation)

## Prerequisites

### Installing All Dependencies

#### Ubuntu/Debian

```bash
# Install all required dependencies
sudo apt update && sudo apt install -y \
  neovim \
  git \
  build-essential \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  curl \
  unzip \
  tar \
  gzip \
  python3 \
  python3-pip \
  python3-venv \
  wget

```

Verify Neovim version (must be 0.9.0+):
```bash
nvim --version

# If Neovim is too old, install from snap or PPA:
# Option 1: Snap (recommended)
sudo snap install nvim --classic

# Option 2: PPA
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update
sudo apt install neovim
```

#### Fedora/RHEL

```bash
sudo dnf install -y \
  neovim \
  git \
  gcc \
  make \
  ripgrep \
  fd-find \
  nodejs \
  npm \
  curl \
  unzip \
  tar \
  gzip \
  python3 \
  python3-pip \
  wget

```

#### macOS

```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install neovim git ripgrep fd node curl wget python3
```

#### Windows (PowerShell as Administrator)

```powershell
# Install Chocolatey if not already installed
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install dependencies
choco install -y neovim git ripgrep fd nodejs python curl wget

# Install Visual Studio Build Tools for C compilation
choco install -y visualstudio2022buildtools
```

### Additional Requirements

#### Nerd Font (Required for icons)
- Download from [Nerd Fonts](https://www.nerdfonts.com/)
- Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font, or Hack Nerd Font
- Install the font and configure your terminal to use it
- **Note**: Font is installed on your local machine, not the remote server if using SSH

### Optional Performance Boost

#### Rust/Cargo (for 6x faster completion with blink.cmp)

```bash
# Linux/macOS/WSL
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Windows
choco install -y rust
```

After installing Rust, blink.cmp will automatically compile with `cargo build --release` for significant performance improvements.

---

## Installation by Platform

### Linux/macOS

1. **Backup existing Neovim configuration (if any)**
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.local/state/nvim ~/.local/state/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
   ```

2. **Clone the repository**
   ```bash
   git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git ~/.config/nvim
   ```

3. **Launch Neovim**
   ```bash
   nvim
   ```

   Lazy.nvim will automatically install all plugins on first launch. This may take a few minutes.

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

---

### Windows

#### Option 1: Direct Clone (Recommended)

1. **Backup existing Neovim configuration (if any)**
   ```powershell
   Move-Item -Path "$env:LOCALAPPDATA\nvim" -Destination "$env:LOCALAPPDATA\nvim.backup" -ErrorAction SilentlyContinue
   Move-Item -Path "$env:LOCALAPPDATA\nvim-data" -Destination "$env:LOCALAPPDATA\nvim-data.backup" -ErrorAction SilentlyContinue
   ```

2. **Clone the repository directly to the Neovim config location**
   ```powershell
   git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git $env:LOCALAPPDATA\nvim
   ```

3. **Launch Neovim**
   ```powershell
   nvim
   ```

   Lazy.nvim will automatically install all plugins.

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

#### Option 2: Clone with Junction Link

This method allows you to keep the config in a custom location while Neovim reads it from the standard location.

1. **Clone to a custom location**
   ```powershell
   cd C:\Users\$env:USERNAME
   git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git modulus-nvim
   ```

2. **Create a junction (not a symlink)**
   ```powershell
   New-Item -ItemType Junction -Path "$env:LOCALAPPDATA\nvim" -Target "C:\Users\$env:USERNAME\modulus-nvim"
   ```

3. **Launch Neovim**
   ```powershell
   nvim
   ```

4. **Continue to [Post-Installation Steps](#post-installation-steps)**

> **Note**: Use a junction, not a symbolic link. Junctions don't require administrator privileges and work reliably with Neovim on Windows.

---

### WSL (Windows Subsystem for Linux)

Follow the same steps as [Linux/macOS](#linuxmacos):

```bash
# 1. Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# 2. Clone repository
git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git ~/.config/nvim

# 3. Launch Neovim
nvim
```

---

## Clipboard Setup (Important)

Copy/paste between Neovim and your system requires platform-specific setup. **This config auto-detects your environment**, but you must install the appropriate clipboard provider.

### Linux (Native)

Install one of these clipboard providers:

```bash
# Option 1: xclip (X11) - Most common
sudo apt install xclip          # Debian/Ubuntu
sudo dnf install xclip          # Fedora

# Option 2: xsel (X11)
sudo apt install xsel           # Debian/Ubuntu
sudo dnf install xsel           # Fedora

# Option 3: wl-clipboard (Wayland)
sudo apt install wl-clipboard   # Debian/Ubuntu
sudo dnf install wl-clipboard   # Fedora
```

Verify clipboard works:
```bash
echo "test" | xclip -selection clipboard
xclip -selection clipboard -o  # Should print "test"
```

### macOS

Clipboard works out of the box via `pbcopy`/`pbpaste`. No setup needed.

### Windows (Native Neovim)

Clipboard works out of the box. No setup needed.

### WSL (Windows Subsystem for Linux)

WSL requires `win32yank.exe` to bridge the Windows clipboard:

```bash
# Download win32yank
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip

# Extract and install
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/

# Verify installation
win32yank.exe --version
```

**The config auto-detects `win32yank.exe`** and configures clipboard integration automatically (see `lua/evanusmodestus/modules/core/settings.lua`).

Verify clipboard works:
```bash
echo "test" | win32yank.exe -i
win32yank.exe -o  # Should print "test"
```

### SSH/Remote Sessions

When using Neovim over SSH, clipboard requires extra setup:

**Option 1: OSC 52 (Recommended for modern terminals)**

Add to your terminal config or use a terminal that supports OSC 52 (iTerm2, kitty, alacritty, Windows Terminal).

**Option 2: X11 Forwarding**
```bash
ssh -X user@host  # Enable X11 forwarding
```
Requires `xclip` on the remote server.

### Verifying Clipboard in Neovim

Inside Neovim, run:
```vim
:checkhealth
```

Look for the **Clipboard** section. It should show:
```
Clipboard (optional)
- OK Clipboard tool found: xclip (or win32yank, pbcopy, etc.)
```

### Clipboard Keybindings

This config uses system clipboard by default (`clipboard = 'unnamedplus'`):

| Key | Action |
|-----|--------|
| `y` | Yank to system clipboard |
| `p` | Paste from system clipboard |
| `<leader>y` | Yank to clipboard (explicit) |
| `<leader>p` | Paste without overwriting register |

---

## Post-Installation Steps

### 1. Install Tree-sitter Parsers

After plugins have installed, install Tree-sitter language parsers:

```vim
:TSInstall all
```

Or install only the languages you need:
```vim
:TSInstall lua vim vimdoc python javascript typescript go rust bash markdown json yaml
```

### 2. Install Language Servers

Open Mason and install the language servers you need:

```vim
:Mason
```

**In the Mason UI:**
- Use `/` to search for a language server
- Press `i` to install
- Press `X` to uninstall
- Press `U` to update all installed servers

**Recommended language servers:**
- **Lua**: `lua-language-server`
- **Python**: `pyright` or `pylsp`
- **JavaScript/TypeScript**: `typescript-language-server`
- **Go**: `gopls`
- **Rust**: `rust-analyzer`
- **C/C++**: `clangd`
- **Bash**: `bash-language-server`
- **JSON**: `json-lsp`
- **YAML**: `yaml-language-server`
- **Markdown**: `marksman`

### 3. Verify Installation

Run Neovim's health check:
```vim
:checkhealth
```

This will show you any issues with your installation.

### 4. Configure Your Terminal Font

Make sure your terminal is using a Nerd Font:

- **iTerm2 (macOS)**: Preferences → Profiles → Text → Font
- **Windows Terminal**: Settings → Profiles → Appearance → Font face
- **Alacritty**: Edit `~/.config/alacritty/alacritty.yml`
- **Kitty**: Edit `~/.config/kitty/kitty.conf`

---

## Troubleshooting

### Plugins Not Installing

**Issue**: Lazy.nvim doesn't install plugins on first launch

**Solutions**:
1. Check Neovim version: `nvim --version` (must be 0.9.0+)
2. Manually trigger installation: `:Lazy sync`
3. Check for errors: `:Lazy log`
4. Clear cache and reinstall:
   ```bash
   # Linux/macOS
   rm -rf ~/.local/share/nvim
   rm -rf ~/.local/state/nvim
   rm -rf ~/.cache/nvim

   # Windows
   Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
   ```

### Tree-sitter Compilation Errors

**Issue**: Tree-sitter parsers fail to compile

**Solutions**:

**Linux**:
```bash
# Debian/Ubuntu
sudo apt install build-essential

# Fedora
sudo dnf install gcc make
```

**macOS**:
```bash
xcode-select --install
```

**Windows**:
- Install Visual Studio Build Tools from Microsoft
- Or install MinGW-w64 via MSYS2
- Ensure compiler is in your PATH

### LSP Not Working

**Issue**: Language server isn't providing completions or diagnostics

**Solutions**:
1. Check LSP status: `:LspInfo`
2. Verify server is installed: `:Mason`
3. Check LSP logs: `:LspLog`
4. Restart LSP: `:LspRestart`

### Mason Install Fails

**Issue**: Mason can't install language servers

**Solutions**:
1. Check you have internet connectivity
2. Verify Node.js is installed: `node --version`
3. Check Mason log: `:MasonLog`
4. Try manual installation:
   ```vim
   :MasonInstall <server-name>
   ```

### Icons Not Showing (Question Marks/Boxes)

**Issue**: You see `?` or boxes instead of icons

**Solution**:
- Install a Nerd Font (see [Prerequisites](#prerequisites))
- Configure your terminal to use the Nerd Font
- Restart your terminal

### Slow Startup

**Issue**: Neovim takes a long time to start

**Solutions**:
1. Profile startup time:
   ```bash
   nvim --startuptime startup.log
   ```
2. Disable unused plugins in `lua/evanusmodestus/lazy-plugins.lua`
3. Reduce Tree-sitter parsers (only install what you need)
4. Use lazy loading for plugins (most are already configured for this)

### Windows-Specific: Line Ending Issues

**Issue**: Files have wrong line endings (^M characters)

**Solution**:
```bash
git config --global core.autocrlf true
```

### Clipboard Not Working

**Issue**: Copy/paste between Neovim and system clipboard doesn't work

**Diagnosis**:
```vim
:checkhealth
```
Look for the Clipboard section.

**Solutions by platform**:

**Linux**:
```bash
# Check if clipboard tool exists
which xclip xsel wl-copy

# Install one if missing
sudo apt install xclip  # Debian/Ubuntu
sudo dnf install xclip  # Fedora
```

**WSL**:
```bash
# Check if win32yank is installed and accessible
which win32yank.exe
win32yank.exe --version

# If not found, install it (see Clipboard Setup section above)
```

**SSH sessions**:
- X11 forwarding: `ssh -X user@host` and install `xclip` on remote
- Or use a terminal with OSC 52 support

**Verify Neovim detected it**:
```vim
:echo has('clipboard')     " Should return 1
:echo &clipboard           " Should show 'unnamedplus'
```

---

## Updating

### Update Configuration

```bash
cd ~/.config/nvim  # Or your install location
git pull origin main
```

### Update Plugins

Inside Neovim:
```vim
:Lazy sync
```

### Update Language Servers

```vim
:Mason
# Press U to update all installed servers
```

### Update Tree-sitter Parsers

```vim
:TSUpdate
```

---

## Uninstallation

### Linux/macOS

```bash
# Remove configuration
rm -rf ~/.config/nvim

# Remove data
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

### Windows

```powershell
# Remove configuration
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim

# Remove data
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data
```

### Restore Backup

If you backed up your old config:

```bash
# Linux/macOS
mv ~/.config/nvim.backup ~/.config/nvim
mv ~/.local/share/nvim.backup ~/.local/share/nvim

# Windows
Move-Item -Path "$env:LOCALAPPDATA\nvim.backup" -Destination "$env:LOCALAPPDATA\nvim"
```

---

## Getting Help

- **Check Documentation**: See [KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md) and [LSP_CONFIGURATION.md](LSP_CONFIGURATION.md)
- **Run Health Check**: `:checkhealth` in Neovim
- **Check Plugin Status**: `:Lazy` for plugin manager UI
- **Check LSP Status**: `:LspInfo` for LSP information
- **View Logs**: `:Lazy log` for plugin logs, `:LspLog` for LSP logs

---

**Installation complete!** Check out the [KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md) to learn the essential keybindings.
