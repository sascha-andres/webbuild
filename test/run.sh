#! /bin/bash

echo ""
echo "*** Clean up previously created assets ***"
echo ""

rm -rf app/
mkdir app

echo ""
echo "*** Start the build ***"
echo ""

docker run -v $PWD/src:/src -v $PWD/app:/app -t briefbote/webbuild:55
