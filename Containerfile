ARG BASE_IMAGE_NAME="base"
ARG BASE_IMAGE_VARIANT="main"
ARG BASE_IMAGE_FEDORA_MAJOR_VERSION="43"
ARG BASE_IMAGE_RESOLVED="ghcr.io/ublue-os/${BASE_IMAGE_NAME}-${BASE_IMAGE_VARIANT}"

# BLUE_SERVER_IMAGE_EDITION
#
# The server OS edition being built. Values currently supported: 'main', 'media-server'.
#
# `main`: Primary unopinionated server OS edition
# `media-server`: Opinionated media server OS edition.
ARG BLUE_SERVER_IMAGE_EDITION="main"

# BLUE_SERVER_IMAGE_ARCH
#
# Architecture of server image. Either 'x86_64' or 'aarch64'.
ARG BLUE_SERVER_IMAGE_ARCH="x86_64"

FROM ${BASE_IMAGE_RESOLVED}:${BASE_IMAGE_FEDORA_MAJOR_VERSION} AS base

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

# Copy build scripts and base rootfs
COPY /build /tmp/build
COPY /rootfs/base/. /

ENV BLUE_SERVER_IMAGE_EDITION="${BLUE_SERVER_IMAGE_EDITION}"
ENV BLUE_SERVER_IMAGE_ARCH="${BLUE_SERVER_IMAGE_ARCH}"

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build/build.sh && \
    ostree container commit
