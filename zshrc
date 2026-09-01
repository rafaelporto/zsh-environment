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

# nvim
alias nv='nvim'
alias nv.='nvim .'
alias v='vim'
alias zprofile='nvim ~/.config/zsh-environment/zprofile -c "cd ~/.config/zsh-environment"'
alias zshrc='nvim ~/.config/zsh-environment/zshrc -c "cd ~/.config/zsh-environment"'
alias vConfig='nvim ~/.vimrc'
alias nvconfig='nvim ~/.config/nvim/ -c "cd ~/.config/nvim/"'
alias cdNvimConfig='cd ~/.config/nvim/'

# tmux
alias tx='tmux'
alias tConfig='nvim ~/.config/tmux/.tmux.conf -c "cd ~/.config/tmux"'
alias tConfigReload='tmux source-file ~/.tmux.conf'
alias txa='tmux attach -t'
alias txl='tmux ls'
alias txk='tmux kill-session -t'
alias txn='tmux new -s'

# kitty
if command -v kitty &>/dev/null; then
  alias kittytheme='kitty +kitten themes'
  alias nvkitty='nv ~/.config/kitty -c "cd ~/.config/kitty"'
  alias updateKitty='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'
fi

# Paths
alias cdTmuxConfig='cd ~/.config/tmux/'
if [[ "$OSTYPE" == "darwin"* ]]; then
  [[ -d "$HOME/bin/scripts" ]] && alias cdScripts="cd $HOME/bin/scripts"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  [[ -d "$HOME/.local/bin" ]] && alias cdScripts="cd $HOME/.local/bin"
fi

# General aliases
# `ls` e `...` ficaram de fora de proposito. O oh-my-zsh ja os define
# (theme-and-appearance.zsh e directories.zsh) e ganha por carregar antes
# — o `ls` dele se adapta ao SO, e o `...` dele e alias global (-g).
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias cd..='cd ../'
alias ..='cd ../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias ~="cd ~"
alias home="cd ~"
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias reloadConfig='exec zsh'
alias myip='curl https://ipinfo.io/ip'
alias ports='sudo lsof -i -P | grep LISTEN'
alias lastJsonModified='ls -t *.json | head -n1'
alias exitCode='echo "Exit code => " $?'
alias running_services="sudo lsof -nPi -sTCP:LISTEN"
alias whatismyipaddress='dig +short myip.opendns.com @resolver1.opendns.com'
alias sha1='/usr/bin/openssl sha1'
alias setExecutable='chmod +x '
alias countFiles='find . -type f | wc -l'

# Process
alias psmem='ps aux | sort -nr -k 4'
alias psmem10='ps aux | sort -nr -k 4 | head -10'
alias pscpu='ps aux | sort -nr -k 3'
alias pscpu10='ps aux | sort -nr -k 3 | head -10'

# macOS-specific aliases
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias f='open -a Finder ./'
  alias chrome='open -a "Google Chrome"'
  alias change_to_bash='chsh -s /bin/bash'
  alias resetBluetooth='sudo pkill bluetoothd'
  alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder; say cache flushed'
  alias md5='md5 -r'
  alias md5sum='md5 -r'
  alias localip='ipconfig getifaddr en0'
  alias cputemp='sudo powermetrics --samplers smc | grep -i "CPU die temperature"'
fi

# Linux-specific aliases
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  alias flushdns='sudo resolvectl flush-caches 2>/dev/null || sudo systemd-resolve --flush-caches'
  alias localip='hostname -I | awk "{print \$1}"'
  alias cputemp='cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | awk "{printf \"%.1f°C\n\", \$1/1000}"'
fi

# GIT
alias add='git add'
alias st='git status'
alias log='git log'
alias ci='git commit -m'
alias gamend='git commit --amend'
alias push='git push'
alias co='git checkout'
alias pull='git pull'
alias fixup='git fixup'
alias dif='git diff'
alias pushf='git push -f'
alias gitreset='git reset --soft HEAD~1'
alias gtags='git tag --list'
alias gdelete='git branch -D'
alias gbnew='git branch -m'
alias lg='lazygit'

# Dotnet
if command -v dotnet &>/dev/null; then
  alias dn='dotnet'
  alias dnb='dotnet clean && dotnet restore && dotnet build --force'
  alias dnr='dotnet run'
  alias dnc='dotnet clean'
  alias dnrt='dotnet restore'
  alias dnt='dotnet test'
fi

# NPM
if command -v npm &>/dev/null; then
  alias n='npm'
  alias nr='n run'
  alias ni='n install'
fi

# JSON
alias flattenJson='jq -c .'

# Util functions
jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

catFileWithColors() {
  cat $1 | jq
}

# work-specific config (not tracked by git)
[[ -f ~/.config/zsh-environment/private/work.zsh ]] && source ~/.config/zsh-environment/private/work.zsh
