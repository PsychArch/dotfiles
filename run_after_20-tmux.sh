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

plugins_dir="${HOME}/.config/tmux/plugins"
tpm_dir="${plugins_dir}/tpm"

ensure_tpm() {
  mkdir -p "${plugins_dir}"

  if [ -d "${tpm_dir}/.git" ]; then
    log_info "Updating TPM in ${tpm_dir}"
    git -C "${tpm_dir}" pull --ff-only --quiet
  elif [ -e "${tpm_dir}" ]; then
    log_info "${tpm_dir} exists but is not a git repo"
    return 1
  else
    log_info "Cloning TPM into ${tpm_dir}"
    git clone --depth 1 --quiet https://github.com/tmux-plugins/tpm "${tpm_dir}"
  fi
}

install_tmux_plugins() {
  log_info "Running ${tpm_dir}/bin/install_plugins"
  "${tpm_dir}/bin/install_plugins"
}

log_block "Configure tmux plugin manager"
if ensure_tpm; then
  log_done "TPM ready"
else
  log_fail "Unable to configure TPM"
  log_end_block
  exit 1
fi
log_end_block

log_block "Install tmux plugins"
if [ -x "${tpm_dir}/bin/install_plugins" ]; then
  if install_tmux_plugins; then
    log_done "Plugins installed"
  else
    log_warn "Failed to install tmux plugins; rerun inside tmux if needed"
  fi
else
  log_skip "TPM install script not found"
fi
log_end_block
