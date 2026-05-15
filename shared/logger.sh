#!/usr/bin/env bash
#
# logger.sh - Systemd-inspired structured logging for dotfiles
#
# Provides consistent, parseable, debug-friendly logging following
# Linux best practices (systemd journal style)
#
# Features:
# - Structured output with log levels ([INFO], [DONE], [SKIP], [WARN], [FAIL])
# - TTY-aware coloring (auto-degrades for pipes/logs)
# - Hierarchical indentation for task relationships
# - Optional timestamps for debugging
# - Machine-parseable format (easy to grep/awk)
# - Single-line messages (grep-friendly)
#
# Environment Variables:
#   LOGGER_COLOR=auto|always|never  - Color output control (default: auto)
#   LOGGER_TIMESTAMP=0|1            - Enable timestamps (default: 0)
#   LOGGER_DEBUG=0|1                - Enable debug messages (default: 0)
#
# Usage:
#   source logger.sh
#   log_info "Starting installation"
#   log_block "Installing packages"
#       log_info "Installing neovim"
#       log_done "Neovim installed"
#   log_end_block
#   log_done "Installation complete"
#
# Output (TTY with colors):
#   [INFO] Starting installation
#   [INFO] Installing packages
#   [INFO]   Installing neovim
#   [DONE]   Neovim installed
#   [DONE] Installation complete
#
# Guard against double sourcing
if [ -n "${LOGGER_LIB_SOURCED:-}" ]; then
    return 0
fi
LOGGER_LIB_SOURCED=1

# =============================================================================
# CONFIGURATION
# =============================================================================

# Detect TTY for color support
_logger_should_color() {
    case "${LOGGER_COLOR:-auto}" in
        always) return 0 ;;
        never)  return 1 ;;
        auto)
            if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
                local colors
                colors=$(tput colors 2>/dev/null || echo 0)
                [ "${colors}" -ge 8 ]
            else
                return 1
            fi
            ;;
    esac
}

# Initialize colors
if _logger_should_color; then
    _LOG_COLOR_INFO=$(tput setaf 6)    # Cyan
    _LOG_COLOR_DONE=$(tput setaf 2)    # Green
    _LOG_COLOR_SKIP=$(tput setaf 6)    # Cyan
    _LOG_COLOR_WARN=$(tput setaf 3)    # Yellow
    _LOG_COLOR_FAIL=$(tput setaf 1)    # Red
    _LOG_COLOR_DEBUG=$(tput setaf 8)   # Gray (if supported)
    _LOG_COLOR_RESET=$(tput sgr0)
else
    _LOG_COLOR_INFO=''
    _LOG_COLOR_DONE=''
    _LOG_COLOR_SKIP=''
    _LOG_COLOR_WARN=''
    _LOG_COLOR_FAIL=''
    _LOG_COLOR_DEBUG=''
    _LOG_COLOR_RESET=''
fi

# Indentation tracking
_LOG_INDENT_LEVEL=0
_LOG_INDENT_STRING="  "

# =============================================================================
# CORE LOGGING FUNCTIONS
# =============================================================================

_logger_format() {
    local level="$1"
    local color="$2"
    shift 2
    local message="$*"

    # Build indent string
    local indent=""
    for ((i=0; i<_LOG_INDENT_LEVEL; i++)); do
        indent+="${_LOG_INDENT_STRING}"
    done

    # Build timestamp if enabled
    local timestamp=""
    if [ "${LOGGER_TIMESTAMP:-0}" = "1" ]; then
        timestamp="$(date '+%Y-%m-%d %H:%M:%S') "
    fi

    # Output formatted message
    if [ -n "$color" ]; then
        printf '%s%s[%s]%s %s%s\n' \
            "$timestamp" \
            "$color" \
            "$level" \
            "$_LOG_COLOR_RESET" \
            "$indent" \
            "$message"
    else
        printf '%s[%s] %s%s\n' \
            "$timestamp" \
            "$level" \
            "$indent" \
            "$message"
    fi
}

log_info() {
    _logger_format "INFO" "$_LOG_COLOR_INFO" "$@"
}

log_done() {
    _logger_format "DONE" "$_LOG_COLOR_DONE" "$@"
}

log_skip() {
    _logger_format "SKIP" "$_LOG_COLOR_SKIP" "$@"
}

log_warn() {
    _logger_format "WARN" "$_LOG_COLOR_WARN" "$@"
}

log_fail() {
    _logger_format "FAIL" "$_LOG_COLOR_FAIL" "$@"
    return 1
}

log_debug() {
    if [ "${LOGGER_DEBUG:-0}" = "1" ]; then
        _logger_format "DEBUG" "$_LOG_COLOR_DEBUG" "$@"
    fi
}

# =============================================================================
# INDENTATION CONTROL
# =============================================================================

log_indent() {
    _LOG_INDENT_LEVEL=$((_LOG_INDENT_LEVEL + 1))
}

log_dedent() {
    if [ "$_LOG_INDENT_LEVEL" -gt 0 ]; then
        _LOG_INDENT_LEVEL=$((_LOG_INDENT_LEVEL - 1))
    fi
}

# Start a new indented block with a message
log_block() {
    log_info "$@"
    log_indent
}

# End the current indented block
log_end_block() {
    log_dedent
}

# Export all functions for subshells
export -f _logger_format
export -f log_info log_done log_skip log_warn log_fail log_debug
export -f log_indent log_dedent log_block log_end_block
