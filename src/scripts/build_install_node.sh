#! /bin/bash

if [ 0 -lt $NODE_ACTIVE ]; then
  header "NODE and NODE based"

  if [ -e /src/.webbuild/.nvmrc ]; then
    echo "*** Using .nvmrc"
    cd /src/.webbuild
    nvm install
    check_and_exit $? NVM_USE
    nvm use
    check_and_exit $? NVM_USE
    cd $BASE
  else
    nvm install 6
    check_and_exit $? NVM_INSTALL
    nvm use 6
    check_and_exit $? NVM_USE
  fi

  echo "==> NODE version: `node --version`"

  header "Updating npm"
  if [ 1 == $SHOWPROGESS ]; then
    npm install -g npm > /dev/null
  else
    npm install -g npm --no-progress > /dev/null
  fi
  check_and_exit $? npm_update

  echo "==> NPM version: `npm --version`"
fi