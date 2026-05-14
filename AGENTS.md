# AGENTS.md

This file gives coding agents working in this repository the local context needed to make changes safely.

## User Context

- User is on macOS Apple Silicon.
- This repository is a personal Nix workstation config for research workflows.
- Primary tools are Nix, Neovim, Git, zsh, Python, Julia, and LaTeX.
- Prefer direct, maintainable edits that fit the existing structure.
- Do not remove working global research tools unless explicitly asked.

## Applying Configuration

Build before switching:

```bash
darwin-rebuild build --flake ~/nix-config#"Aden's Brain"
```

Apply changes:

```bash
sudo darwin-rebuild switch --flake ~/nix-config#"Aden's Brain"
```

The switch command is aliased as `drs` in zsh.

## Architecture

This is a macOS Nix flake using nix-darwin for system-level settings and Home Manager for user-level packages and dotfiles.

Flake inputs are pinned in `flake.lock`:

- `nixpkgs-25.11-darwin` for the package set.
- `nix-darwin-25.11` for macOS system management.
- `home-manager` `release-25.11` for the user environment.

Entry points:

- `flake.nix` defines the single host `"Aden's Brain"` for `aarch64-darwin`.
- `configuration.nix` contains nix-darwin system settings, Homebrew casks, Nix GC, and store optimisation schedules.
- `home.nix` is the Home Manager root; it imports modules and declares user packages.

Focused Home Manager modules live in `modules/`:

- `zsh.nix` for aliases and shell init.
- `nvim.nix` for symlinking the repo Neovim config into `~/.config/nvim`.
- `kitty.nix` for terminal config.
- `git.nix` for Git identity using `programs.git.settings`.
- `ssh.nix` for SSH defaults and GitHub identity.
- `hammerspoon.nix`, `karabiner.nix`, `sioyek.nix`, and `tex.nix` for app-specific config.

Other important roots:

- `env.nix` contains non-secret environment variables only.
- `bin/` contains user scripts installed into `~/bin`.
- `templates/research-python/` is a flake template for Python research projects using Nix plus `uv`.
- `nvim/lazy-lock.json` pins lazy.nvim plugin revisions.

## Intentional Choices

- Global Python/Jupyter/scientific packages stay installed in `home.nix` for continuity.
- Global LaTeX stays installed through `texlive.combined.scheme-full`.
- Project-specific Python environments should use per-project flakes, preferably starting from the `research-python` template.
- Neovim remains hybrid: the config is live-editable in this repo, while lazy.nvim plugin revisions are pinned by `nvim/lazy-lock.json`.
- GUI apps remain Homebrew casks where appropriate.
- Secrets belong in `~/.secrets`, sourced by zsh; do not commit secrets to this repo.

## Working With This Repo

- Preserve uncommitted user changes.
- Do not run `darwin-rebuild switch` unless explicitly asked.
- Prefer `darwin-rebuild build` and `nix flake check --no-write-lock-file` for verification.
- If adding new files referenced by `flake.nix`, make Git aware of them before relying on `--flake .`; dirty Git flakes ignore untracked files.
- Keep `home.stateVersion` and `system.stateVersion` unchanged unless a migration explicitly requires changing them.
- Use `nixfmt-rfc-style` for Nix files and `shfmt`/`shellcheck` for shell scripts.
- Do not replace the live Neovim symlink workflow with fully Nix-managed plugins unless explicitly requested.

## Common Checks

Run these after structural Nix changes:

```bash
nix flake check --no-write-lock-file
darwin-rebuild build --flake ~/nix-config#"Aden's Brain"
```

Run these after script or formatting changes:

```bash
shellcheck bin/sioyek-inverse-search bin/tmux-courses.sh bin/update-notes.sh
shfmt -w bin/sioyek-inverse-search bin/tmux-courses.sh bin/update-notes.sh
```

Run this after Neovim config changes:

```bash
nvim --headless "+lua print('nvim ok')" +qa
```

## Notes

- `result`, `.nvimlog`, and generated Everforest syntax cache directories are ignored.
- `bin/update-notes.sh` is a wrapper around the Box-hosted notes update script.
- `bin/pdf2img.py` uses a portable `python3` shebang and depends on PDF/ImageMagick tools provided globally.
