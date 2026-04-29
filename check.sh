#!/bin/bash

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
ERRORS=0

case "$OSTYPE" in
  darwin*|linux-gnu*) ;;
  *) echo "Error: unsupported OS '$OSTYPE'. Only macOS and Linux are supported."; exit 1 ;;
esac

pass() { echo "  [ok] $1"; }
fail() { echo "  [FAIL] $1 -- $2"; ERRORS=$((ERRORS + 1)); }

echo "Checking ZSH environment installation..."

check_symlink() {
    local dotfile="$1"
    local expected="$2"
    if [ -L "$dotfile" ]; then
        local actual
        actual="$(realpath "$dotfile" 2>/dev/null || readlink "$dotfile")"
        if [ "$actual" = "$expected" ]; then
            pass "$dotfile -> $expected"
        else
            fail "$dotfile symlink" "points to $actual, expected $expected"
        fi
    else
        fail "$dotfile" "not a symlink"
    fi
}

echo ""
echo "-> Symlinks"
check_symlink "$HOME/.zshrc"    "$REPO_DIR/zshrc"
check_symlink "$HOME/.zprofile" "$REPO_DIR/zprofile"
check_symlink "$HOME/.p10k.zsh" "$REPO_DIR/p10k.zsh"

echo ""
echo "-> Private directory"
if [ -d "$REPO_DIR/private" ]; then
    pass "private/ exists"
else
    fail "private/" "directory not found"
fi

if [ -f "$REPO_DIR/private/.gitkeep" ]; then
    pass "private/.gitkeep exists"
else
    fail "private/.gitkeep" "not found"
fi

if [ -f "$REPO_DIR/private/work.zsh" ]; then
    pass "private/work.zsh exists"
else
    fail "private/work.zsh" "not found -- create it with your work-specific configs"
fi

echo ""
echo "-> Git safety"
tracked=$(git -C "$REPO_DIR" ls-files private/ 2>/dev/null | grep -v '\.gitkeep' || true)
if [ -z "$tracked" ]; then
    pass "no private/ files tracked by git"
else
    fail "git tracking" "private/ files tracked: $tracked"
fi

echo ""
echo "-> Syntax check"
for file in zshrc zprofile; do
    if zsh -n "$REPO_DIR/$file" 2>/dev/null; then
        pass "$file syntax valid"
    else
        fail "$file syntax" "zsh reported errors"
    fi
done

echo ""
if [ "$ERRORS" -eq 0 ]; then
    echo "All checks passed."
else
    echo "$ERRORS check(s) failed."
    exit 1
fi
