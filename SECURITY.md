# Security Documentation - Modulus Fidus

This document outlines the security considerations, modifications, and best practices for the Modulus Fidus Neovim configuration.

## Overview

Modulus Fidus is a hardened variant of [modulus-nvim](https://github.com/EvanusModestus/modulus-nvim) designed specifically for enterprise and professional environments where security, privacy, and compliance are paramount.

## Security Principles

1. **No External Data Transmission**: No plugins that send code or data to external servers
2. **Minimal Attack Surface**: Only essential plugins, no "fun" or experimental features
3. **Reproducible Builds**: All plugin versions pinned, lockfile committed
4. **Local-First**: All processing happens locally, no cloud dependencies
5. **Audit Trail**: Clear documentation of what each plugin does and why it's included

## Removed Plugins (Security Rationale)

### 🔴 High Risk - Removed

| Plugin | Reason Removed | Security Concern |
|--------|----------------|------------------|
| **github/copilot.vim** | Sends code to GitHub/Microsoft servers | **Data Exfiltration**: All code typed is sent externally for AI processing. Violates data privacy policies in most enterprises. |
| **iamcco/markdown-preview.nvim** | Requires npm install and browser access | **Supply Chain Risk**: Executes `npm install`, downloads packages from npm registry. Opens browser with local server. |
| **ellisonleao/glow.nvim** | Requires external binary installation | **Binary Trust**: Requires downloading pre-compiled binary from GitHub releases. |

### 🟡 Medium Risk - Removed

| Plugin | Reason Removed | Rationale |
|--------|----------------|-----------|
| **epwalsh/obsidian.nvim** | Personal note-taking tool | Not enterprise-focused. References personal vault paths. Adds complexity without business value. |
| **obsidian-capture** (custom) | Custom capture system for Obsidian | Personal workflow tool, hardcoded personal paths, not applicable to enterprise use. |
| **obsidian-templates** (custom) | Custom templates for Obsidian | Same as above |

### 🟢 Low Risk - Removed for Minimalism

| Plugin | Reason Removed |
|--------|----------------|
| **eandrju/cellular-automaton.nvim** | Fun animation plugin, no business value |

## Included Plugins - Security Assessment

### ✅ Core Development Tools (Trusted)

| Plugin | Purpose | Security Notes |
|--------|---------|----------------|
| **nvim-telescope/telescope.nvim** | Fuzzy finder | Local file search only, no network access |
| **nvim-treesitter/nvim-treesitter** | Syntax parsing | Compiles C parsers locally, no network after install |
| **neovim/nvim-lspconfig** | LSP client | Communicates with local language servers only |
| **williamboman/mason.nvim** | LSP server installer | **Downloads binaries from GitHub**. Use with caution. |
| **saghen/blink.cmp** | Completion engine | Rust-based, local processing only |

### ⚠️ Network-Capable Plugins (Audit Required)

| Plugin | Network Capability | Mitigation |
|--------|-------------------|------------|
| **mason.nvim** | Downloads language server binaries from GitHub/npm | **Recommendation**: Pre-install LSP servers in air-gapped environments. Use Mason only on trusted networks. |
| **lazy.nvim** | Downloads plugins from GitHub on install/update | **Mitigation**: lockfile committed, versions pinned. Only updates when explicitly triggered. |

### 🔍 Data Processing Plugins (Safe)

| Plugin | What It Processes | Security |
|--------|------------------|----------|
| **vim-dadbod** | Database connections | User-initiated only. **Warning**: Connection strings may contain credentials. |
| **simple-rest.lua** (custom) | HTTP requests via curl | User-initiated only. Can access internal networks. |
| **nvim-dap** | Debugging | Local debugger communication only |

## Security Best Practices

### For System Administrators

1. **Air-Gapped Installation**:
   ```bash
   # On internet-connected machine:
   git clone https://github.com/EvanusModestus/modulus-fidus-nvim.git
   nvim # Let plugins install
   tar -czf nvim-fidus-airgapped.tar.gz ~/.config/nvim ~/.local/share/nvim

   # On air-gapped server:
   tar -xzf nvim-fidus-airgapped.tar.gz -C ~/
   ```

2. **Network Restrictions**:
   - Block outbound connections except to approved package repositories
   - Consider running Mason in a controlled environment and copying binaries

3. **Audit Plugin Updates**:
   - Review `lazy-lock.json` diffs before updating
   - Test updates in non-production environment first

### For Developers

1. **Database Credentials**:
   - Never hardcode connection strings in Vim configurations
   - Use environment variables or secure vaults
   - Ensure Vim swap files (`*.swp`) are in `.gitignore`

2. **REST Client Usage**:
   - Be mindful when testing APIs from production servers
   - Don't accidentally probe internal infrastructure
   - Logs may contain sensitive request/response data

3. **Session Persistence**:
   - Auto-session saves open files and paths
   - Be aware of what gets persisted (may include file paths to sensitive code)
   - Session files stored in `~/.local/state/nvim/sessions/`

## Compliance Considerations

### Data Residency
✅ **All processing happens locally**. No data leaves the machine except:
- Plugin downloads (during install/update via Lazy.nvim)
- LSP server downloads (via Mason.nvim)
- User-initiated network requests (REST client, Database connections)

### GDPR / Privacy
✅ **No telemetry or analytics** are collected by any plugin in this configuration.

### Audit Logging
⚠️ **Vim does not log user actions by default**. If your organization requires audit logs:
- Consider using system-level audit tools (e.g., `auditd` on Linux)
- Monitor file access patterns
- Log shell command execution

## Network Endpoints Used

### During Installation
| Endpoint | Purpose | When |
|----------|---------|------|
| `github.com` | Plugin downloads (Lazy.nvim) | Initial install, `:Lazy sync` |
| `github.com/releases` | LSP server binaries (Mason) | `:MasonInstall <server>` |
| `registry.npmjs.org` | Node-based LSP servers (Mason) | `:MasonInstall <server>` for npm-based servers |

### During Runtime
| Endpoint | Purpose | Triggered By |
|----------|---------|--------------|
| **User-defined** | REST API calls | User executing requests in `.http` files |
| **User-defined** | Database connections | User connecting via vim-dadbod |
| **None** | All other operations are local | N/A |

## Incident Response

### If a Plugin is Compromised

1. **Identify**:
   ```bash
   # Check plugin commit hashes
   cd ~/.local/share/nvim/lazy/<plugin-name>
   git log -1
   ```

2. **Remove**:
   ```vim
   :Lazy clean  # Remove the plugin
   ```

3. **Audit**:
   - Check `~/.local/state/nvim/` for any suspicious files
   - Review recent file modifications: `ls -lt ~/.config/nvim/`

4. **Restore**:
   - Revert to known-good commit in this repository
   - Reinstall from scratch if needed

## Security Updates

**This configuration is maintained at**:
- Repository: `https://github.com/EvanusModestus/modulus-fidus-nvim`
- Security issues: Report via GitHub Issues (mark as [SECURITY])

**Update Policy**:
- Security patches: Applied immediately
- Plugin updates: Reviewed and tested before merge
- Breaking changes: Documented in CHANGELOG.md

## Frequently Asked Questions

### Q: Can I use this on a corporate VPN?
✅ **Yes**. The configuration works entirely locally. VPN does not affect functionality.

### Q: Does this configuration phone home or report telemetry?
✅ **No**. Zero telemetry or analytics.

### Q: Can I use Mason to install language servers on an air-gapped network?
⚠️ **Not directly**. Mason requires internet access to download binaries. See "Air-Gapped Installation" section above.

### Q: Is the REST client safe to use in production?
⚠️ **Use with caution**. It's just a curl wrapper. Be mindful of what endpoints you're hitting and what data you're sending.

### Q: What about auto-session? Does it store sensitive data?
⚠️ **Potentially**. It stores file paths and buffer contents. Sensitive file paths could be persisted. Review `~/.local/state/nvim/sessions/` periodically.

## Reporting Security Issues

If you discover a security vulnerability:
1. **Do NOT** open a public GitHub issue
2. Email: [Your contact email]
3. Include: Description, reproduction steps, impact assessment
4. Allow 48 hours for initial response

## License

This configuration is provided "as-is" for enterprise use. See LICENSE file for details.

---

**Last Updated**: 2025-10-27
**Maintainer**: EvanusModestus
**Version**: 1.0.0
