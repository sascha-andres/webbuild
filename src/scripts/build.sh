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
        exit $1
    fi
}

function header {
    echo ""
    echo "*** $1 ***"
    echo ""
}

# NVM
NVM_DIR=/root/.nvm
export NVM_DIR
. "$NVM_DIR/nvm.sh"

# Set variables for build run
BASE=/src
if [ "x" == "x$SETBASEDIR" ]; then
  if [ -d /src/src ]; then
    BASE=/src/src
  fi
else
  BASE=$SETBASEDIR
fi

echo "==> Base directory: $BASE"

cd $BASE

header "NODE and NODE based"

if [ -e $BASE/.webbuild/.nvmrc ]; then
  echo "*** Using .nvmrc"
  nvm install
  check_and_exit $? NVM_USE
  nvm use
  check_and_exit $? NVM_USE
else
  if [ -e $BASE/.nvmrc ]; then
    echo "!! $BASE/.nvmrc is deprecated. Use $BASE/.webbuild/.nvmrc !!"
    cd $BASE/.webbuild
    nvm install
    check_and_exit $? NVM_USE
    nvm use
    check_and_exit $? NVM_USE
    cd $BASE
  else
    nvm install 4
    check_and_exit $? NVM_INSTALL
    nvm use 4
    check_and_exit $? NVM_USE
  fi
fi


echo "*** NODE version: `node --version`"

# as this may be an inherited image check for prebuild and if it exists execute it
if [ -e /exec/prebuild.sh ]; then
  header "PREBBUILD"
  /bin/bash /exec/prebuild.sh $BASE
  check_and_exit $? prebuild
fi

header "Updating npm"
npm install -g npm --no-progress
check_and_exit $? npm_update

if [ "x" == "x$NOGRUNT" ]; then
  header "Installing grunt"
  npm install -g grunt --no-progress
  check_and_exit $? GRUNT
fi

if [ "x" == "x$NOGULP" ]; then
  header "Installing gulp"
  npm install -g gulp --no-progress
  check_and_exit $? GULP
fi

if [ "x" == "x$NOBOWER" ]; then
  header "Installing bower"
  npm install -g bower --no-progress
  check_and_exit $? BOWER
fi 

header "BUILD"

# run package managers
if [ -e $BASE/package.json ]; then
  header "RUNNING NPM INSTALL"
  npm install --no-progress
  check_and_exit $? npm_install
fi

if [ "x" == "x$NOBOWER" ]; then
  if [ -e $BASE/bower.json ]; then
    header "Running BOWER"
    bower install --allow-root --config.interactive=false
    check_and_exit $? bower
  fi
fi

if [ "x" == "x$NOCOMPOSER" ]; then
  if [ -e $BASE/composer.json ]; then
    header "Running COMPOSER"
    composer install --no-dev --prefer-dist --optimize-autoloader
    check_and_exit $? composer
  fi
fi

# run build systems
if [ "x" == "x$NOGRUNT" ]; then
  if [ -e $BASE/Gruntfile ]; then
    header "Running GRUNT"
    grunt
    check_and_exit $? grunt
  fi
fi

if [ "x" == "x$NOGULP" ]; then
  if [ -e $BASE/gulpfile.js ]; then
    header "Running GULP"
    gulp
    check_and_exit $? gulp
  fi
fi

# run custom.sh if included in source
if [ -e $BASE/custom.sh ]; then
  header "Running CUSTOM"
  /bin/bash $BASE/custom.sh
  check_and_exit $? custom
fi

# as this may be an inherited image check for postbuild an if it exits execute it
if [ -e /exec/postbuild.sh ]; then
  header "Running POSTBUILD"
  /bin/bash /exec/postbuild.sh
  check_and_exit $? postbuild
fi

# check for empty /app dir
if [ ! "$(ls -A /app)" ]; then
  header "COPY"
  if [ -d $BASE/build ]; then
    header "build/"
    cp -R $BASE/build/* /app/
    check_and_exit $? build_app
  else
    if [ -d $BASE/release ]; then
      header "release/"
      cp -R $BASE/release/* /app/
      check_and_exit $? release_app
    fi
  fi
fi

if [ ! "$(ls -A /app)" ]; then
  echo "*** NO BUILD RESULT"
  exit 1
else
  exit 0
fi
