# webbuild #

webbuild is a docker container that runs your frontend build tasks. It
was designed to have them running in a clean predefined environment yet
being customizable

The container can be used using briefbote/webbuild

## Inside ##

There are three flavors of this container:

* PHP 5.5
* PHP 5.6
* PHP 7.0

You can use specific php versions by using them as a tag:

`docker run briefbote/webbuild:55` for PHP5.5 for example.

The `latest` tag points to the PHP7.0 version

Build expects `/src` containing the source code and `/app` containing the release after all build steps have run.

Git is installed within the container.

### RUBY ###

If you need RUBY with `breakpoint` and `sass` please use the `-ruby` tags:

* 55-ruby
* 56-ruby
* 70-ruby

## Execution ##

NODEJS will be installed using nvm. It is respecting .nvmrc. After that, grunt, gulp and bower are installed

### Customization

You may want to turn off build tools. To do this you need to pass specific environment variables ( as in not empty ).

|Variable|Build tool|
|---|---|
|NOGULP|gulp|
|NOGRUNT|grunt|
|NOBOWER|bower|
|NOCOMPOSER|composer|

Setting such a variable will disable installation ( except of composer which is always installed ) and execution.

Doing this will speed up the build process.

## ONBUILD ##

There are two ONBUILD trigger. They copy `prebuild.sh` respectively `postbuild.sh` into the newly image. Therefore 
the following Dockerfile will allow you add standard customizations according to your needs:

    FROM briefbote/webbuild:latest
    MAINTAINER Test <donotreply@test.de>

## BASE directory ##

The base directory ( the directory where the entrypoint runs the build steps ) is `/src` except when
`/src/src` exists

## Build steps ##

1. `/exec/prebuild.sh` if it exists
2. `npm install` if `$BASE/package.json` exists
3. `bower` if `$BASE/bower.json` exists
4. `composer` without dev dependencies if `$BASE/composer.json` exists
5. `grunt` if `$BASE/Gruntfile` exists
6. `gulp` if `$BASE/gulpfile.js` exists
7. `/src/custom.sh` if it exists
8. `/exec/postbuild.sh` if it exists
9. Use `/src/build` as `/app` if `/app` is empty
10. Use `/src/release` as `/app` if `/app` is empty

## Return codes ##

Non zero exit codes will be returned when one of the build steps are failing or `/app` is empty after step 10

## Usage ##

Assume you want to build a web application in the current directory containing the sources within the `src` subfolder
and you want to place the build in the `app` subfolder.

Then you can run the build like this:

    docker run -t briefbote/webbuild:latest -v $PWD/src:/src -v $PWD/app:/app

A very simplistic sample of it is in the `test` subfolder of this repository (note that `test/app/` is in the `.gitignore` file).

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

|Version|Author|Description|
|---|---|---|
|20160920|S. Andres|Allow disabling some build tools|
|20160717.2|S. Andres|<ul><li>Seperate image with ruby support</li><li>Included git in README</li></ul>|
|20160717|S. Andres|Links updated|
|20160707|S. Andres|Using nvm for node installation|
