#!/bin/bash
#
# macmon uninstaller
# Double-click this file (or run it in Terminal) to completely remove macmon
# from your system.
#
# Author: Wasim Osman
# Source: https://github.com/harmlessparasite/macmon-process-analyzer
#

APP_NAME="macmon"
APP_VERSION="1.01"           # release version
INSTALL_DIR="$HOME/Applications/macmon"
BIN_LINK="/usr/local/bin/$APP_NAME"

echo "=============================================="
echo "  Uninstalling $APP_NAME v$APP_VERSION"
echo "=============================================="

# remove the global launcher
if [ -L "$BIN_LINK" ] || [ -e "$BIN_LINK" ]; then
    rm -f "$BIN_LINK"
    echo "  • Removed launcher: $BIN_LINK"
else
    echo "  • No launcher found at $BIN_LINK (nothing to do)"
fi

# remove the app folder
if [ -d "$INSTALL_DIR" ]; then
    rm -rf "$INSTALL_DIR"
    echo "  • Removed app folder: $INSTALL_DIR"
else
    echo "  • No app folder found at $INSTALL_DIR (nothing to do)"
fi

# clean up leftover session data
SESSION_DIR="$HOME/.local/share/$APP_NAME"
if [ -d "$SESSION_DIR" ]; then
    rm -rf "$SESSION_DIR"
    echo "  • Removed session data: $SESSION_DIR"
fi

echo "=============================================="
echo "  $APP_NAME has been removed from your system."
echo "=============================================="

exec $SHELL
