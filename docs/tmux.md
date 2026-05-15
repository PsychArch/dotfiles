# Tmux

The tmux config keeps the plugin surface small while making pane work, copy mode, and fuzzy navigation comfortable.

## Files

- `~/.config/tmux/tmux.conf`
- `~/.config/tmux/plugins/tpm`, cloned by `run_after_20-tmux.sh`

## Keys

- Prefix: `Alt-b`
- Split panes: `Alt-b |`, `Alt-b \`, `Alt-b -`
- Move panes: `Alt-b h/j/k/l`
- Resize panes: `Alt-b Ctrl-h/j/k/l`
- Previous/next window without prefix: `Alt-[` and `Alt-]`
- New window: `Alt-b c` or `Alt-b Alt-c`
- Kill pane: `Alt-b q`
- Reload config: `Alt-b r`
- Launch tmux-fzf: `Alt-f`

## Behavior

- Window and pane indexes start at 1
- Mouse mode is enabled
- Copy mode uses vi keys
- OSC 52 clipboard support is enabled in `external` mode
- Copy mode uses tmux `copy-command` with `pbcopy`, `wl-copy`, `xclip`, or `xsel` when available
- Sixel support is documented but not enabled globally; it should be matched to the outer terminal
- Activity is visual-only and does not trigger bells

## Plugins

TPM manages the plugins declared in `tmux.conf`:

- `tmux-plugins/tpm`
- `sainnhe/tmux-fzf`

The repo does not enable session resurrection, auto-restore, or theme plugins.

## Compatibility Notes

- `tmux-fzf` uses tmux popups, so tmux 3.2 or newer is recommended.
- Scrollbar settings are left commented because they require tmux 3.6 or newer.
- TPM is stable and widely used, but its upstream changes slowly; keep the plugin list small.
