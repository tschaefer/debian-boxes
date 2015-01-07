# Debian Boxes

Debian GNU/Linux Base Boxes for [Vagrant](http://vagrantup.com).

## Introduction

**debian-boxes** provides a simple shell script *janitor* and some configuration
stuff to install, configure and pack Debian based Vagrant boxes.
The OS is installed from a minimal network install ISO image.
The current provider is [VirtualBox](https://www.virtualbox.org/) only.

To run *janitor* following software is required:

  * [jq](http://stedolan.github.io/jq/)
  * [Packer](https://packer.io/)
  * [VirtualBox](https://www.virtualbox.org/)

## Usage

```
$ ./janitor -h

  usage: janitor -r|--release=<version> -k|--kernel=<version> [-d|--dry-run]
         janitor -h|--help
         janitor -v|--version

  options:
        -h --help                   display this message
        -v --version                display version

        -r --release=<version>      set release version
        -k --kernel=<version>       set kernel version
        -d --dry-run                process arguments, but don't build anything

  dependencies: jq, packer, virtualbox

```

You can choose the kernel version (latest stable [*base*] or backport [*bpo*])
and the Debian release version (*stable*, *wheezy*, *v770*, *v760*).

For further information and configuration see the JSON file.

## Details

The installation process sets up a minimal Debian with following extra
packages:

  * openssh-server
  * sudo
  * acpid
  * bash-completion
  * less
  * file
  * psmisc
  * ntpdate
  * curl
  * nfs-common
  * task-german

The environment is prepared for English (default) and German locales.
The timezone is set to *Europe/Berlin* and time is synchronized via network.
Apt is configured to not install recommended packages and the mirror points to
*http.debian.net* (main, contrib, non-free, updates, backports). The default user
is named *installer* with password *installer* and has superuser permission
without password reentry -
see [Vagrant SSH settings](https://docs.vagrantup.com/v2/vagrantfile/ssh_settings.html)

Further the hostname is set to the Debian release codename (e.g. *wheezy*) with
domain *local* and all getty's are deactivated.

The proper VirtualBox guest additions are installed, the container is
shrinked, packed as Vagrant box and named
debian-*version*-*kernel*-amd64-*provider*.box.
The box is configured to use 512M memory and 1 CPU -
see [Vagrant VirtualBox Configuration](https://docs.vagrantup.com/v2/virtualbox/configuration.html)

## License

[GNU GPL v3.0](http://choosealicense.com/licenses/gpl-3.0/)

## Is it any good?

[Yes](https://news.ycombinator.com/item?id=3067434)
