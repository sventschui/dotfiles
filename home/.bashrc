# Docker
export DOCKER_HOST=unix:///var/run/docker.sock

# GO
export GOOS=darwin
export GOARCH=amd64
export GOPATH=$HOME/go

# Java
JHOME=$(/usr/libexec/java_home)
if [ "$?" != "0" ]; then
  echo "Please install Java and source the .bashrc again to set JAVA_HOME"
  /usr/libexec/java_home --request
else
  export JAVA_HOME=$JHOME
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Allow to specify sensitive data inside .bashrc_private
if [ -f ".bashrc_private" ]; then
  source .bashrc_private
fi
