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

# NVM
NVM_DIR=/root/.nvm
export NVM_DIR
. "$NVM_DIR/nvm.sh"


if [ 1 == $RUNGRUNT ]; then
  header "Installing grunt"
  if [ 1 == $SHOWPROGESS ]; then
    npm install -g grunt > /dev/null
  else
    npm install -g grunt --no-progress > /dev/null
  fi
  check_and_exit $? GRUNT
fi

if [ 1 == $RUNGULP ]; then
  header "Installing gulp"
  if [ 1 == $SHOWPROGESS ]; then
    npm install -g gulp > /dev/null
  else
    npm install -g gulp --no-progress > /dev/null
  fi
  check_and_exit $? GULP
fi

if [ 1 == $RUNBOWER ]; then
  header "Installing bower"
  if [ 1 == $SHOWPROGESS ]; then
    npm install -g bower > /dev/null
  else
    npm install -g bower --no-progress > /dev/null
  fi
  check_and_exit $? BOWER
fi 