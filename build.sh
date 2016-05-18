#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chef_ver=12.5.1
force=false
push=true

# Parse opts
while getopts ":v:fl" opt; do
  case $opt in
    v)
      chef_ver=$OPTARG
      ;;
    f)
      force=true
      ;;
    l)
      push=false
      ;;
  esac
done

echo "Building containers for Chef $chef_ver"

for platform in $(ls -d */ | tr -d /)
do
  cd $DIR/$platform
  for version in $(ls -d */ | tr -d /)
  do
    cd $DIR/$platform/$version

    # Skip if no template exists
    if [ ! -f Dockerfile.template ]; then
      continue
    fi

    # Do not rebuild unless forced
    if [ -f Dockerfile.${chef_ver} ] && [ "$force" = false ]; then
      continue
    fi

    echo "  building $platform-$version"
    sed -e "s/CHEF_VER/${chef_ver}/g" Dockerfile.template > Dockerfile.${chef_ver}
    docker build -f Dockerfile.${chef_ver} --rm=true -t jmccann/chef:${platform}-${version} .
    if [ $? -ne 0 ]; then
      echo "ERROR: Failed to build $platform-$version"
      rm -f Dockerfile.${chef_ver}
      exit 1
    fi
    docker build -f Dockerfile.${chef_ver} --rm=true -t jmccann/chef:${platform}-${version}-${chef_ver} .

    # Push to the hub
    if [ "$push" = true ]; then
      docker push jmccann/chef:${platform}-${version}
      docker push jmccann/chef:${platform}-${version}-${chef_ver}
    fi
  done
done
