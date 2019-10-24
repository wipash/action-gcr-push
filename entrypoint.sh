#!/bin/bash
set -e

REGISTRY=${INPUT_REGISTRY:-gcr.io}
IMAGE=${INPUT_IMAGE:-$GITHUB_REPOSITORY}
TAG=${INPUT_TAG:-$GITHUB_SHA}

if [ -n "${GCLOUD_AUTH_KEY}" ]
then
    echo "${GCLOUD_AUTH_KEY}" | base64 --decode > /tmp/gcloud_key.json
    gcloud auth activate-service-account --quiet --key-file /tmp/gcloud_key.json
    gcloud auth configure-docker --quiet
else
    echo "GCLOUD_AUTH_KEY not provided, exiting" 1>&2
    exit 1
fi

sh -c "docker build -t $IMAGE:$TAG ."
sh -c "docker tag $IMAGE:$TAG $REGISTRY/$IMAGE:$TAG"
sh -c "docker push $REGISTRY/$IMAGE"
