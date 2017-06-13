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

function check_and_exit {
    if [ $1 -gt 0 ]; then
        echo "Build step failed ($2). See log"
        echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
        exit $1
    fi
}

function header {
    echo ""
    echo "*** $1 ***"
    echo ""
}

RUNGRUNT=1
RUNGULP=1
RUNBOWER=1
RUNCOMPOSER=1
USENODE=1
USEYARN=0
SHOWPROGESS=0

header "Running version 20170509"

# NVM
NVM_DIR=/root/.nvm
export NVM_DIR
. "$NVM_DIR/nvm.sh"

# Set variables for build run
BASE=/src
echo "==> Base directory: $BASE"
cd $BASE

# Running mounted prebuild
if [ -e $BASE/.webbuild/prebuild.sh ]; then
  header ".webbuild PREBBUILD"
  /bin/bash $BASE/.webbuild/prebuild.sh $BASE
  check_and_exit $? prebuild
fi

header "configuration"

if [ -e $BASE/.webbuild/variables.sh ]; then
  echo "Including variables.sh"
  . $BASE/.webbuild/variables.sh
fi

cd $BASE

echo "RUNGRUNT:    $RUNGRUNT"
echo "RUNGULP:     $RUNGULP"
echo "RUNBOWER:    $RUNBOWER"
echo "RUNCOMPOSER: $RUNCOMPOSER"
echo "USEYARN:     $USEYARN"
echo "USENODE:     $USENODE"
echo "SHOWPROGESS: $SHOWPROGESS"

header "Setting package manager"

PKG_MANAGER="npm"
if [ 1 == $USEYARN ]; then
  PKG_MANAGER="yarn"
fi

echo "set to $PKG_MANAGER"

NODE_ACTIVE=0
let "NODE_ACTIVE += $USENODE"
let "NODE_ACTIVE += $RUNGRUNT"
let "NODE_ACTIVE += $RUNGULP"
let "NODE_ACTIVE += $RUNBOWER"

. build_install_node.sh

. build_install.sh

if [ -e $BASE/Taskfile.yml ]; then

  header "Using task"
  log "look at https://github.com/go-task/task for documentation"
  /bin/task build

fi

. build_build.sh

if [ "x" != "x$FILE_OWNER" ]; then
  header "Setting user rights"
  chown -R $FILE_OWNER /app
  check_and_exit $? chown_build
fi
_build
if [ ! "$(ls -A /app)" ]; then
  echo "*** NO BUILD RESULT"
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 1
else
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 0
fi
