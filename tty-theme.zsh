# Paleta do console do Linux (VT, TERM=linux) e o comando ttytheme.
#
# O console tem 16 cores, mas o tom de cada uma pode ser trocado com \e]P<indice><RRGGBB>, sem
# sudo; \e]R volta a paleta padrao do kernel. A paleta vale para aquele tty ate um reset, logout
# ou reboot. Carregar este arquivo so define funcoes: nada e aplicado ate alguem rodar ttytheme
# ou o zshrc reaplicar o tema gravado em private/machine.zsh (ZSH_ENV_TTY_THEME).

# Escreve a paleta do tema $1 no tty $2. Retorna 1 para tema desconhecido.
_ttytheme_apply() {
  local -a paleta
  case $1 in
    light)
      # Base: One Light. 0 = fundo padrao, 7 = texto padrao, 15 = texto em negrito.
      # As intensas (9-14) sao mais escuras que as normais: no fundo claro, negrito tem de
      # ganhar contraste, nao perder.
      paleta=(
        0 fafafa  1 e45649  2 50a14f  3 c18401  4 4078f2  5 a626a4  6 0184bc  7 383a42
        8 696c77  9 ca1243  A 3e8a3d  B 986801  C 2a5bd6  D 8b1f89  E 016f9c  F 000000
      )
      local i seq=''
      for (( i = 1; i < $#paleta; i += 2 )); do
        seq+=$'\e]P'$paleta[i]$paleta[i+1]
      done
      print -nr -- "$seq" > $2
      ;;
    dark)
      print -nr -- $'\e]R' > $2
      ;;
    *)
      return 1
      ;;
  esac
}

# Poe em REPLY o tty do console por tras deste shell. Dentro do tmux o \e]P nao chega ao
# console, entao escreve direto no tty do cliente conectado, se ele for o console.
_ttytheme_target() {
  REPLY=''
  if [[ -n $TMUX ]]; then
    local cliente=(${(s: :)"$(tmux display -p '#{client_termname} #{client_tty}' 2>/dev/null)"})
    [[ $cliente[1] == linux ]] && REPLY=$cliente[2]
  elif [[ $TERM == linux ]]; then
    REPLY=$TTY
  fi
  [[ -n $REPLY && -w $REPLY ]]
}

# ttytheme [light|dark] — aplica o tema no console agora e o grava em private/machine.zsh.
# Sem argumento, mostra o tema gravado.
ttytheme() {
  local arquivo=~/.config/zsh-environment/private/machine.zsh

  if (( ! $# )); then
    if [[ -n $ZSH_ENV_TTY_THEME ]]; then
      print -r -- "$ZSH_ENV_TTY_THEME (gravado em $arquivo)"
    else
      print -r -- "dark (padrao do kernel)"
    fi
    return
  fi

  local tema=$1
  if [[ $tema != (light|dark) ]]; then
    print -u2 "uso: ttytheme [light|dark]"
    return 2
  fi
  if ! _ttytheme_target; then
    print -u2 "ttytheme: este shell nao esta no console do Linux (nem num tmux aberto nele)"
    return 1
  fi

  _ttytheme_apply $tema $REPLY

  # Regrava so a linha do tema; as outras opcoes da maquina ficam como estao.
  local -a linhas
  [[ -f $arquivo ]] && linhas=("${(@f)$(<$arquivo)}")
  linhas=("${(@)linhas:#ZSH_ENV_TTY_THEME=*}")
  if [[ $tema == light ]]; then
    linhas+=("ZSH_ENV_TTY_THEME=light   # paleta clara no console (ttytheme dark desfaz)")
    typeset -g ZSH_ENV_TTY_THEME=light
  else
    unset ZSH_ENV_TTY_THEME
  fi
  mkdir -p ${arquivo:h}
  print -rl -- "${linhas[@]}" > $arquivo
}
