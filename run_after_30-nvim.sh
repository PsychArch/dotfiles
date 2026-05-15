#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="${CHEZMOI_SOURCE_DIR:-${SCRIPT_DIR}}"
LOGGER_LIB="${SOURCE_DIR}/shared/logger.sh"
if [ ! -f "${LOGGER_LIB}" ]; then
  echo "logger library not found at ${LOGGER_LIB}" >&2
  exit 1
fi
# shellcheck source=/dev/null
source "${LOGGER_LIB}"

cleanup_tmp() {
  [ -n "${lazy_log:-}" ] && [ -f "${lazy_log}" ] && rm -f "${lazy_log}"
  [ -n "${build_log:-}" ] && [ -f "${build_log}" ] && rm -f "${build_log}"
}

if ! command -v nvim >/dev/null 2>&1; then
  log_block "Sync Neovim plugins"
  log_skip "Neovim is not installed"
  log_end_block
  exit 0
fi

lazy_log=$(mktemp -t lazy-sync-XXXXXX.log)
build_log=''
trap cleanup_tmp EXIT

log_block "Sync Neovim plugins"
if nvim --headless '+lua require("lazy").sync({ wait = true })' +qa >/dev/null 2>"${lazy_log}"; then
  log_done "Plugin sync complete"
else
  log_fail "Neovim plugin sync failed; log output follows"
  while IFS= read -r line; do
    log_info "$line"
  done <"${lazy_log}"
  log_end_block
  exit 1
fi
log_end_block

telescope_dir="${HOME}/.local/share/nvim/lazy/telescope-fzf-native.nvim"
log_block "Compile telescope-fzf-native.nvim"
if [ ! -d "${telescope_dir}" ]; then
  log_skip "Plugin not installed"
elif ! command -v make >/dev/null 2>&1; then
  log_warn "make not found; install it to build native telescope extensions"
  log_info "Example: sudo pacman -S make or sudo apt install make"
else
  build_log=$(mktemp -t telescope-build-XXXXXX.log)
  if (cd "${telescope_dir}" && make >/dev/null 2>"${build_log}"); then
    log_done "Native extension built"
  else
    log_warn "Failed to compile telescope-fzf-native.nvim; log output follows"
    while IFS= read -r line; do
      log_info "$line"
    done <"${build_log}"
  fi
fi
log_end_block
