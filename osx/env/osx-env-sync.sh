grep export $HOME/.bashrc | while IFS=' =' read ignoreexport envvar ignorevalue; do
  launchctl setenv ${envvar} ${!envvar}
done
