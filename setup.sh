#!/bin/bash

set -eu

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo -e "${BOLD}ZSH Environment — Setup${NC}"
echo "This will install dependencies, create symlinks, and validate the setup."

# ---------------------------------------------------------------------------
# Step 1: bootstrap dependencies
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}Step 1/3 — Installing dependencies${NC}"
bash "$REPO_DIR/bootstrap.sh"

# ---------------------------------------------------------------------------
# Step 2: create symlinks
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}Step 2/3 — Creating symlinks${NC}"
bash "$REPO_DIR/install.sh"

# ---------------------------------------------------------------------------
# Step 3: validate
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}Step 3/3 — Validating installation${NC}"
bash "$REPO_DIR/check.sh"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}Setup complete.${NC}"
echo ""

if [[ ! -f "$REPO_DIR/private/work.zsh" ]]; then
    echo -e "${YELLOW}Reminder:${NC} create private/work.zsh with your work-specific configs:"
    echo "  touch $REPO_DIR/private/work.zsh"
    echo ""
fi

echo "Open a new terminal to apply all changes."
