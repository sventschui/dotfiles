JHOME=$(/usr/libexec/java_home -v 1.8.0_181)
if [ "$?" != "0" ]; then
  echo "Please install Java and source the .bashrc again to set JAVA_HOME"
  /usr/libexec/java_home -v 1.8.0_181 --request
else
  export JAVA_HOME=$JHOME
fi
