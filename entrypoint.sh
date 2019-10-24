#!/bin/bash
set -e

REGISTRY=${INPUT_REGISTRY:-gcr.io}
IMAGE=${INPUT_IMAGE}
ENVIRONMENT=${INPUT_ENVIRONMENT:-development}
TAG=${INPUT_VERSION_TAG}
PROJECT=${INPUT_GCLOUD_PROJECT}

if [ -n "${GCLOUD_AUTH_KEY}" ]
then
    echo "${GCLOUD_AUTH_KEY}" | base64 --decode > /tmp/gcloud_key.json
    gcloud auth activate-service-account --quiet --key-file /tmp/gcloud_key.json
    gcloud auth configure-docker --quiet
else
    echo "GCLOUD_AUTH_KEY not provided, exiting" 1>&2
    exit 1
fi

sh -c "docker build -t $IMAGE:$GITHUB_SHA ./"

sh -c "docker tag $IMAGE:$GITHUB_SHA $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:$GITHUB_SHA"
sh -c "docker tag $IMAGE:$GITHUB_SHA $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:latest"

if [ -n "${TAG}" ]
then
    sh -c "docker tag $IMAGE:$GITHUB_SHA $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:${TAG}"
    sh -c "docker push $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:${TAG}"
fi

sh -c "docker push $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:$GITHUB_SHA"
sh -c "docker push $REGISTRY/$PROJECT/$ENVIRONMENT/$IMAGE:latest"
