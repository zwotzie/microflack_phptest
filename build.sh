#!/bin/bash -e
# build a docker image for this service

pushd $(dirname ${BASH_SOURCE[0]})
export SERVICE=$(basename $PWD)
export SERVICE_NAME=$(egrep -o "[^_]+$" <<<"$SERVICE")
export SERVICE_VERSION=$(git describe --tags)

if [ -z $SERVICE_VERSION ]; then
	export SERVICE_VERSION=1
fi

# docker does not allow to import files from external directories, so we
# temporarily copy our wheels here
cp -R $WHEELHOUSE wheels

# build the image
cmd="docker build --build-arg SERVICE_NAME=$SERVICE_NAME --build-arg SERVICE_VERSION=$SERVICE_VERSION -t $SERVICE ."

echo $cmd

$cmd

# clean up
rm -rf wheels
popd
