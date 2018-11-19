autoload -U colors && colors  
autoload -Uz vcs_info
# zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' (%b)' # %a %m %u %c)'
# zstyle ':vcs_info:git*' actionformats "(%b [%a])"

# CMD line
setopt PROMPT_SUBST
PROMPT='%{$fg[yellow]%}%n %{$fg[blue]%}$(basename $PWD)%{$fg[green]%}${vcs_info_msg_0_} $ %{$reset_color%}'
