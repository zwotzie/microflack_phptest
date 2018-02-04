#!/bin/bash -e
# build a docker image for this micro service

pushd $(dirname ${BASH_SOURCE[0]})
SERVICE=$(basename $PWD)
SERVICE_NAME=$(egrep -o "[^_]+$" <<<"$SERVICE")
SERVICE_VERSION=$(git describe --tags)

if [ -z $SERVICE_VERSION ]; then
	export SERVICE_VERSION=1
fi

# docker does not allow to import files from external directories, so we temporarily copy our wheels here
rsync -rav --delete $WHEELHOUSE/ wheels/

# build the image
cmd="docker build --build-arg SERVICE_NAME=$SERVICE_NAME --build-arg SERVICE_VERSION=$SERVICE_VERSION -t $SERVICE:$SERVICE_VERSION ."

echo $cmd

$cmd

# clean up
rm -rf wheels
popd
