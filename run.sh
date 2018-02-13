#!/bin/bash -e
# This script starts a container for a microservice.
# set -x

SERVICE=$(basename $PWD)
SERVICE_NAME=$(egrep -o "[^_]+$" <<<"$SERVICE")
SERVICE_VERSION=$(git describe --tags)

SERVICE_URL="/php"
BACKEND_URL=""

SOCKETIO=""
LOAD_BALANCER=haproxy


if [[ "$HOST_IP_ADDRESS" == "" ]]; then
    echo Variable HOST_IP_ADDRESS is undefined.
    exit 1
fi

if [[ "$LB_HOST" == "" ]]; then
    echo Variable LB_HOST is undefined.
    exit 1
fi

if [[ -z $ZK && -z $ETCD ]]; then
  echo 'you have to define a zookeeper ensemble or an etcd ensemble'
  exit 1
fi

if [ -z ${ZK+x} ]; then 
  if [ -z ${ETCD+x} ]; then
      echo "ETCD is unset";
  else
      echo "ETCD is set to '$ETCD'";
      SERVICE_BACKEND="ETCD=$ETCD"
  fi
else
    echo "ZK is set to '$ZK'"; 
    SERVICE_BACKEND="ZK=$ZK"
fi

ID=$(docker run -d --restart always -P \
    -e PYTHONUNBUFFERED=1 \
    -e HOST_IP_ADDRESS=$HOST_IP_ADDRESS \
    -e $SERVICE_BACKEND \
    -e LOAD_BALANCER=$LOAD_BALANCER \
    -e SERVICE_NAME=$SERVICE_NAME \
    -e SERVICE_URL=$SERVICE_URL \
    -e BACKEND_URL=$BACKEND_URL \
    -e LB=http://$HOST_IP_ADDRESS \
    -e LB_HOST=$LB_HOST \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -l app=microflack \
    -l service=$SERVICE \
    "$@" \
    $SERVICE:$SERVICE_VERSION)
docker rename $ID ${SERVICE_NAME}_${ID:0:12}
echo $ID
