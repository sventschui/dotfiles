#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

#
# Link all files inside home/* to the users home dir
#
shopt -s dotglob
for path in "$DIR"/home/*; do
  f=$(basename $path)
  if [ "$(readlink -- "$HOME/$f")" != "$path" ]; then
    if [ -f "$HOME/$f" ]; then
      read -p "File $HOME/$f already exists, override? [y/N]" choice
      case "$choice" in
        y|Y)
          rm "$HOME/$f"
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

#
# Install brew
#
BREW_TEST=$(brew help)
if [ "$?" != "0" ]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

#
# Install all the things
#
brew install nvm golang

#
# Java
#
JHOME=$(/usr/libexec/java_home)
if [ "$?" != "0" ]; then
  /usr/libexec/java_home --request
fi

