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

if [ 1 == $USEANGULAR2CLI ]; then
  if [ -e $BASE/.angular-cli.json ]; then
    header "ANGULAR2CLI (ng) is available"
    check_and_exit $? ng
  fi
fi

# run custom.sh if included in source
if [ -e /src/.webbuild/custom.sh ]; then
  header "DEPRECATED: Running CUSTOM"
  /bin/bash /src/.webbuild/custom.sh $BASE
  check_and_exit $? custom
fi
