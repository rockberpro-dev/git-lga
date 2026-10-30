#!/bin/bash

set -e

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/git-lga"

GITCONFIG_URL="https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.gitconfig"
INSTALL_PATH="$CONFIG_DIR/git-lga.gitconfig"

HELP_URL="https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga-help.sh"
HELP_PATH="$CONFIG_DIR/git-lga-help.sh"

BASHRC_URL="https://raw.githubusercontent.com/rockberpro-dev/git-lga/main/git-lga.bashrc"
BASHRC_PATH="$CONFIG_DIR/git-lga.bashrc"

# Remove files from older versions, which installed directly into ~
rm -f "$HOME/.git-lga.gitconfig" "$HOME/.git-lga-help.sh" "$HOME/.git-lga.bashrc"
git config --global --unset-all include.path '\.git-lga\.gitconfig$' || true
if [ -f "$HOME/.bashrc" ] && grep -qF '/.git-lga.bashrc' "$HOME/.bashrc"; then
    grep -vF '/.git-lga.bashrc' "$HOME/.bashrc" > "$HOME/.bashrc.git-lga.tmp" || true
    cat "$HOME/.bashrc.git-lga.tmp" > "$HOME/.bashrc"
    rm -f "$HOME/.bashrc.git-lga.tmp"
fi

mkdir -p "$CONFIG_DIR"

curl -sL "$GITCONFIG_URL" -o "$INSTALL_PATH"

if ! git config --global --get-all include.path | grep -qF "$INSTALL_PATH"; then
    git config --global --add include.path "$INSTALL_PATH"
fi

curl -sL "$HELP_URL" -o "$HELP_PATH"
chmod +x "$HELP_PATH"

curl -sL "$BASHRC_URL" -o "$BASHRC_PATH"

if ! grep -qF "$BASHRC_PATH" "$HOME/.bashrc"; then
    echo "source \"$BASHRC_PATH\"" >> "$HOME/.bashrc"
fi

echo "git-lga installed: $INSTALL_PATH"
echo "git-lga help installed: $HELP_PATH"
echo "git-lga bashrc installed: $BASHRC_PATH"
