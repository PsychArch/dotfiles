# Dotfiles

Public chezmoi dotfiles for a small terminal development environment.

This repo manages user-level configuration for Zsh, tmux, Neovim, and Git, with an optional bootstrap for common command-line tools.

## Quick Start

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply PsychArch/dotfiles
```

This installs chezmoi if needed, clones `https://github.com/PsychArch/dotfiles.git`, renders the local config, and applies the dotfiles.

If chezmoi is already installed:

```bash
chezmoi init --apply PsychArch/dotfiles
```

To use SSH instead of HTTPS:

```bash
chezmoi init --ssh --apply PsychArch/dotfiles
```

Or from a local checkout:

```bash
chezmoi init --apply /path/to/dotfiles
```

On first apply, chezmoi prompts for:

- Git user name and email
- Whether to install command-line tools during `chezmoi apply`

The package installer is opt-in. With the default answer, chezmoi only applies dotfiles and user-level plugin setup.

## Core Features

- Zsh with Antidote plugin bundling, completion, autosuggestions, syntax highlighting, FZF integration, and local override hooks
- Tmux with an `Alt-b` prefix, vi-style copy/navigation, safe clipboard behavior, Catppuccin Mocha colors, and `tmux-fzf`
- Neovim as a simple editor with Lazy.nvim, Telescope, Neo-tree, Git signs, Diffview, and small editing helpers
- Git defaults for identity, pull rebase, `main` as the default branch, and a global ignore file
- Optional command-line tool bootstrap for Arch and macOS

## Daily Commands

```bash
chezmoi diff
chezmoi apply
chezmoi edit ~/.zshrc
chezmoi re-add ~/.config/nvim
```

To update this checkout after pulling repo changes:

```bash
chezmoi update
```

## Local Overrides

The shell config sources these files when present:

- `~/.zshrc.local` for machine-specific aliases, functions, and environment variables
- `~/.api_keys.zsh` for local secrets

Do not add those files to this repository.

## Optional Packages

Package installation is disabled by default. To enable it later, set this in your chezmoi config, usually `~/.config/chezmoi/chezmoi.toml`:

```toml
[data]
    installPackages = true
```

Then run:

```bash
chezmoi apply
```

When enabled, the installer uses the system package manager where appropriate. See [Packages](docs/packages.md).

## Layout

```text
dot_zshrc
dot_zsh_plugins.txt
dot_gitconfig.tmpl
dot_gitignore_global
dot_config/
  nvim/
  tmux/tmux.conf
scripts/
shared/
run_after_*.sh
run_onchange_before_install-packages.sh.tmpl
```

## Documentation

- [Zsh](docs/zsh.md)
- [Tmux](docs/tmux.md)
- [Neovim](docs/neovim.md)
- [Packages](docs/packages.md)

## License

MIT
