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

### bash/header.sh ###
function header() {
  echo
  echo "$1"
  echo
}
### bash/header.sh ###
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
### bash/check_and_exit.sh ###
function check_and_exit {
  if [ $1 -gt 0 ]; then
    error "Step failed ($2). See log"
    quit $1
  fi
}
### bash/check_and_exit.sh ###
### bash/exec_and_continue_on_ok.sh ###
function exec_and_continue_on_ok() {
	log "Executing $1 in $(pwd)"
	eval $1
	result=$?
	check_and_exit $result $1
}
### bash/exec_and_continue_on_ok.sh ###
### bash/log.sh ###
function log() {
	echo "--> $1"
}
### bash/log.sh ###

header "Updating system"
exec_and_continue_on_ok "curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - "
exec_and_continue_on_ok "echo \"deb http://dl.yarnpkg.com/debian/ stable main\" | tee /etc/apt/sources.list.d/yarn.list"
exec_and_continue_on_ok "apt-get update -qq -y"
exec_and_continue_on_ok "apt-get dist-upgrade -qq -y"
exec_and_continue_on_ok "apt-get install -qq -y wget git unzip"
exec_and_continue_on_ok "apt-get autoremove -qq -y"
exec_and_continue_on_ok "apt-get clean -qq"

header "nvm" 
exec_and_continue_on_ok "wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.1/install.sh | bash"

header "yarn"
exec_and_continue_on_ok "apt-get install -qq -y yarn "

header "composer"
exec_and_continue_on_ok "php -r \"copy('https://getcomposer.org/installer', 'composer-setup.php');\""
exec_and_continue_on_ok "php composer-setup.php"
exec_and_continue_on_ok "php -r \"unlink('composer-setup.php');\""

header "task"
mkdir -p /bin
cd /bin
exec_and_continue_on_ok "wget https://github.com/go-task/task/releases/download/v1.3.0/task_Linux_x86_64.tar.gz"
exec_and_continue_on_ok "tar xzvf task_Linux_x86_64.tar.gz"
cd -

header "Cleanup"
exec_and_continue_on_ok "rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*"

exec_and_continue_on_ok "chmod 700 /exec/build.sh"
log "Made build.sh executable"
