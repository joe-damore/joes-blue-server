#!/bin/bash

# Removes the root filesystem entry from /etc/fstab if it exists.
# Only runs if `.rm_mount_for_root` file is absent.
# See also: https://gitlab.com/fedora/ostree/sig/-/work_items/72#note_2707425978
# https://web.archive.org/web/20260322190927/https://gitlab.com/fedora/ostree/sig/-/work_items/72

set -euo pipefail

main() {
    # Used to condition execution of this unit at the systemd level
    local -r stamp_file="/var/lib/.rm_mount_for_root"

    local -r root_UUID="$(cat /proc/cmdline | grep -E -o 'root=UUID=.{36}' | cut -d '=' -f 2,3)"
    if [[ $(grep -E '^'"${root_UUID}"'[[:space:]]/[[:space:]]' /etc/fstab) && \
    $(findmnt / | grep composefs) && ! -L /boot/grub2/grub.cfg ]]; then
        sed --in-place="-BACKUP" '/^'"${root_UUID}"'[[:space:]]\/[[:space:]]/d' /etc/fstab
        touch "${stamp_file}"
    else
        exit 0
    fi
}
