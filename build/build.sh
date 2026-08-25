#!/bin/bash

set -ouex pipefail

# Add tailscale repo
dnf5 -y config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo

# Enable RPMFusion
dnf5 -y install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

# Remove Flatpak
dnf5 -y remove flatpak

# Remove Universal Blue update services
dnf5 -y remove ublue-os-update-services ublue-update

dnf5 -y install \
  acl \
  cockpit \
  cockpit-files \
  cockpit-podman \
  cockpit-selinux \
  container-selinux \
  fail2ban \
  fail2ban-firewalld \
  podman \
  podman-compose \
  rsync \
  samba \
  skopeo \
  snapraid \
  tailscale

dnf5 -y reinstall shadow-utils

# Ensure Cockpit SELinux policy module is loaded into the policy store.
# The RPM %post scriptlet for cockpit-ws-selinux does not reliably update
# file_contexts when building in buildah on a non-SELinux host (Ubuntu runner).
# Without this, bootc labels cockpit-session and cockpit-tls as bin_t,
# which blocks the process transition needed for Cockpit login.
semodule -i /usr/share/selinux/packages/targeted/cockpit.pp.bz2

# MergerFS
# TODO Account for other architectures?
# mkdir -p /tmp/mergerfs
# wget https://github.com/trapexit/mergerfs/releases/download/2.41.1/mergerfs-2.41.1-1.fc43.x86_64.rpm -O /tmp/mergerfs/mergerfs.rpm
# dnf5 -y install /tmp/mergerfs/mergerfs.rpm

systemctl enable podman.socket
systemctl enable cockpit.socket
systemctl enable tailscaled
systemctl enable firewalld

# Add firewall rule to allow access to services
firewall-offline-cmd --add-service=cockpit
firewall-offline-cmd --list-services

/tmp/build/base/000-install-mergerfs.sh
