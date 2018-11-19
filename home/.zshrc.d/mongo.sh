function mrestore_dir {
  if [ "$#" == "0" ]; then
    echo "mrestore /path/to/archive --gzip --other-options"
    return
  fi

  ARCHIVE=$1;
  shift;
  docker run --rm -it -v $ARCHIVE:/dump.archive --net=host mongo:3.4 mongorestore /dump.archive "$*"
}

function mrestore {
  if [ "$#" == "0" ]; then
    echo "mrestore /path/to/archive --gzip --other-options"
    return
  fi

  ARCHIVE=$1;
  shift;
  docker run --rm -it -v $ARCHIVE:/dump.archive --net=host mongo:3.4 mongorestore --archive=/dump.archive $*
}

function mdump {
  if [ "$#" == "0" ]; then
    echo "mdump /path/to/archive --gzip --other-options"
    return
  fi

  LOCATION=$1
  shift;
  docker run --rm -it -v $LOCATION:/dump.archive --net=host mongo:3.4 mongodump --archive=/dump.archive "$@"
}
