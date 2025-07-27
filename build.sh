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

dnf -y install \
  cockpit \
  cockpit-files \
  cockpit-podman \
  cockpit-selinux \
  container-selinux \
  podman-compose \
  tailscale

systemctl enable podman.socket
systemctl enable cockpit.socket
systemctl enable tailscaled

# Add firewall rule to allow access to services
systemctl enable firewalld
firewall-offline-cmd --add-service=cockpit
