# Packages

Package installation is optional and disabled by default. The dotfiles work best when the common terminal tools are already available, but applying the repo should not unexpectedly change a machine's package state.

## Enable

Set this in your chezmoi config, usually `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    installPackages = true
```

Then run:

```bash
chezmoi apply
```

## What It Installs

The package list focuses on tools used by these dotfiles:

- Shell and terminal: `zsh`, `tmux`
- Editor and search: `neovim`, `ripgrep`, `fd`, `fzf`
- Navigation and listing: `zoxide`, `eza`, `bat`
- Runtime basics: Node.js/npm/pnpm, Python, `uv`
- Utilities: `git`, `curl`, `wget`, `jq`, archives, and SSH client tools

## Install Paths

- Arch uses `pacman` when sudo/root access is available.
- macOS uses Homebrew.

If system package installation is unavailable, package bootstrap is skipped.

## Edit The List

Package definitions live in `.chezmoidata/packages.yaml`. The helper scripts under `scripts/` read that file and should stay generic; add or remove tools in the YAML first.
