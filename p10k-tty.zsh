# Sobrescritas do p10k.zsh para o console do Linux (VT, TERM=linux).
#
# O console so carrega fontes bitmap de ate 512 glifos: nao ha Nerd Font, e simbolos como
# ❯ ❮ ✔ nao existem nem na Terminus Uni3. Este arquivo nao faz nada sozinho: o zshrc so o
# carrega no Linux, com o cliente em TERM=linux e com ZSH_ENV_TTY_PROMPT=1 em
# private/machine.zsh. A moldura (╭─ ├─ ╰─), ✘ e ▶ seguem, porque a Terminus Uni3 os tem.

# Icones de segmento (os_icon, vcs, etc.) viram texto ou somem.
typeset -g POWERLEVEL9K_MODE=ascii
# O p10k.zsh fixa o glifo , que o modo ascii nao sobrescreve.
typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=''

typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='>'
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='<'
typeset -g POWERLEVEL9K_STATUS_OK{,_PIPE}_VISUAL_IDENTIFIER_EXPANSION='ok'
