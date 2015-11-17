#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

CHEF_VER=12.5.1
if [ ! -z $1 ]; then
  CHEF_VER=$1
fi

echo "Building containers for Chef $CHEF_VER"

for platform in $(ls -d */ | tr -d /)
do
  cd $DIR/$platform
  for version in $(ls -d */ | tr -d /)
  do
    cd $DIR/$platform/$version
    if [ ! -f Dockerfile.template ]; then
      continue
    fi
    echo "  building $platform-$version"
    sed -e "s/CHEF_VER/${CHEF_VER}/g" Dockerfile.template > Dockerfile.${CHEF_VER}
    docker build -f Dockerfile.${CHEF_VER} --rm=true -t jmccann/chef:${platform}-${version} .
    if [ $? -ne 0 ]; then
      echo "ERROR: Failed to build $platform-$version"
      exit 1
    fi
    docker build -f Dockerfile.${CHEF_VER} --rm=true -t jmccann/chef:${platform}-${version}-${CHEF_VER} .
  done
done
