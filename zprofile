export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/bin/scripts:$PATH"
export PATH="$HOME/bin/scripts/string-utils:$PATH"
export PATH="$PATH:$HOME/.dotnet/tools"
export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
GPG_TTY=$(tty)
export GPG_TTY

#Leiningen
export LEIN_JVM_OPTS="-Daether.dependencyCollector.impl=bf"

#JAVA
#export JAVA_HOME=$(/usr/libexec/java_home -v 17.0.16) #java 17
# export JAVA_HOME=$(/usr/libexec/java_home -v 16) #java 16
# export JAVA_HOME=$(/usr/libexec/java_home -v 1.8.381.09) #java 8
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-21.jdk/Contents/Home" #java 21
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home" #java 11
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-16.0.2.jdk/Contents/Home" #java 16
# export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home" #java 8
export PATH=$JAVA_HOME/bin:$PATH

# >>> coursier install directory >>>
export PATH="$PATH:$HOME/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

# Nvm and Node
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NODE_OPTIONS=--openssl-legacy-provider

#nvim
alias nv='nvim'
alias nv.='nvim .'
alias v='vim'
alias zprofile='nvim ~/.zprofile'
alias vConfig='nvim ~/.vimrc'
alias nvconfig='nvim ~/.config/nvim/ -c "cd ~/.config/nvim/"'
alias cdNvimConfig='cd ~/.config/nvim/'

#tmux
alias tx='tmux'
alias tConfig='nvim ~/.tmux.conf'
alias tConfigReload='tmux source-file ~/.tmux.conf'
alias txa='tmux attach -t'
alias txl='tmux ls'
alias txk='tmux kill-session -t'
alias txn='tmux new -s'

#kitty
alias kittytheme='kitty +kitten themes'
alias nvkitty='nv ~/.config/kitty -c "cd ~/.config/kitty"'
alias updateKitty='curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin'

# Paths
alias cdTmuxConfig='cd ~/.config/tmux/'
alias cdScripts='cd $HOME/bin/scripts'

# ALIAS
alias ls='ls -la'
alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias f='open -a Finder ./'                 # f: Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~: Go Home
alias home="cd ~"                           # home: Go Home
alias c='clear'                             # c: Clear terminal display
alias path='echo -e ${PATH//:/\\n}'         # path: Echo all executable Paths
alias reloadConfig='source ~/.zprofile'
alias myip='curl https://ipinfo.io/ip'
alias ports='sudo lsof -i -P | grep LISTEN'
alias lastJsonModified='ls -t *.json | head -n1'
alias exitCode='echo "Exit code => " $?'

# macOS specific aliases
alias resetBluetooh='sudo pkill bluetoothd'

# System shortcuts
alias flushdns='sudo dscacheutil -flushcache;sudo killall -HUP mDNSResponder;say cache flushed'
alias sha1='/usr/bin/openssl sha1'
alias md5='md5 -r'
alias md5sum='md5 -r'
alias running_services="sudo lsof -nPi -sTCP:LISTEN"
alias whatismyipaddress='dig +short myip.opendns.com @resolver1.opendns.com'
alias localip='ipconfig getifaddr en0'
alias chrome='open -a "Google Chrome"'
alias change_to_bash='chsh -s /bin/bash'
alias setExecutable='chmod +x '
alias countFiles='find . -type f | wc -l'

## get top process eating memory
alias psmem='ps aux | sort -nr -k 4'
alias psmem10='ps aux | sort -nr -k 4 | head -10'

## get top process eating cpu ##
alias pscpu=' ps aux | sort -nr -k 3 '
alias pscpu10=' ps aux | sort -nr -k 3 | head -10 '
alias cputemp='sudo powermetrics --samplers smc |grep -i "CPU die temperature"'

# GIT alias commands
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

##
##

# MacPorts Installer addition on 2021-07-30_at_09:03:23: adding an appropriate PATH variable for use with MacPorts.
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

#Dotnet commands
alias dn='dotnet'
alias dnb='dotnet clean && dotnet restore && dotnet build --force'
alias dnr='dotnet run'
alias dnc='dotnet clean'
alias dnrt='dotnet restore'
alias dnt='dotnet test'

#Clojure commands
alias cljReplRun='clj -M:repl/conjure'

#Kafka commands
#alias startKafka='docker-compose -f ~/Docker/composes/kafka.yaml --project-name kafka up -d'
#alias stopKafka='docker-compose -f ~/Docker/composes/kafka.yaml --project-name kafka down'
alias startKafka='confluent local kafka start'
alias stopKafka='confluent local kafka stop'

#Util functions

#Decode jwt token
jwt-decode() {
  jq -R 'split(".") |.[0:2] | map(@base64d) | map(fromjson)' <<< $1
}

#How to cat a file with colors
# cat <fileName> | jq
catFileWithColors() {
    cat $1 | jq
}

#CERTIFICATES
print-certificate-pfx() {
    openssl pkcs12 -in $1 -info -noout
}

#NPM
alias n='npm'
alias nr='n run'
alias ni='n install'

#databricks
alias dbc='databricks'

#json
alias flattenJson='jq -c .'

# work-specific config (not tracked by git)
[[ -f ~/.config/zsh-environment/private/work.zsh ]] && source ~/.config/zsh-environment/private/work.zsh
