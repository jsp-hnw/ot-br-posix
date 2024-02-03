#!/usr/bin/env bash

cd "$(dirname "$0")"/../../

set -ex
docker buildx build --platform linux/arm/v7 -t qorvo-otbr-arm32 -f etc/docker/Dockerfile-arm64 . \
	--build-arg REFERENCE_DEVICE=1 --build-arg=OTBR_OPTIONS='-DOT_DNS_CLIENT=ON -DOT_SRP_CLIENT=ON -DOT_LINK_METRICS_INITIATOR=ON'

exit 0
