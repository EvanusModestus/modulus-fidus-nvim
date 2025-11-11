# Modulus Fidus

> Fidus (Latin: "trustworthy, reliable, faithful") - A hardened Neovim configuration for enterprise and professional environments

**Modulus Fidus** is a security-focused variant of [modulus-nvim](https://github.com/EvanusModestus/modulus-nvim), designed specifically for enterprise environments where security, compliance, and reliability are non-negotiable.

## Security First

- **Zero External Data Transmission**: No plugins that send code to cloud services
- **No Telemetry**: Absolutely no analytics or phone-home behavior
- **Reproducible Builds**: All plugin versions pinned, lockfile committed
- **Minimal Attack Surface**: Only essential plugins, thoroughly vetted
- **Comprehensive Documentation**: Every security decision explained in [SECURITY.md](SECURITY.md)

## What's Removed (vs. Modulus)

Modulus Fidus removes plugins that pose security or compliance risks:

| Removed | Reason |
|---------|--------|
| GitHub Copilot | Sends code to Microsoft servers - violates data privacy policies |
| Obsidian Plugins | Personal note-taking tools, not enterprise-focused |
| Markdown Preview | Requires npm install and browser access |
| Glow Markdown Viewer | Requires external binary downloads |
| Cellular Automaton | Fun animations, no business value |

**See [SECURITY.md](SECURITY.md) for complete security analysis of all plugins.**

## Who Is This For?

- **Enterprise Developers**: Working on proprietary codebases with strict security policies
- **Government/Defense**: Environments with data residency and compliance requirements
- **Financial Services**: Regulated industries with audit requirements
- **Security-Conscious Teams**: Anyone who needs a trustworthy, vetted editor configuration
- **Air-Gapped Environments**: Networks with restricted internet access

## What's Included

### Core Development Features
- **LSP Support**: Full language server protocol with Mason integration
- **Ultra-Fast Completion**: blink.cmp with Rust-powered fuzzy matching
- **Intelligent Navigation**: Telescope fuzzy finder, Oil.nvim, Harpoon
- **Git Integration**: Fugitive and Gitsigns for professional workflows
- **Debugging**: DAP (Debug Adapter Protocol) support
- **Syntax Highlighting**: Tree-sitter based parsing

### Enterprise-Ready Tools
- **Database Client**: vim-dadbod for SQL workflows
- **REST Client**: curl-based HTTP testing (user-initiated only)
- **CSV Support**: Professional CSV/TSV editing
- **Network Config**: Cisco/Junos syntax support
- **Session Management**: Workspace persistence

## Quick Start

```bash
# Clone the repository
git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git ~/.config/nvim

# Launch Neovim (plugins auto-install)
nvim

# Install language servers
:Mason
```

For complete installation instructions including air-gapped environments, see **[INSTALLATION.md](INSTALLATION.md)**.

## Architecture

```
modulus-fidus-nvim/
├── init.lua                    # Entry point
├── lua/evanusmodestus/
│   ├── init.lua                # Module initialization
│   ├── lazy-plugins.lua        # Hardened plugin specifications
│   └── modules/
│       ├── core/               # Editor settings & keymaps
│       ├── plugins/            # 20+ vetted plugin configs
│       ├── lsp/                # LSP configuration
│       └── ui/                 # UI enhancements
├── SECURITY.md                 # Security documentation
├── INSTALLATION.md             # Installation guide
├── lazy-lock.json              # Pinned plugin versions (committed)
└── .gitignore                  # Version control settings
```

## Documentation

- **[SECURITY.md](SECURITY.md)** - Complete security analysis and best practices
- **[INSTALLATION.md](INSTALLATION.md)** - Installation for all environments
- **[KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md)** - Complete keymap reference
- **[LSP_CONFIGURATION.md](LSP_CONFIGURATION.md)** - LSP setup and troubleshooting

## Essential Keybindings

### Leader Key: `<Space>`

#### File Navigation
- `<leader>pf` - Find files (Telescope)
- `<leader>ps` - Grep search project
- `<leader>pv` - File explorer (Oil.nvim)

#### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `<leader>vca` - Code actions
- `<leader>vrn` - Rename symbol

#### Git
- `<leader>gs` - Git status (Fugitive)
- `<leader>gd` - Git diff

For complete keybindings, see **[KEYMAP_REFERENCE.md](KEYMAP_REFERENCE.md)**.

## Security Audit Summary

### Network Access
- **Plugin Installation**: GitHub (Lazy.nvim, Mason)
- **Runtime**: Zero network access except user-initiated (REST client, database)

### Data Storage
- **Sessions**: `~/.local/state/nvim/sessions/` (may contain file paths)
- **Swap Files**: `~/.local/state/nvim/swap/` (temporary editing state)
- **No Cloud Sync**: All data stays local

### Supply Chain
- **Pinned Versions**: `lazy-lock.json` committed to git
- **Update Policy**: Security patches applied immediately, features reviewed
- **Audit Trail**: All changes documented in git history

**See [SECURITY.md](SECURITY.md) for complete analysis.**

## Requirements

- Neovim 0.9.0 or higher
- Git
- Build tools (gcc/make for Tree-sitter compilation)
- ripgrep (for Telescope grep)
- curl (for REST client)
- Node.js (for npm-based LSP servers)

See **[INSTALLATION.md](INSTALLATION.md)** for platform-specific installation.

## Best Practices

### For System Administrators
1. Review [SECURITY.md](SECURITY.md) before deployment
2. Consider air-gapped installation for high-security environments
3. Audit plugin updates before applying to production systems
4. Monitor `~/.local/share/nvim/` for suspicious files

### For Developers
1. Don't hardcode credentials in config files
2. Be mindful when using REST client on production servers
3. Review session files periodically for sensitive paths
4. Use `.gitignore` to exclude swap files and sessions

## Modulus vs. Modulus Fidus

| Feature | Modulus | Modulus Fidus |
|---------|---------|---------------|
| **Target Audience** | Learners, hobbyists, public use | Enterprise, security-conscious professionals |
| **GitHub Copilot** | Included | Removed (security) |
| **Obsidian Integration** | Included | Removed (not enterprise-focused) |
| **Plugin Count** | 27+ | 20+ (only essential) |
| **Version Pinning** | Partial | Complete |
| **Security Docs** | Basic | Comprehensive (SECURITY.md) |
| **Lockfile** | Optional | Committed |
| **Air-Gapped Support** | No | Yes |
| **Compliance Ready** | No | Yes |

**Use Modulus**: If you want a feature-rich, learning-friendly config
**Use Modulus Fidus**: If you need enterprise-grade security and compliance

## Contributing

Security-focused contributions welcome! Please:
1. Review [SECURITY.md](SECURITY.md) first
2. Justify any new plugin additions with security analysis
3. Update SECURITY.md for any changes
4. Test in air-gapped environment if applicable

## Reporting Security Issues

**Do NOT open public issues for security vulnerabilities.**

Email: [Your contact] with:
- Description of the vulnerability
- Reproduction steps
- Impact assessment

Allow 48 hours for initial response.

## License

This configuration is provided as-is for enterprise use and learning purposes.

## Acknowledgments

- Based on [modulus-nvim](https://github.com/EvanusModestus/modulus-nvim)
- Built with tools from the Neovim community
- Hardened for enterprise use

---

**Modulus Fidus** - _Trustworthy Neovim for those who need it most_

**Repository**: https://github.com/EvanusModestus/modulus-fidus-nvim
**Security**: See [SECURITY.md](SECURITY.md)
**Installation**: See [INSTALLATION.md](INSTALLATION.md)
