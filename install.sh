#!/bin/bash

set -e

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing ZSH environment from $REPO_DIR..."

backup_and_remove() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        cp -L "$target" "${target}.bak" 2>/dev/null && echo "  Backed up: $target -> ${target}.bak"
        rm -f "$target"
    fi
}

symlink() {
    local source="$1"
    local target="$2"
    ln -s "$source" "$target"
    echo "  Linked: $target -> $source"
}

echo ""
echo "-> Backing up and replacing dotfiles..."
backup_and_remove ~/.zshrc
backup_and_remove ~/.zprofile
backup_and_remove ~/.p10k.zsh

echo ""
echo "-> Creating symlinks..."
symlink "$REPO_DIR/zshrc"    ~/.zshrc
symlink "$REPO_DIR/zprofile" ~/.zprofile
symlink "$REPO_DIR/p10k.zsh" ~/.p10k.zsh

echo ""
echo "-> Removing ~/.nu-zprofile..."
if [ -f "$HOME/.nu-zprofile" ]; then
    rm -f "$HOME/.nu-zprofile" && echo "  Removed: ~/.nu-zprofile"
else
    echo "  ~/.nu-zprofile not found, skipping."
fi

echo ""
echo "-> Ensuring private/ directory exists..."
mkdir -p "$REPO_DIR/private"

if [ ! -f "$REPO_DIR/private/work.zsh" ]; then
    echo ""
    echo "  WARNING: $REPO_DIR/private/work.zsh not found."
    echo "  Create it with your work-specific configs before opening a new terminal."
fi

echo ""
echo "Done. Open a new terminal to apply changes."
echo "Run ./check.sh to validate the installation."
