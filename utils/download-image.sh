#!/bin/sh

set -eu
DIR="$(dirname "$(test -L "$0" && readlink "$0" || echo "$0")")"

. $DIR/../infra/etc/env

mkdir -p $IMAGE_DIR
IMAGE_URL=${URL}${IMAGE}
(cd $IMAGE_DIR && curl -O $IMAGE_URL)
