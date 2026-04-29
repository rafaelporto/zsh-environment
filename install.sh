#!/bin/bash

set -eu

case "$OSTYPE" in
  darwin*|linux-gnu*) ;;
  *) echo "Error: unsupported OS '$OSTYPE'. Only macOS and Linux are supported."; exit 1 ;;
esac

for cmd in zsh ln readlink cp rm mkdir; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "Error: required command '$cmd' not found."; exit 1; }
done

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing ZSH environment from $REPO_DIR..."

backup_and_remove() {
    local target="$1"
    [ -e "$target" ] || [ -L "$target" ] || return 0

    if [ -L "$target" ]; then
        local link_target
        link_target="$(readlink "$target")"
        if [[ "$link_target" == "$REPO_DIR"* ]]; then
            rm -f "$target"
            return 0
        fi
    fi

    cp -L "$target" "${target}.bak" 2>/dev/null && echo "  Backed up: $target -> ${target}.bak"
    rm -f "$target"
}

symlink() {
    local source="$1"
    local target="$2"
    ln -sn "$source" "$target"
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
echo "-> Ensuring private/ directory exists..."
mkdir -p "$REPO_DIR/private"
touch "$REPO_DIR/private/.gitkeep"

if [ ! -f "$REPO_DIR/private/work.zsh" ]; then
    echo ""
    echo "  WARNING: $REPO_DIR/private/work.zsh not found."
    echo "  Create it with your work-specific configs before opening a new terminal."
fi

echo ""
echo "Done. Open a new terminal to apply changes."
echo "Run ./check.sh to validate the installation."
