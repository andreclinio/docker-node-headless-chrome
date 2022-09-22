#!/bin/bash

artifact=`basename $PWD`
version=`git describe`
name="$artifact:$version"
repository="andreclinio/$name"

docker rmi -f $name
docker build --force-rm -t $name .
docker tag $name $repository
docker push $repository 

