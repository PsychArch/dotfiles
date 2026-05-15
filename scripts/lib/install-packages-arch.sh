#!/usr/bin/env bash
#
# install-packages-arch.sh
#
# Arch Linux package installation library
# This file is sourced by run_onchange_before_install-packages.sh.tmpl

# Helper function to run commands with sudo only if not root
_run_privileged() {
    if [ "$EUID" -eq 0 ] || [ "$(id -u)" -eq 0 ]; then
        # Already root, run directly
        "$@"
    else
        # Not root, use sudo
        sudo "$@"
    fi
}

install_packages_arch() {
    log_block "Installing Arch Linux packages"

    # Update package database
    log_block "Updating package database"
        log_debug "Running: pacman -Sy --noconfirm"
        if _run_privileged pacman -Sy --noconfirm >/dev/null 2>&1; then
            log_done "Package database synchronized"
        else
            log_fail "Failed to update package database"
        fi
    log_end_block

    # Install official packages
    if [ ${#ARCH_OFFICIAL[@]} -gt 0 ]; then
        log_block "Installing official packages"
            log_info "Installing ${#ARCH_OFFICIAL[@]} packages"
            if _run_privileged pacman -S --needed --noconfirm "${ARCH_OFFICIAL[@]}"; then
                log_done "Official packages installed"
            else
                log_warn "Some packages could not be installed (may already be installed)"
            fi
        log_end_block
    fi

    # Install optional packages (non-fatal if missing)
    if [ ${#ARCH_OPTIONAL[@]} -gt 0 ]; then
        log_block "Installing optional packages"
            log_info "Installing ${#ARCH_OPTIONAL[@]} optional packages"
            if _run_privileged pacman -S --needed --noconfirm "${ARCH_OPTIONAL[@]}"; then
                log_done "Optional packages installed"
            else
                log_warn "Some optional packages could not be installed (non-critical)"
            fi
        log_end_block
    fi

    log_end_block  # End "Installing Arch Linux packages"
    log_done "Arch Linux package installation complete"
}
