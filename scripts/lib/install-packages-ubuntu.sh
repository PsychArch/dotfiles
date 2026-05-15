#!/usr/bin/env bash
#
# install-packages-ubuntu.sh
#
# Ubuntu/Debian package installation library
# This file is sourced by run_onchange_before_install-packages.sh.tmpl

# Detect Ubuntu/Debian version
detect_ubuntu_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO_ID="$ID"
        DISTRO_VERSION_ID="${VERSION_ID:-0}"
        # Extract major version number (e.g., "24.04" -> "24")
        DISTRO_VERSION_MAJOR="${DISTRO_VERSION_ID%%.*}"
        log_info "Detected $DISTRO_ID version: $DISTRO_VERSION_ID (major: $DISTRO_VERSION_MAJOR)"
    else
        DISTRO_ID="unknown"
        DISTRO_VERSION_MAJOR=0
        log_warn "Could not detect distribution version"
    fi
}

install_packages_ubuntu() {
    log_block "Installing Ubuntu/Debian packages"

    # Detect version first
    detect_ubuntu_version

    # Update package database
    log_block "Updating package database"
        log_debug "Running: apt update"
        if sudo apt update >/dev/null 2>&1; then
            log_done "Package lists updated"
        else
            log_fail "Failed to update package lists"
        fi
    log_end_block

    # Check if we should install modern CLI tools via apt
    # Modern CLI tools are only available in Ubuntu 24.04+ universe repository
    local install_modern_via_apt=false

    if [ "$DISTRO_ID" = "ubuntu" ] && [ "$DISTRO_VERSION_MAJOR" -ge 24 ]; then
        install_modern_via_apt=true
        log_info "Ubuntu $DISTRO_VERSION_ID detected (>= 24.04)"
        log_info "Modern CLI tools available in apt, will install all packages via apt"
    elif [ "$DISTRO_ID" = "ubuntu" ] && [ "$DISTRO_VERSION_MAJOR" -lt 24 ] && [ "$DISTRO_VERSION_MAJOR" -gt 0 ]; then
        log_warn "Ubuntu $DISTRO_VERSION_ID detected (< 24.04)"
        log_warn "Modern CLI tools NOT available in apt for this version"
        log_warn "Modern CLI tools will be skipped on this Ubuntu version"
    elif [ "$DISTRO_ID" = "debian" ]; then
        # For Debian, we could add version checks later, but for now install all
        install_modern_via_apt=true
        log_info "Debian detected, installing packages via apt"
    else
        log_warn "Unknown distribution, attempting to install all packages"
        install_modern_via_apt=true
    fi

    # Define modern CLI tools that are only available in Ubuntu 24.04+
    local MODERN_TOOLS=(ripgrep fd-find bat eza zoxide)

    # Separate packages into base and modern
    local UBUNTU_APT_BASE=()
    local UBUNTU_APT_MODERN=()

    for package in "${UBUNTU_APT[@]}"; do
        if [[ " ${MODERN_TOOLS[*]} " == *" ${package} "* ]]; then
            UBUNTU_APT_MODERN+=("$package")
        else
            UBUNTU_APT_BASE+=("$package")
        fi
    done

    # Install base packages (available in all versions)
    if [ ${#UBUNTU_APT_BASE[@]} -gt 0 ]; then
        log_block "Installing base apt packages"
            log_info "Installing ${#UBUNTU_APT_BASE[@]} packages"
            if sudo apt install -y "${UBUNTU_APT_BASE[@]}"; then
                log_done "Base packages installed"
            else
                log_warn "Some packages could not be installed (may already be installed)"
            fi
        log_end_block
    fi

    # Install modern CLI tools only if version supports it
    if [ "$install_modern_via_apt" = true ] && [ ${#UBUNTU_APT_MODERN[@]} -gt 0 ]; then
        log_block "Installing modern CLI tools via apt"
            log_info "Installing ${#UBUNTU_APT_MODERN[@]} packages"
            if sudo apt install -y "${UBUNTU_APT_MODERN[@]}"; then
                log_done "Modern CLI tools installed"
            else
                log_warn "Some packages could not be installed (may already be installed)"
            fi
        log_end_block
    elif [ ${#UBUNTU_APT_MODERN[@]} -gt 0 ]; then
        log_warn "Skipping modern CLI tools via apt (not available in this Ubuntu version)"
        log_warn "Skipped tools: ${UBUNTU_APT_MODERN[*]}"
    fi

    # Install cargo packages if cargo is available
    if [ ${#UBUNTU_CARGO[@]} -gt 0 ]; then
        if command -v cargo &> /dev/null; then
            log_block "Installing cargo packages"
                log_info "Installing ${#UBUNTU_CARGO[@]} packages"
                for package in "${UBUNTU_CARGO[@]}"; do
                    log_info "Installing $package"
                    if cargo install "$package"; then
                        log_done "$package installed"
                    else
                        log_warn "Failed to install $package via cargo"
                    fi
                done
            log_end_block
        else
            log_warn "Cargo not found. Skipping cargo packages: ${UBUNTU_CARGO[*]}"
            log_info "Install Rust to enable: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
        fi
    fi

    # Install manual packages
    if [ ${#UBUNTU_MANUAL_NAMES[@]} -gt 0 ]; then
        log_block "Installing packages via alternative methods"
            for i in "${!UBUNTU_MANUAL_NAMES[@]}"; do
                local name="${UBUNTU_MANUAL_NAMES[$i]}"
                local method="${UBUNTU_MANUAL_METHODS[$i]}"
                local command="${UBUNTU_MANUAL_COMMANDS[$i]}"

                if ! command -v "$name" &> /dev/null; then
                    log_info "Installing $name via $method"
                    # Execute in subshell with relaxed error handling for manual commands
                    # Disable nounset (-u) temporarily to allow variable use in eval'd commands
                    if (set +u; eval "$command"); then
                        log_done "$name installed"
                    else
                        log_warn "Failed to install $name"
                    fi
                else
                    log_skip "$name already installed"
                fi
            done
        log_end_block
    fi

    if [ "$install_modern_via_apt" = false ]; then
        log_warn "Some packages were skipped due to Ubuntu version < 24.04"
    fi

    log_end_block  # End "Installing Ubuntu/Debian packages"
    log_done "Ubuntu/Debian package installation complete"
    return 0
}
