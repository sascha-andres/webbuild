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

### bash/check_and_exit.sh ###
function check_and_exit {
  if [ $1 -gt 0 ]; then
    error "Step failed ($2). See log"
    quit $1
  fi
}
### bash/check_and_exit.sh ###
### bash/header.sh ###
function header() {
  echo
  echo "$1"
  echo
}
### bash/header.sh ###
### bash/log.sh ###
function log() {
	echo "--> $1"
}
### bash/log.sh ###
### bash/quit.sh ###
function quit() {
  echo
  log "Exiting with result $1"
  exit $1
}
### bash/quit.sh ###
### bash/error.sh ###
function error() {
  echo "!! $1 !!"
}
### bash/error.sh ###

RUNGRUNT=1
RUNGULP=1
RUNBOWER=1
RUNCOMPOSER=1
USEANGULAR2CLI=0
USENODE=1
USEYARN=0
SHOWPROGESS=0
VERSION_ANGULAR2CLI=""

header "Running version 20170704"

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

echo "RUNGRUNT:       $RUNGRUNT"
echo "RUNGULP:        $RUNGULP"
echo "RUNBOWER:       $RUNBOWER"
echo "RUNCOMPOSER:    $RUNCOMPOSER"
echo "USEANGULAR2CLI: $USEANGULAR2CLI"
echo "USEYARN:        $USEYARN"
echo "USENODE:        $USENODE"
echo "SHOWPROGESS:    $SHOWPROGESS"

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
let "NODE_ACTIVE += $USEANGULAR2CLI"

. /exec/build_install_node.sh

. /exec/build_install.sh

. /exec/build_build.sh

if [ -e $BASE/Taskfile.yml ]; then

  header "Using task"
  log "look at https://github.com/go-task/task for documentation"
  NVM_DIR=/root/.nvm /bin/task
  check_and_exit $? task

fi

# Running mounted postbuild
if [ -e /src/.webbuild/postbuild.sh ]; then
  header ".webbuild POSTBUILD"
  /bin/bash /src/.webbuild/postbuild.sh $BASE
  check_and_exit $? postbuild
fi

if [ "x" != "x$FILE_OWNER" ]; then
  header "Setting user rights"
  chown -R $FILE_OWNER /app
  check_and_exit $? chown_build
fi

if [ ! "$(ls -A /app)" ]; then
  echo "*** NO BUILD RESULT"
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 1
else
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 0
fi
