# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Applying Configuration

To apply changes to the system:

```bash
sudo darwin-rebuild switch --flake ~/nix-config#"Aden's Brain"
```

This is aliased as `drs` in zsh.

## Architecture

This is a macOS (aarch64-darwin, Apple Silicon) Nix flake configuration using **nix-darwin** for system-level settings and **Home Manager** for user-level dotfiles and packages.

**Flake inputs** (pinned in `flake.lock`):
- `nixpkgs-25.05-darwin` — package set
- `nix-darwin` — macOS system management
- `home-manager` (release-25.05) — user environment

**Entry points:**
- `flake.nix` — defines the single host `"Aden's Brain"` (aarch64-darwin)
- `configuration.nix` — nix-darwin system settings
- `home.nix` — Home Manager root; imports all modules and declares packages

**Modules** (`modules/`): Each file is a focused Home Manager module imported by `home.nix`:
- `zsh.nix` — shell aliases and init (direnv, starship)
- `nvim.nix` — symlinks `nvim/` into `~/.config/nvim`
- `kitty.nix` — terminal emulator (JetBrains Mono, ayu-light theme)
- `git.nix` — git identity
- `ssh.nix` — SSH config for GitHub and UChicago HPC clusters

**Root files:**
- `env.nix` — non-secret environment variables (VISUAL, EDITOR); secrets go in `~/.secrets`

**Neovim config** (`nvim/`): Lua-based, managed by lazy.nvim:
- `lua/config/` — options, keymaps, lazy setup
- `lua/plugins/` — plugin specs (Telescope, VimTeX, Treesitter, nvim-cmp, LSP, Copilot, etc.)
- `lua/lsp/` — LSP on_attach handlers
- `lua/snippets/` — LuaSnip snippets for LaTeX

## Key Conventions

- Neovim config lives in `nvim/` and is **symlinked** (not copied) into `~/.config/nvim` by `modules/nvim.nix`. Edit files in `nvim/` directly.
- Custom scripts in `bin/` are added to PATH via `home.nix`.
- `env.nix` is git-tracked — only non-secret values. API keys go in `~/.secrets` (sourced by zsh).
- Copilot is context-aware: disabled in `/courses/` paths except files named `notes`.
