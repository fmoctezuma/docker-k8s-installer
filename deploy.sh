#!/usr/bin/env bash

set -e

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -ne 1 ]]; then
    echo "You must set a version number"
    echo "./deploy.sh <terraform version>"
    exit 1
fi

version=$1
dockerfile_version=$(grep TERRAFORM_VERSION= ${base}/Dockerfile-light | cut -d= -f2)

if [[ $version != $dockerfile_version ]]; then
    echo "Version mismatch in 'Dockerfile-light'"
    echo "found ${dockerfile_version}, expected ${version}."
    echo "Make sure the versions are correct."
    exit 1
fi

quayrepo="quay.io/fmoctezuma/docker-k8s-installer"
echo "Building docker images for terraform ${version}..."
docker build -f "${base}/Dockerfile-full" -t ${quayrepo}:full .
docker build -f "${base}/Dockerfile-light" -t ${quayrepo}:light .
docker tag ${quayrepo}:light ${quayrepo}:${version}
docker tag ${quayrepo}:light ${quayrepo}:latest

echo "Uploading docker images for terraform ${version}..."
docker push ${quayrepo}:${version}
docker push ${quayrepo}:latest
docker push ${quayrepo}:light
docker push ${quayrepo}:full
