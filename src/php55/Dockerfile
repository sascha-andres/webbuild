FROM php:5.5-apache
MAINTAINER Sascha Andres <sascha.andres@outlook.com>

RUN mkdir /src && \
    mkdir /app && \
    mkdir /exec && \
    echo "\n**** Updating system ***\n" && \
    apt-get update && \
    apt-get dist-upgrade && \
    apt-get install -y wget && \
    apt-get autoremove && \
    apt-get clean && \
    echo "\n*** node ***\n" && \
    mkdir -p /tmp/node && \
    wget https://deb.nodesource.com/setup_4.x --output-document /tmp/node/setup_4.x && \
    chmod 700 /tmp/node/setup_4.x && \
    /tmp/node/setup_4.x && \
    apt-get install -y nodejs build-essential && \
    echo "\n*** grunt ***\n" && \
    npm install -g grunt && \
    echo "\n*** Gulp ***\n" && \
    npm install -g gulp && \
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
