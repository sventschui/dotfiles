# Override auto-title when static titles are desired ($ title My new title)
title() { export TITLE_OVERRIDDEN=1; echo -en "\e]0;$*\a"}
# Turn off static titles ($ autotitle)
autotitle() { export TITLE_OVERRIDDEN=0 }; autotitle
# Condition checking if title is overridden
overridden() { [[ $TITLE_OVERRIDDEN == 1 ]]; }
# Echo asterisk if git state is dirty
# gitDirty() { [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n1) != ("clean"|"") ]] && echo "*" }

# Show cwd when shell prompts for input.
precmd() {
  vcs_info

  if [[ -n ${vcs_info_msg_0_} ]]; then
    # vcs_info found something (the documentation got that backwards
    # STATUS line taken from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/git.zsh
    STATUS=$(command git status --porcelain 2> /dev/null | tail -n1)
    # git diff origin/$(git name-rev --name-only HEAD)..HEAD --name-status
    # TO_PUSH=$(git diff origin/$(git name-rev --name-only HEAD)..HEAD --name-status | wc -l  | awk '{print $1}')
    BRANCH_STATUS=$(command git status -b --porcelain doesnotexistsblablabla 2> /dev/null)
    local AHEAD
    local BEHIND
    [[ $BRANCH_STATUS =~ 'ahead ([0-9]+)' ]] && AHEAD=$match[1]
    [[ $BRANCH_STATUS =~ 'behind ([0-9]+)' ]] && BEHIND=$match[1]
    
    # echo "$TO_PUSH"
    if [[ -n "$AHEAD" ]]; then
      AHEAD="↑$AHEAD"
    fi
    if [[ -n "$BEHIND" ]]; then
      BEHIND="↓$BEHIND"
    fi
    BRANCH_DIFF="$AHEAD$BEHIND"
    if [[ -n "$BRANCH_DIFF" ]]; then
      BRANCH_DIFF=" $BRANCH_DIFF"
    fi

    if [[ -n $STATUS || -n $BRANCH_DIFF ]]; then
      PROMPT='%{$fg[yellow]%}%n %{$fg[blue]%}$(basename $PWD) %{$fg[red]%}(${vcs_info_msg_0_}$BRANCH_DIFF) $ %{$reset_color%}'
    else
      PROMPT='%{$fg[yellow]%}%n %{$fg[blue]%}$(basename $PWD) %{$fg[green]%}(${vcs_info_msg_0_}) $ %{$reset_color%}'
    fi
  else
    PROMPT='%{$fg[yellow]%}%n %{$fg[blue]%}$(basename $PWD) %{$fg[green]%}$ %{$reset_color%}'
  fi

  if overridden; then return; fi
  pwd=$(pwd) # Store full path as variable
  cwd=${pwd##*/} # Extract current working dir only
  print -Pn "\e]0;$cwd\a" # Replace with $pwd to show full path
}

# Prepend command (w/o arguments) to cwd while waiting for command to complete.
preexec() { 
   if overridden; then return; fi
   printf "\033]0;%s\a" "${1%% *} | $cwd" # Omit construct from $1 to show args
}

# added by travis gem
[ -f /Users/sventschui/.travis/travis.sh ] && source /Users/sventschui/.travis/travis.sh

source ~/.zshrc.d/ansible.sh
source ~/.zshrc.d/completion.sh
source ~/.zshrc.d/docker.sh
source ~/.zshrc.d/go.sh
source ~/.zshrc.d/java.sh
source ~/.zshrc.d/json2yml.sh
source ~/.zshrc.d/killport.sh
source ~/.zshrc.d/mongo.sh
source ~/.zshrc.d/nvm.sh
source ~/.zshrc.d/prompt.sh
source ~/.zshrc.d/python.sh

# Allow to specify sensitive data inside .zshrc_private
if [ -f "$HOME/.zshrc_private" ]; then
  source $HOME/.zshrc_private
fi

