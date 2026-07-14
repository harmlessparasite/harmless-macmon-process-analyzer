#!/bin/bash
#
# macmon installer
# Double-click this file (or run it in Terminal) to install macmon so you can
# launch it from anywhere just by typing:  macmon
#
# Source: https://github.com/harmlessparasite
#

APP_NAME="macmon"
SRC_DIR="$(cd "$(dirname "$0")" && pwd)"
SRC_FILE="$SRC_DIR/$APP_NAME"
INSTALL_DIR="$HOME/Documents/Projects/$APP_NAME"
BIN_DIR="/usr/local/bin"
BIN_LINK="$BIN_DIR/$APP_NAME"

echo "=============================================="
echo "  Installing $APP_NAME"
echo "=============================================="

# sanity checks
if [ ! -f "$SRC_FILE" ]; then
    echo "ERROR: $APP_NAME not found next to this installer."
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "ERROR: python3 is required but was not found on this system."
    echo "       Install Python 3 first (https://www.python.org)."
    exit 1
fi

# 1. make sure the Projects folder + macmon folder exist, then copy the app there
mkdir -p "$INSTALL_DIR"
cp "$SRC_FILE" "$INSTALL_DIR/$APP_NAME"
chmod +x "$INSTALL_DIR/$APP_NAME"
echo "  • Placed app in: $INSTALL_DIR"

# 2. make a symlink in /usr/local/bin so 'macmon' works from any Terminal
mkdir -p "$BIN_DIR"
if [ -L "$BIN_LINK" ] || [ -e "$BIN_LINK" ]; then
    rm -f "$BIN_LINK"
fi
ln -s "$INSTALL_DIR/$APP_NAME" "$BIN_LINK"
echo "  • Linked $BIN_LINK -> $INSTALL_DIR/$APP_NAME"

# 3. confirm /usr/local/bin is on PATH
case ":$PATH:" in
    *":/usr/local/bin:"*) ;;
    *)
        echo "  • NOTE: /usr/local/bin is not on your PATH."
        echo "    Add this line to ~/.zshrc (or ~/.bash_profile):"
        echo "        export PATH=\"/usr/local/bin:\$PATH\""
        ;;
esac

echo "=============================================="
echo "  Done! Open a new Terminal window and type:"
echo "      $APP_NAME"
echo "  to launch the app."
echo "=============================================="

# keep the Terminal window open so the user can read the message
exec $SHELL
