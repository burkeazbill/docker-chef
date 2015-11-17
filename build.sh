#!/bin/bash

chefver=12.5.1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for platform in $(ls -d */ | tr -d /)
do
  cd $DIR/$platform
  for version in $(ls -d */ | tr -d /)
  do
    cd $DIR/$platform/$version
    if [ ! -f Dockerfile ]; then
      continue
    fi
    echo "Building for $platform-$version"
    docker build --rm=true -t jmccann/chef:${platform}-${version} .
    docker build --rm=true -t jmccann/chef:${platform}-${version}-${chefver} .
  done
done
