#!/bin/bash

set -eu

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

header() { echo -e "\n${BOLD}==> $1${NC}"; }
ok()     { echo -e "    ${GREEN}[ok]${NC} $1"; }
skip()   { echo -e "    ${YELLOW}[skip]${NC} $1"; }

confirm_and_run() {
    local description="$1"
    local command="$2"

    echo ""
    echo -e "  ${BOLD}$description${NC}"
    echo -e "  ${BLUE}Command:${NC} $command"
    printf "  Install? [y/N]: "
    read -r answer </dev/tty
    case "$answer" in
        [yY]|[yY][eE][sS])
            echo ""
            eval "$command"
            ;;
        *)
            skip "skipped"
            return 1
            ;;
    esac
}

case "$OSTYPE" in
    darwin*)    OS="macos" ;;
    linux-gnu*) OS="linux" ;;
    *) echo "Error: unsupported OS '$OSTYPE'."; exit 1 ;;
esac

echo ""
echo -e "${BOLD}ZSH Environment — Bootstrap${NC}"
echo "Installs required dependencies. You will be asked before each one."

# ---------------------------------------------------------------------------
# 1. Homebrew
# ---------------------------------------------------------------------------
header "1/4  Homebrew"

BREW_BIN=""
for _b in "/opt/homebrew/bin/brew" "/usr/local/bin/brew" "/home/linuxbrew/.linuxbrew/bin/brew"; do
    [[ -x "$_b" ]] && BREW_BIN="$_b" && break
done
unset _b

if [[ -n "$BREW_BIN" ]]; then
    ok "already installed ($("$BREW_BIN" --version | head -1))"
else
    BREW_CMD='/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
    if confirm_and_run "Homebrew — package manager" "$BREW_CMD"; then
        for _b in "/opt/homebrew/bin/brew" "/usr/local/bin/brew" "/home/linuxbrew/.linuxbrew/bin/brew"; do
            [[ -x "$_b" ]] && BREW_BIN="$_b" && break
        done
        unset _b
        [[ -n "$BREW_BIN" ]] && eval "$("$BREW_BIN" shellenv)"
    fi
fi

# ---------------------------------------------------------------------------
# 2. Oh My Zsh
# ---------------------------------------------------------------------------
header "2/4  Oh My Zsh"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "already installed"
else
    OMZ_CMD='sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
    confirm_and_run "Oh My Zsh — ZSH framework with plugins and themes" "$OMZ_CMD" || true
fi

# ---------------------------------------------------------------------------
# 3. zplug
# ---------------------------------------------------------------------------
header "3/4  zplug"

ZPLUG_FOUND=false
[[ -f "/opt/homebrew/opt/zplug/init.zsh" ]] && ZPLUG_FOUND=true
[[ -f "/usr/local/opt/zplug/init.zsh" ]]    && ZPLUG_FOUND=true
[[ -f "$HOME/.zplug/init.zsh" ]]             && ZPLUG_FOUND=true

if $ZPLUG_FOUND; then
    ok "already installed"
else
    if [[ "$OS" == "macos" ]]; then
        ZPLUG_CMD='brew install zplug'
    else
        ZPLUG_CMD='curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh'
    fi
    confirm_and_run "zplug — ZSH plugin manager (installs zsh-syntax-highlighting)" "$ZPLUG_CMD" || true
fi

# ---------------------------------------------------------------------------
# 4. Powerlevel10k
# ---------------------------------------------------------------------------
header "4/4  Powerlevel10k"

P10K_FOUND=false
[[ -f "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" ]]            && P10K_FOUND=true
[[ -f "/usr/local/share/powerlevel10k/powerlevel10k.zsh-theme" ]]               && P10K_FOUND=true
[[ -f "$HOME/powerlevel10k/powerlevel10k.zsh-theme" ]]                          && P10K_FOUND=true
[[ -f "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" ]] && P10K_FOUND=true
[[ -f "/usr/share/powerlevel10k/powerlevel10k.zsh-theme" ]]                     && P10K_FOUND=true

if $P10K_FOUND; then
    ok "already installed"
else
    if [[ "$OS" == "macos" ]]; then
        P10K_CMD='brew install powerlevel10k'
    else
        P10K_CMD='git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k'
    fi
    confirm_and_run "Powerlevel10k — ZSH prompt theme" "$P10K_CMD" || true
fi

echo ""
echo -e "${BOLD}Bootstrap complete.${NC}"
