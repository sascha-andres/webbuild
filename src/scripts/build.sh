#! /bin/bash

# Copyright 2016 Sascha Andres
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

if [ -e /src/Taskfile.yml ]; then

  header "Using task"
  log "look at https://github.com/go-task/task for documentation"
  cd /src
  task build

else

  header "BUILD"

  if [ 1 == $USENODE ]; then
    # run package managers
    if [ -e $BASE/package.json ]; then
      header "RUNNING NPM INSTALL"
      if [ 1 == $SHOWPROGESS ]; then
        $PKG_MANAGER install > /dev/null
      else
        $PKG_MANAGER install --no-progress > /dev/null
      fi
      check_and_exit $? npm_install
    fi
  fi

  if [ 1 == $RUNBOWER ]; then
    if [ -e $BASE/bower.json ]; then
      header "Running BOWER"
      bower install --allow-root --config.interactive=false
      check_and_exit $? bower
    fi
  fi

  if [ 1 == $RUNCOMPOSER ]; then
    if [ -e $BASE/composer.json ]; then
      header "Running COMPOSER"
      composer install --no-dev --prefer-dist --optimize-autoloader
      check_and_exit $? composer
    fi
  fi

  # run build systems
  if [ 1 == $RUNGRUNT ]; then
    if [ -e $BASE/Gruntfile ]; then
      header "Running GRUNT"
      grunt
      check_and_exit $? grunt
    fi
  fi

  if [ 1 == $RUNGULP ]; then
    if [ -e $BASE/gulpfile.js ]; then
      header "Running GULP"
      gulp
      check_and_exit $? gulp
    fi
  fi

  # run custom.sh if included in source
  if [ -e /src/.webbuild/custom.sh ]; then
    header "DEPRECATED: Running CUSTOM"
    /bin/bash /src/.webbuild/custom.sh $BASE
    check_and_exit $? custom
  fi

  # Running mounted postbuild
  if [ -e /src/.webbuild/postbuild.sh ]; then
    header ".webbuild POSTBUILD"
    /bin/bash /src/.webbuild/postbuild.sh $BASE
    check_and_exit $? postbuild
  fi
fi

if [ "x" != "x$FILE_OWNER" ]; then
  header "Setting user rights"
  chown -R $FILE_OWNER /app
  check_and_exit $? chown
fi

if [ ! "$(ls -A /app)" ]; then
  echo "*** NO BUILD RESULT"
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 1
else
  echo "*** For any questions or issues go to https://github.com/sascha-andres/webbuild"
  exit 0
fi