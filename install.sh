#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

########################################
#
# Install completion
# - Docker compose: See https://docs.docker.com/compose/completion/#zsh
# - Docker: no docs
# - Git: see https://medium.com/@oliverspryn/adding-git-completion-to-zsh-60f3b0e7ffbc
#
########################################
mkdir -p ~/.zsh/completion

curl -L https://raw.githubusercontent.com/docker/compose/1.25.4/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

curl -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker > ~/.zsh/completion/_docker

curl -o ~/.zsh/completion/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.zsh/completion/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh

rm -rf ~/.zcompdump

########################################
#
# Link all files inside home/* to the users home dir
#
########################################
shopt -s dotglob

for path in "$DIR"/home/*; do
  f=$(basename $path)

  if [ "$(readlink -- "$HOME/$f")" != "$path" ]; then
    if [ -e "$HOME/$f" ]; then
      read -p "File $HOME/$f already exists, override? [y/N]" choice
      case "$choice" in
        y|Y)
          rm -rf "$HOME/$f"
          ;;
        *)
          echo "Skipping..."
          continue;
          ;;
      esac
    fi

    echo "Linking $f"
    ln -s "$path" "$HOME/$f"
  fi
done

shopt -u dotglob

########################################
#
# Install brew
#
########################################
BREW_TEST=$(brew help)
if [ "$?" != "0" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

########################################
#
# Install all the things
#
########################################
function brew_install_or_upgrade {
    if brew ls --versions "$1" >/dev/null; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade "$1"
    else
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
    fi
}
brew_install_or_upgrade nvm
brew_install_or_upgrade golang
brew_install_or_upgrade maven

########################################
#
# Java
#
########################################
JHOME=$(/usr/libexec/java_home)
if [ "$?" != "0" ]; then
  /usr/libexec/java_home --request
fi

