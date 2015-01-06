#!/bin/bash

set -x

function network() {
  rm -f /etc/udev/rules.d/70-persistent-net.rules
  mkdir /etc/udev/rules.d/70-persistent-net.rules
  rm -f /lib/udev/rules.d/75-persistent-net-generator.rules
  rm -rf /dev/.udev/ /var/lib/dhcp/* /var/lib/dhcp3/*
  echo "pre-up sleep 2" >> /etc/network/interfaces
}

function config() {
  cp -rf /tmp/config/etc/* /etc
  mv /home/installer/.vbox_version /etc/vbox_version
}

function vboxtools() {
  apt-get update
  apt-get install -y linux-headers-$(uname -r) build-essential dkms

  vbox_version=$(cat /etc/vbox_version)
  mount -o loop /home/installer/VBoxGuestAdditions_${vbox_version}.iso /mnt
  sh /mnt/VBoxLinuxAdditions.run --nox11
  umount /mnt
  rm /home/installer/VBoxGuestAdditions_${vbox_version}.iso

  apt-get -y autoremove --purge linux-headers-$(uname -r) build-essential dkms \
  binutils bzip2 cpp cpp-4.6 cpp-4.7 dpkg-dev gcc gcc-4.6 gcc-4.6-base gcc-4.7 \
  libc-dev-bin libc6-dev libclass-isa-perl libdpkg-perl libgmp10 libgomp1 \
  libitm1 libmpc2 libmpfr4 libquadmath0 libswitch-perl libtimedate-perl \
  linux-libc-dev make patch perl perl-modules
}

function cleanup() {
  rm -rf /tmp/*
  apt-get autoclean
  apt-get clean
}

function disk() {
  dd if=/dev/zero of=/EMPTY bs=1M
  sync
  rm -vf /EMPTY
  sync
}

network
config
vboxtools
cleanup
disk

set +x
