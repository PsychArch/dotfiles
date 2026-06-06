#!/bin/bash
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

ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"
PLUGINS_TXT="${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
PLUGINS_CACHE="${ZDOTDIR:-$HOME}/.zsh_plugins.zsh"
ZSHRC_PATH="${ZDOTDIR:-$HOME}/.zshrc"
ZSHRC_ZWC="${ZSHRC_PATH}.zwc"
ZSHRC_LOCAL="${HOME}/.zshrc.local"

ensure_local_zshrc() {
  if [ -f "${ZSHRC_LOCAL}" ]; then
    log_skip "${ZSHRC_LOCAL} already exists"
    return 0
  fi

  log_info "Creating ${ZSHRC_LOCAL}"
  : > "${ZSHRC_LOCAL}"
}

ensure_antidote() {
  if [ -d "${ANTIDOTE_DIR}/.git" ]; then
    log_info "Updating Antidote in ${ANTIDOTE_DIR}"
    git -C "${ANTIDOTE_DIR}" pull --ff-only --quiet
  elif [ -e "${ANTIDOTE_DIR}" ]; then
    log_info "${ANTIDOTE_DIR} exists but is not a git repo"
    return 1
  else
    log_info "Cloning Antidote into ${ANTIDOTE_DIR}"
    git clone --depth 1 --quiet https://github.com/mattmc3/antidote.git "${ANTIDOTE_DIR}"
  fi
}

bundle_antidote_plugins() {
  log_info "Bundling plugins defined in ${PLUGINS_TXT}"
  zsh -c "set -e; set -o pipefail; ZDOTDIR='${ZDOTDIR:-$HOME}'; source '${ANTIDOTE_DIR}/antidote.zsh'; antidote bundle <'${PLUGINS_TXT}' >'${PLUGINS_CACHE}'"
}

compile_zshrc() {
  if [ ! -f "${ZSHRC_PATH}" ]; then
    log_skip "${ZSHRC_PATH} not found"
    return 0
  fi

  if [ -f "${ZSHRC_ZWC}" ] && [ ! "${ZSHRC_PATH}" -nt "${ZSHRC_ZWC}" ]; then
    log_skip "${ZSHRC_ZWC} is current"
    return 0
  fi

  log_info "Compiling ${ZSHRC_PATH}"
  ZSHRC_PATH="${ZSHRC_PATH}" zsh -fc 'zcompile "$ZSHRC_PATH"'
}

log_block "Configure zsh antidote"
if ensure_antidote; then
  log_done "Antidote ready"
else
  log_fail "Unable to configure Antidote"
  log_end_block
  exit 1
fi
log_end_block

log_block "Configure local zsh overrides"
if ensure_local_zshrc; then
  log_done "Local zsh overrides ready"
else
  log_fail "Unable to create ${ZSHRC_LOCAL}"
  log_end_block
  exit 1
fi
log_end_block

log_block "Bundle zsh plugins"
if [ -f "${PLUGINS_TXT}" ]; then
  if bundle_antidote_plugins; then
    log_done "Plugins bundled"
  else
    log_fail "Failed to bundle Antidote plugins"
    log_end_block
    exit 1
  fi
else
  log_skip "${PLUGINS_TXT} not found"
  log_end_block
  exit 0
fi
log_end_block

log_block "Compile zsh configuration"
if compile_zshrc; then
  log_done "zsh configuration compiled"
else
  log_warn "Failed to compile zsh configuration"
fi
log_end_block
