# PATH
export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="$HOME/bin/scripts:$PATH"
export PATH="$HOME/bin/scripts/string-utils:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"

# GPG
GPG_TTY=$(tty)
export GPG_TTY

# Java
if [[ "$OSTYPE" == "darwin"* ]]; then
  export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home"
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"  # MacPorts
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  for _jvm in \
    "/usr/lib/jvm/default-java" \
    "/usr/lib/jvm/java-21-openjdk-amd64" \
    "/usr/lib/jvm/java-21-openjdk"; do
    [[ -d "$_jvm" ]] && { export JAVA_HOME="$_jvm"; break; }
  done
  unset _jvm
fi
[[ -n "${JAVA_HOME:-}" ]] && export PATH="$JAVA_HOME/bin:$PATH"

# Coursier
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export PATH="$PATH:$HOME/.local/share/coursier/bin"
fi

# Leiningen
export LEIN_JVM_OPTS="-Daether.dependencyCollector.impl=bf"

# nvim
alias nv='nvim'
alias nv.='nvim .'
alias v='vim'
alias zprofile='nvim ~/.zprofile'
alias vConfig='nvim ~/.vimrc'
alias nvconfig='nvim ~/.config/nvim/ -c "cd ~/.config/nvim/"'
alias cdNvimConfig='cd ~/.config/nvim/'

# tmux
alias tx='tmux'
alias tConfig='nvim ~/.tmux.conf'
alias tConfigReload='tmux source-file ~/.tmux.conf'
alias txa='tmux attach -t'
alias txl='tmux ls'
alias txk='tmux kill-session -t'
alias txn='tmux new -s'

# kitty
alias kittytheme='kitty +kitten themes'
alias nvkitty='nv ~/.config/kitty -c "cd ~/.config/kitty"'
alias updateKitty='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

# Paths
alias cdTmuxConfig='cd ~/.config/tmux/'
alias cdScripts="cd $HOME/bin/scripts"

# General aliases
alias ls='ls -la'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias ~="cd ~"
alias home="cd ~"
alias c='clear'
alias path='echo -e ${PATH//:/\\n}'
alias reloadConfig='source ~/.zprofile'
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
alias dn='dotnet'
alias dnb='dotnet clean && dotnet restore && dotnet build --force'
alias dnr='dotnet run'
alias dnc='dotnet clean'
alias dnrt='dotnet restore'
alias dnt='dotnet test'

# Clojure
alias cljReplRun='clj -M:repl/conjure'

# Kafka
alias startKafka='confluent local kafka start'
alias stopKafka='confluent local kafka stop'

# NPM
alias n='npm'
alias nr='n run'
alias ni='n install'

# Databricks
alias dbc='databricks'

# JSON
alias flattenJson='jq -c .'

# Util functions
jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

catFileWithColors() {
  cat $1 | jq
}

print-certificate-pfx() {
  openssl pkcs12 -in $1 -info -noout
}
