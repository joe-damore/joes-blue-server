#!/bin/bash

set -ouex pipefail

MERGERFS_REPO_URL="https://github.com/trapexit/mergerfs"
MERGERFS_VERSION="2.41.1"
MERGERFS_FEDORA_VERSION="43"

mkdir -p /tmp/mergerfs
wget "$MERGERFS_REPO_URL/releases/download/$MERGERFS_VERSION/mergerfs-$MERGERFS_VERSION-1.fc$MERGERFS_FEDORA_VERSION.$BLUE_SERVER_IMAGE_ARCH.rpm" -O /tmp/mergerfs/mergerfs.rpm
dnf5 -y install /tmp/mergerfs/mergerfs.rpm
