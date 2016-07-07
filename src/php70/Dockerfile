# Copyright 2016 Sascha Andres
#   
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#   
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM php:7.0-apache
MAINTAINER Sascha Andres <sascha.andres@outlook.com>

RUN mkdir /src && \
    mkdir /app && \
    mkdir /exec && \
    echo "\n**** Updating system ***\n" && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y wget git unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    echo "\n*** nvm ***\n" && \
    wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash && \
    echo "\n*** composer ***\n" && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
# Changes automatically, we can not use this
# https://getcomposer.org/download/
#    php -r "if (hash_file('SHA384', 'composer-setup.php') === '070854512ef404f16bac87071a6db9fd9721da1684cd4589b1196c3faf71b9a2682e2311b36a5079825e155ac7ce150d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    echo "\n*** Ruby ***\n" && \
    apt-get install -y ruby ruby-dev libffi-dev make

RUN  gem install rubygems-update && \
    update_rubygems && \
    gem install sass --no-document && \
    gem install compass --no-document && \
    gem install breakpoint --no-document && \
    echo "\n*** Cleanup ***\n" && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/build.sh /exec/build.sh
COPY scripts/composer /usr/local/bin/composer

ONBUILD COPY prebuild.sh /exec/prebuild.sh
ONBUILD COPY postbuild.sh /exec/postbuild.sh

RUN chmod 700 /exec/build.sh

ENTRYPOINT /exec/build.sh
