# Zsh

The Zsh setup is optimized for interactive terminal work: fast static plugin loading, useful completion, FZF-powered selection, and a small set of local override hooks.

## Files

- `~/.zshrc` from `dot_zshrc`
- `~/.zsh_plugins.txt` from `dot_zsh_plugins.txt`
- `~/.zsh_plugins.zsh`, generated locally by Antidote

## Features

- Adds `~/.local/bin` and `PNPM_HOME/bin` to `PATH`
- Defines FZF options before loading FZF shell integration in terminal sessions
- Loads completions with cached `compinit`
- Uses per-session history with duplicate cleanup
- Enables substring history search on the arrow keys
- Configures FZF file, history, and directory pickers
- Initializes zoxide when available
- Aliases `ls` and `tree` to `eza`, and `vi`/`vim` to `nvim`, only when those tools exist

## Plugin Set

- `mattmc3/antidote` for static plugin bundles
- `zsh-users/zsh-completions` for additional completion definitions
- `Aloxaf/fzf-tab` for fuzzy completion menus
- `zsh-users/zsh-autosuggestions` for command suggestions
- `zdharma-continuum/fast-syntax-highlighting` for syntax highlighting
- Selected Oh My Zsh libraries/plugins for Git prompt helpers, colored man pages, command-not-found, interactive directory changes, and substring history search

## Local Customization

Use `~/.zshrc.local` for local aliases and functions. Use `~/.api_keys.zsh` for secrets such as API keys. Both files stay outside chezmoi management.

After editing `~/.zsh_plugins.txt`, regenerate the plugin bundle with:

```bash
rm -f ~/.zsh_plugins.zsh
source ~/.zshrc
```

If completion paths change, also remove `~/.zcompdump*` so `compinit` rebuilds its cache.

## Notes

The config is skipped for non-interactive shells, which keeps tools like `scp` and remote commands from loading the interactive prompt and plugin stack.
