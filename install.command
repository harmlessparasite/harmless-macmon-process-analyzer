#!/bin/bash
#
# macmon installer
# Double-click this file (or run it in Terminal) to install macmon
# so you can launch it from anywhere just by typing:  macmon
#
# Author: Wasim Osman
# Source: https://github.com/harmlessparasite/macmon-process-analyzer
#

APP_NAME="macmon"            # command you type in Terminal
APP_TITLE="macmon"           # display name of the app
APP_VERSION="1.01"           # release version
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_FILE="$SRC_DIR/$APP_NAME"
INSTALL_DIR="$HOME/Applications/macmon"
BIN_DIR="/usr/local/bin"
BIN_LINK="$BIN_DIR/$APP_NAME"

echo "=============================================="
echo "  Installing $APP_TITLE v$APP_VERSION"
echo "=============================================="

# sanity checks
if [ ! -f "$SRC_FILE" ]; then
    echo "ERROR: $APP_NAME not found next to this installer."
    exit 1
fi

# ---------------------------------------------------------------------------
# Dependency handling
#
# macmon is a single Python 3 script and uses ONLY the Python standard
# library (curses, subprocess, os, sys, plistlib, signal, json, re, pathlib,
# collections, datetime). There are NO third-party packages to install.
# The one and only dependency is a working `python3`. Make sure it exists,
# installing it automatically when possible.
# ---------------------------------------------------------------------------
ensure_python3() {
    if command -v python3 >/dev/null 2>&1; then
        echo "  • Dependency OK: $(command -v python3) ($(python3 --version 2>&1))"
        return 0
    fi

    echo "  • python3 not found — attempting to install it..."

    # Preferred: Homebrew
    if command -v brew >/dev/null 2>&1; then
        echo "      using Homebrew..."
        if brew install python3; then
            command -v python3 >/dev/null 2>&1 && return 0
        fi
    fi

    # Fallback: Apple's Command Line Tools (provides python3)
    if command -v xcode-select >/dev/null 2>&1; then
        echo "      using xcode-select --install (a system dialog will appear)..."
        xcode-select --install
        # The dialog installs in the background; re-check shortly.
        for i in 1 2 3 4 5 6; do
            sleep 5
            command -v python3 >/dev/null 2>&1 && return 0
        done
    fi

    # Last resort: open the official Python installer
    echo "      could not install automatically."
    echo "      Opening https://www.python.org/downloads/macos/ ..."
    open "https://www.python.org/downloads/macos/"
    return 1
}

if ! ensure_python3; then
    echo "ERROR: python3 is required but could not be installed automatically."
    echo "       Please install Python 3, then re-run this installer."
    exit 1
fi

# 1. make sure the Projects folder + macmon folder exist, then copy the app there
mkdir -p "$INSTALL_DIR"
cp "$SRC_FILE" "$INSTALL_DIR/$APP_NAME"
chmod +x "$INSTALL_DIR/$APP_NAME"
echo "  • Placed app in: $INSTALL_DIR"

# 2. make a symlink so 'macmon' works from any Terminal.
#    Prefer /usr/local/bin; if it isn't writable (no admin rights), fall
#    back to the user-owned ~/bin and make sure that is on the PATH.
if mkdir -p "$BIN_DIR" 2>/dev/null && [ -w "$BIN_DIR" ]; then
    BIN_LINK="$BIN_DIR/$APP_NAME"
else
    BIN_DIR="$HOME/bin"
    BIN_LINK="$BIN_DIR/$APP_NAME"
    echo "  • /usr/local/bin not writable — using $BIN_DIR instead"
fi

mkdir -p "$BIN_DIR"
if [ -L "$BIN_LINK" ] || [ -e "$BIN_LINK" ]; then
    rm -f "$BIN_LINK"
fi
ln -s "$INSTALL_DIR/$APP_NAME" "$BIN_LINK"
echo "  • Linked $BIN_LINK -> $INSTALL_DIR/$APP_NAME"

# 3. make sure the chosen bin dir is on the PATH
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
        echo "  • Adding $BIN_DIR to your PATH (~/.zshrc)"
        echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$HOME/.zshrc"
        ;;
esac

echo "=============================================="
echo "  Done! Open a new Terminal window and type:"
echo "      $APP_NAME"
echo "  to launch the app."
echo "=============================================="

# keep the Terminal window open so the user can read the message
exec $SHELL
