# docker-chef

Repo for creating docker containers with Chef preinstalled.

Primarily for use with kitchen-docker for cookbook testing.

# build.sh
The script `build.sh` is used to build all the images.  By default it will build for the version of Chef specified in the script and only build for images that do not have a Dockerfile generated for that platform-version-chef_version.

The script takes arguments to allow:
* `-f` - Force rebuild images
* `-v CHEF_VERSION` - Specify manually a version of chef to build images for

# Deploying images
`docker push jmccann/chef`
