# Homebrew
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  FPATH="/home/linuxbrew/.linuxbrew/share/zsh/site-functions:${FPATH}"
fi

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-syntax-highlighting web-search)
source "$ZSH/oh-my-zsh.sh"

# zplug
if [[ "$OSTYPE" == "darwin"* ]]; then
  export ZPLUG_HOME="/opt/homebrew/opt/zplug"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export ZPLUG_HOME="$HOME/.zplug"
fi

if [[ -f "$ZPLUG_HOME/init.zsh" ]]; then
  source "$ZPLUG_HOME/init.zsh"
  zplug "mafredri/zsh-async", from:github
  zplug "zsh-users/zsh-syntax-highlighting"
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo; zplug install
    fi
  fi
  zplug load
fi

# Powerlevel10k
if [[ "$OSTYPE" == "darwin"* ]]; then
  [[ -f /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme ]] && \
    source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  for _p10k in \
    "$HOME/powerlevel10k/powerlevel10k.zsh-theme" \
    "$HOME/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme" \
    "/usr/share/powerlevel10k/powerlevel10k.zsh-theme"; do
    [[ -f "$_p10k" ]] && { source "$_p10k"; break; }
  done
  unset _p10k
fi
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

export EDITOR='nvim'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export NODE_OPTIONS=--openssl-legacy-provider

# 1Password shell completion (macOS)
if [[ "$OSTYPE" == "darwin"* ]] && command -v op &>/dev/null; then
  eval "$(op completion zsh)"; compdef _op op
fi

# Google Cloud SDK
for _gcloud in "$HOME/google-cloud-cli/google-cloud-sdk" "$HOME/google-cloud-sdk"; do
  [[ -f "$_gcloud/path.zsh.inc" ]] && source "$_gcloud/path.zsh.inc"
  [[ -f "$_gcloud/completion.zsh.inc" ]] && source "$_gcloud/completion.zsh.inc"
done
unset _gcloud

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# work-specific config (not tracked by git)
[[ -f ~/.config/zsh-environment/private/work.zsh ]] && source ~/.config/zsh-environment/private/work.zsh
