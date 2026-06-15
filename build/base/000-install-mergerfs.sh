#!/bin/bash

set -ouex pipefail

MERGERFS_REPO_URL="https://github.com/trapexit/mergerfs"
MERGERFS_VERSION="2.42.0"
MERGERFS_FEDORA_VERSION="44"

# TODO Account for aarch64 systems.
mkdir -p /tmp/mergerfs
wget "$MERGERFS_REPO_URL/releases/download/$MERGERFS_VERSION/mergerfs-$MERGERFS_VERSION-1.fc$MERGERFS_FEDORA_VERSION.x86_64.rpm" -O /tmp/mergerfs/mergerfs.rpm
dnf5 -y install /tmp/mergerfs/mergerfs.rpm
