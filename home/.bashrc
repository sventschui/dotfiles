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
if [ -f ".bashrc_private" ]; then
  source .bashrc_private
fi

function mrestore {
 ARCHIVE=$1;
 shift;
 docker run --rm -it -v $ARCHIVE:/dump.archive --net=host mongo:3.4 mongorestore --archive=/dump.archive "$*"
}

function mdump {
  LOCATION=$1
  shift;
  docker run --rm -it -v $LOCATION:/dump.archive --net=host mongo:3.4 mongodump --archive=/dump.archive "$@"
}


