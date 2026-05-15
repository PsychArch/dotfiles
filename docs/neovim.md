# Neovim

The Neovim setup is a simple editor, not a full IDE. It keeps fuzzy finding, file browsing, Git context, and small editing helpers, while leaving language-specific tooling to projects.

## Files

- `~/.config/nvim/init.lua`
- `~/.config/nvim/lua/config/*.lua`
- `~/.config/nvim/lua/plugins/*.lua`

## Core Behavior

- Leader key: `Space`
- Lazy.nvim bootstraps itself on first launch
- Options, keymaps, and autocmds load before plugins
- Built-in syntax highlighting is used instead of managed Treesitter parsers
- No LSP, formatter, Mason, or Treesitter package management is configured

## Main Plugins

- Telescope for fuzzy finding
- Neo-tree for file browsing
- Lualine, Bufferline, and Catppuccin for UI
- Gitsigns and Diffview for Git workflow
- nvim-surround, autopairs, comments, alignment, and indentation helpers

## Common Keys

- `Space ff`: find files
- `Space fr`: recent files
- `Space fs`: live grep
- `Space fb`: buffers
- `Space gd`: open Diffview
- `Space gh`: file history
- `Space ee`: toggle Neo-tree
- `Space ef`: reveal the current file in Neo-tree

## Notes

The config assumes common external tools are available: `git`, `ripgrep`, `fd`, `fzf`, Node.js, npm, Python, and Neovim 0.11 or newer. The optional package bootstrap installs these where possible.

Install language-specific tools manually per project when a workflow needs them.
