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
  init Q
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

  apt-get -y autoremove --purge binutils build-essential bzip2 cpp cpp-4.{8,9} \
  dkms dpkg-dev g++ g++-4.{8,9} gcc gcc-4.{8,9} libasan1 libatomic1 \
  libc-dev-bin libc6-dev libcilkrts5 libcloog-isl4 libdpkg-perl \
  libgcc-4.{8,9}-dev libgomp1 libisl10 libitm1 liblsan0 libmpc3 libmpfr4 \
  libquadmath0 libstdc++-4.{8,9}-dev libtimedate-perl libtsan0 libubsan0 \
  linux-compiler-gcc-4.{8,9}-x86 linux-headers-$(uname -r) \
  linux-headers-$(uname -r) linux-kbuild-* linux-libc-dev make patch xz-utils
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
