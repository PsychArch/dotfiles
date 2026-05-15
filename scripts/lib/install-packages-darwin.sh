#!/usr/bin/env bash
#
# install-packages-darwin.sh
#
# macOS package installation library
# This file is sourced by run_onchange_before_install-packages.sh.tmpl

install_packages_darwin() {
    log_block "Installing macOS packages with Homebrew"

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        log_fail "Homebrew not found"
        log_info "Please install Homebrew first:"
        log_info "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        log_end_block
        return 1
    fi

    # Update Homebrew
    log_block "Updating Homebrew"
        log_debug "Running: brew update"
        if brew update >/dev/null 2>&1; then
            log_done "Homebrew updated"
        else
            log_warn "Homebrew update had issues but continuing"
        fi
    log_end_block

    # Install packages via brew bundle
    if [ ${#DARWIN_BREWS[@]} -gt 0 ]; then
        log_block "Installing brew packages"
            log_info "Installing ${#DARWIN_BREWS[@]} packages"
            for package in "${DARWIN_BREWS[@]}"; do
                log_info "Installing $package"
                if echo "brew \"$package\"" | brew bundle --file=/dev/stdin; then
                    log_done "$package installed"
                else
                    log_warn "Failed to install $package"
                fi
            done
        log_end_block
    fi

    # Install optional packages (non-fatal if missing)
    if [ ${#DARWIN_OPTIONAL[@]} -gt 0 ]; then
        log_block "Installing optional packages"
            log_info "Installing ${#DARWIN_OPTIONAL[@]} optional packages"
            for package in "${DARWIN_OPTIONAL[@]}"; do
                log_info "Installing $package"
                if echo "brew \"$package\"" | brew bundle --file=/dev/stdin; then
                    log_done "$package installed"
                else
                    log_warn "Failed to install optional $package (non-critical)"
                fi
            done
        log_end_block
    fi

    log_end_block  # End "Installing macOS packages with Homebrew"
    log_done "macOS package installation complete"
}
