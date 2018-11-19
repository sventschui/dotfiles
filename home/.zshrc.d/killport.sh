function killport {
  kill $(lsof -nP -i4TCP:$1 | grep LISTEN | awk '{print $2}')
}
