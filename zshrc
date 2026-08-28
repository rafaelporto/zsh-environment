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
plugins=(git web-search)
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

# Edicao de linha por palavra.
#
# Vem depois do oh-my-zsh e do p10k de proposito: ambos mexem em bindkey durante
# o carregamento, e o ultimo a falar ganha.
#
# As sequencias sao o que o kitty envia para Alt+seta / Alt+Backspace, iguais em
# macOS e Linux — por isso o bloco nao tem guarda de OSTYPE. A diferenca esta em
# como o Alt chega: no Linux ele ja chega como Alt, e no macOS depende de
# `macos_option_as_alt yes` no kitty.conf (sem isso o Option gera caractere
# Unicode e nada disso e acionado).
bindkey '^[[1;3D' backward-word       # Alt/Option+Esquerda: uma palavra atras
bindkey '^[[1;3C' forward-word        # Alt/Option+Direita:  uma palavra a frente
bindkey '^[^?'    backward-kill-word  # Alt/Option+Backspace: apaga palavra atras
bindkey '^[d'     kill-word           # Alt/Option+D: apaga palavra a frente

# Por padrao o zsh trata / - _ . = & como parte da palavra, o que faz um
# "pular palavra" engolir um caminho inteiro. Vazio deixa o comportamento
# parecido com o do nvim.
WORDCHARS=''

# .NET
# DOTNET_ROOT tem de apontar para uma raiz que realmente contenha um runtime, e a
# checagem antiga (-d "$HOME/.dotnet") nao garantia isso: ~/.dotnet e tambem o
# diretorio de tools de usuario, criado por `dotnet tool install --global` mesmo
# quando nenhum SDK vive ali. Com DOTNET_ROOT apontado para uma pasta sem runtime,
# todo apphost self-contained falha com "You must install .NET to run this
# application" — foi assim que o roslyn-language-server morreu com exit 131.
# Por isso procuramos por shared/Microsoft.NETCore.App, e a raiz do sistema vem
# antes da do usuario.
for _dotnet in /usr/local/share/dotnet /usr/share/dotnet /usr/lib/dotnet "$HOME/.dotnet"; do
  if [[ -d "$_dotnet/shared/Microsoft.NETCore.App" ]]; then
    export DOTNET_ROOT="$_dotnet"
    [[ ":$PATH:" == *":$_dotnet:"* ]] || export PATH="$PATH:$_dotnet"
    break
  fi
done
unset _dotnet

# Tools globais vao para ~/.dotnet/tools independente de onde o SDK esta instalado.
if [[ -d "$HOME/.dotnet/tools" && ":$PATH:" != *":$HOME/.dotnet/tools:"* ]]; then
  export PATH="$PATH:$HOME/.dotnet/tools"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

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
