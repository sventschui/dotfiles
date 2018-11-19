# CMD line
make_prompt() {
  
  local RESET="\033[00m"
  local RED="\033[31m"
  local GREEN="\033[32m"
  local YELLOW="\033[33m"
  local BLUE="\033[94m" # this is actually light blue

  markup_git_branch() {
    if [[ -n $@ ]]; then
      COLOR=$GREEN
      CHANGE_INDICATOR="*"
      if [[ -n $(git status --porcelain 2> /dev/null) ]]; then
        # Working dir is dirty
        COLOR=$RED
        CHANGE_INDICATOR="*"
      fi
      
      echo -e "$COLOR($@$CHANGE_INDICATOR)\033[0m"
    fi
  }

  parse_git_branch() {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* (*\([^)]*\))*/\1/'
  }

  export PS1="$YELLOW\u $BLUE\W \$(markup_git_branch \$(parse_git_branch)) $RED$ $RESET"
}

make_prompt

# Docker
export DOCKER_HOST=unix:///var/run/docker.sock

# GO
export GOOS=darwin
export GOARCH=amd64
export GOPATH=$HOME/go

# Java
JHOME=$(/usr/libexec/java_home -v 1.8.0_181)
if [ "$?" != "0" ]; then
  echo "Please install Java and source the .bashrc again to set JAVA_HOME"
  /usr/libexec/java_home -v 1.8.0_181 --request
else
  export JAVA_HOME=$JHOME
fi

# NVM
export NVM_DIR="$HOME/.nvm"
source $(brew --prefix nvm)/nvm.sh

# Allow to specify sensitive data inside .bashrc_private
if [ -f "$HOME/.bashrc_private" ]; then
  source $HOME/.bashrc_private
fi

function mrestore {
  if [ "$#" == "0" ]; then
    echp "mrestore /path/to/archive --gzip --other-options"
    exit 1
  fi

  ARCHIVE=$1;
  shift;
  docker run --rm -it -v $ARCHIVE:/dump.archive --net=host mongo:3.4 mongorestore --archive=/dump.archive "$*"
}

function mdump {
  if [ "$#" == "0" ]; then
    echp "mdump /path/to/archive --gzip --other-options"
    exit 1
  fi

  LOCATION=$1
  shift;
  docker run --rm -it -v $LOCATION:/dump.archive --net=host mongo:3.4 mongodump --archive=/dump.archive "$@"
}

# JSON Tools

alias json2yml='ruby -e "require \"json\"; require \"yaml\"; puts JSON.parse(STDIN.read).to_yaml"'

