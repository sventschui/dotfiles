fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
zstyle ':completion:*' special-dirs true

