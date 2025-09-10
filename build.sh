#/bin/bash

set -x

TAG=$1
ECR_URL=$2
COMMIT_HASH=$3



if [ -z "$TAG" ]; then
  echo "TAG is not set"
  exit 1
fi

if [ "$TAG" == "latest" ]; then
   VERSION=$(cat src/__init__.py | grep __version__ | awk -F'"' '{print $2}' )

    docker build -f imagefile -t ${ECR_URL}:${TAG}-${COMMIT_HASH} .
fi

if [ "$TAG" != "latest" ]; then
    docker build -f imagefile -t ${ECR_URL}:${TAG} .
    exit 0
fi

