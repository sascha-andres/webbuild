# webbuild #

webbuild is a docker container that runs your frontend build tasks. It
was designed to have them running in a clean predefined environment yet
being customizable

The container can be used using briefbote/webbuild

## Inside ##

There are four flavors of this container:

* PHP 5.5
* PHP 5.6
* PHP 7.0
* PHP 7.1

You can use specific php versions by using them as a tag:

`docker run briefbote/webbuild:56` for PHP5.5 for example.

The `latest` tag points to the PHP7.0 version

Build expects `/src` containing the source code and `/app` containing the release after all build steps have run.

Git is installed within the container.

The package build-essential is installed within the container.

### Note about php-55

This container will not be updated automatically as support for PHP 5.5 has been retired. Version 5.6 will get security updates until 12/31/2018.

See http://php.net/supported-versions.php

## Execution ##

NODEJS will be installed using nvm. It is respecting .nvmrc. After that, grunt, gulp and bower are installed

### Customization

You can disable build tools ( installation and run ). Also it is possible to set a custom base directory. From a docker perspective you can inherit from this image and customize the resulting image with a pre- and postbuild script.

See https://github.com/sascha-andres/webbuild/wiki/Customization for more information. 

## Build steps ##

1. Loading `$BASEDIR/.webbuild/variables.sh` if it exists
2. `nvm install 4` or `nvm install` in .webbuild/ is .nvmrc exists there if using node
3. `$BASEDIR/.webbuild/prebuild.sh` if it exists
4. `npm install` if `$BASE/package.json` exists
5. `bower` if `$BASE/bower.json` exists
6. `composer` without dev dependencies if `$BASE/composer.json` exists
7. `grunt` if `$BASE/Gruntfile` exists
8. `gulp` if `$BASE/gulpfile.js` exists
9. `$BASE/.webbuild/custom.sh` if it exists, fallback `$BASE/custom.sh` (deprecated)
10. `$BASEDIR/.webbuild/postbuild.sh` if it exists
11. Use `/src/build` as `/app` if `/app` is empty
12. Use `/src/release` as `/app` if `/app` is empty

Currently a `$BASE/.nvmrc` is still respected.

## Return codes ##

Non zero exit codes will be returned when one of the build steps are failing or `/app` is empty after step 14.

## Usage ##

Assume you want to build a web application in the current directory containing the sources within the `src` subfolder
and you want to place the build in the `app` subfolder.

Then you can run the build like this:

    docker run -t briefbote/webbuild:latest -v $PWD/src:/src -v $PWD/app:/app

### Samples

#### simple

A very simplistic sample of it is in the `samples/simple` subfolder of this repository (note that `test/app/` is in the `.gitignore` file).

To run the sample change to the test directory and run `run.sh`. It (re)creates the app subfolder ands starts a build
that actually does nothing more then to copy the `index.html` using a custom.sh into the `/app` folder

## Code ##

Code is open source under the Apache 2.0 License. You can obtain it at https://github.com/sascha-andres/webbuild

If you want to contribute feel free to open an issue

## on hub.docker.com ##

https://hub.docker.com/r/briefbote/webbuild/

## Help

Feel free to contact me by creating an issue on https://github.com/sascha-andres/webbuild/issues.
You can connect to me using Twitter at https://twitter.com/livingit_de.

## History ##

History is now edited on GitHub WIKI: https://github.com/sascha-andres/webbuild/wiki/History
