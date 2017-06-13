#! /bin/bash

# Copyright 2017 Sascha Andres
#   
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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