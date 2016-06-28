#! /bin/bash

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

# Set variables for build run
BASE=/src

if [ -d /src/src ]; then
    BASE /src/src
fi

echo ""
echo "****** BUILD ******"
echo ""

echo "*** Base directory: $BASE"

# as this may be an inherited image check for prebuild and if it exists execute it
if [ -e /exec/prebuild.sh ]; then
    header "PREBBUILD"
    chmod 700 /exec/prebuild.sh
    /exec/prebuild.sh $BASE
    check_and_exit $? prebuild
fi

# run package managers
cd $BASE
if [ -e $BASE/package.json ]; then
    header "NPM INSTALL"
    npm install
    check_and_exit $? npm_install
fi

if [ -e $BASE/bower.json ]; then
    header "BOWER"
    bower install --allow-root --config.interactive=false
    check_and_exit $? bower
fi

if [ -e $BASE/composer.json ]; then
    header "COMPOSER"
    composer install --no-dev --prefer-dist --optimize-autoloader
    check_and_exit $? composer
fi

# run build systems
if [ -e $BASE/Gruntfile ]; then
    header "GRUNT"
    grunt
    check_and_exit $? grunt
fi

if [ -e $BASE/gulpfile.js ]; then
    header "GULP"
    gulp
    check_and_exit $? gulp
fi

# run custom.sh if included in source
if [ -e /src/custom.sh ]; then
    header "GULP"
    chmod 700 /src/custom.sh
    /src/custom.sh
    check_and_exit $? custom
fi

# as this may be an inherited image check for postbuild an if it exits execute it
if [ -e /exec/postbuild.sh ]; then
    header "POSTBUILD"
    chmod 700 /exec/psotbuild.sh
    /exec/postbuild.sh
    check_and_exit $? postbuild
fi

# check for empty /app dir
if [ ! "$(ls -A /app)" ]; then
    header "COPY"
    if [ -d /src/build ]; then
        header "build/"
        cp -R /src/build/* /app/
        check_and_exit $? build_app
    else
        if [ -d /src/release ]; then
            header "release/"
            cp -R /src/release/* /app/
            check_and_exit $? release_app
        fi
    fi
fi

if [ ! "$(ls -A /app)" ]; then
    exit 1
else
    exit 0
fi