#!/bin/bash

set -eu

BOLD='\033[1m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

TOTAL=11

header() { echo -e "\n${BOLD}==> $1${NC}"; }
ok()     { echo -e "    ${GREEN}[ok]${NC} $1"; }
skip()   { echo -e "    ${YELLOW}[skip]${NC} $1"; }
warn()   { echo -e "    ${YELLOW}[warn]${NC} $1"; }
error()  { echo -e "    ${RED}[error]${NC} $1"; }

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
header "1/$TOTAL  Homebrew"

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
# 2. Core tools (git, curl)
# ---------------------------------------------------------------------------
header "2/$TOTAL  Core tools"

for tool in git curl; do
    if command -v "$tool" &>/dev/null; then
        ok "$tool found"
    else
        error "$tool not found — install it manually before proceeding"
    fi
done

# ---------------------------------------------------------------------------
# 3. Oh My Zsh
# ---------------------------------------------------------------------------
header "3/$TOTAL  Oh My Zsh"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    ok "already installed"
else
    OMZ_CMD='sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
    confirm_and_run "Oh My Zsh — ZSH framework with plugins and themes" "$OMZ_CMD" || true
fi

# ---------------------------------------------------------------------------
# 4. zplug
# ---------------------------------------------------------------------------
header "4/$TOTAL  zplug"

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
# 5. Powerlevel10k
# ---------------------------------------------------------------------------
header "5/$TOTAL  Powerlevel10k"

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

# ---------------------------------------------------------------------------
# 6. jq
# ---------------------------------------------------------------------------
header "6/$TOTAL  jq"

if command -v jq &>/dev/null; then
    ok "already installed ($(jq --version))"
else
    if [[ "$OS" == "macos" ]]; then
        JQ_CMD='brew install jq'
    else
        JQ_CMD='sudo apt-get install -y jq 2>/dev/null || sudo dnf install -y jq'
    fi
    confirm_and_run "jq — JSON processor (used by flattenJson, jwt-decode, catFileWithColors)" "$JQ_CMD" || true
fi

# ---------------------------------------------------------------------------
# 7. Neovim
# ---------------------------------------------------------------------------
header "7/$TOTAL  Neovim"

if command -v nvim &>/dev/null; then
    ok "already installed ($(nvim --version | head -1))"
else
    if [[ "$OS" == "macos" ]]; then
        NVIM_CMD='brew install neovim'
    else
        NVIM_CMD='sudo apt-get install -y neovim 2>/dev/null || sudo dnf install -y neovim'
    fi
    confirm_and_run "Neovim — text editor (default EDITOR and used by aliases)" "$NVIM_CMD" || true
fi

# ---------------------------------------------------------------------------
# 8. lazygit
# ---------------------------------------------------------------------------
header "8/$TOTAL  lazygit"

if command -v lazygit &>/dev/null; then
    ok "already installed ($(lazygit --version | head -1))"
else
    if [[ "$OS" == "macos" ]]; then
        LG_CMD='brew install lazygit'
    else
        LG_CMD='LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po "\"tag_name\": \"v\K[^\"]*") && curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && tar xf /tmp/lazygit.tar.gz -C /tmp lazygit && sudo install /tmp/lazygit /usr/local/bin'
    fi
    confirm_and_run "lazygit — terminal UI for git (lg alias)" "$LG_CMD" || true
fi

# ---------------------------------------------------------------------------
# 9. tmux
# ---------------------------------------------------------------------------
header "9/$TOTAL  tmux"

if command -v tmux &>/dev/null; then
    ok "already installed ($(tmux -V))"
else
    if [[ "$OS" == "macos" ]]; then
        TMUX_CMD='brew install tmux'
    else
        TMUX_CMD='sudo apt-get install -y tmux 2>/dev/null || sudo dnf install -y tmux'
    fi
    confirm_and_run "tmux — terminal multiplexer (tx, txa, txn and other aliases)" "$TMUX_CMD" || true
fi

# ---------------------------------------------------------------------------
# 10. NVM (Node Version Manager)
# ---------------------------------------------------------------------------
header "10/$TOTAL  NVM"

NVM_CMD='curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
    ok "already installed"
elif command -v npm &>/dev/null; then
    warn "npm found but NVM is not installed."
    warn "NVM is recommended for managing multiple Node versions."
    confirm_and_run "NVM — Node version manager (recommended since npm is already present)" "$NVM_CMD" || true
else
    confirm_and_run "NVM — Node version manager (enables npm aliases: n, nr, ni)" "$NVM_CMD" || true
fi

# ---------------------------------------------------------------------------
# 11. SDKMAN (JVM tools manager)
# ---------------------------------------------------------------------------
header "11/$TOTAL  SDKMAN"

SDKMAN_CMD='curl -s "https://get.sdkman.io" | bash'

if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    ok "already installed"
elif command -v java &>/dev/null; then
    warn "Java found but SDKMAN is not installed."
    warn "SDKMAN is recommended for managing Java and other JVM tool versions."
    confirm_and_run "SDKMAN — JVM tools version manager (recommended since Java is installed)" "$SDKMAN_CMD" || true
else
    skip "Java not found — install SDKMAN later if you need JVM tools (see README)"
fi

echo ""
echo -e "${BOLD}Bootstrap complete.${NC}"
