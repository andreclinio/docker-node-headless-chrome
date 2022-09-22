#!/bin/bash

artifact=`basename $PWD`
version=`git describe`
name="$artifact:$version"

docker rmi -f $name
docker build --force-rm -t $name .

