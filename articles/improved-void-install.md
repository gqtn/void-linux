# void-pi: 

Void Linux installer implemented in GNU Prolog.
Read directly from the great (official repository)[https://github.com/sdbtools/void-pi).

## Description

### Overview

void-pi is a Void Linux installer similar to [void-installer](https://docs.voidlinux.org/installation/live-images/guide.html).

It extends void-installer in several ways:
- provides predefined templates for [LVM](https://en.wikipedia.org/wiki/Logical_volume_management), and [LUKS](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup).
- provides predefined partitioning templates for block devices and [BTRFS](https://en.wikipedia.org/wiki/Btrfs) and [ZFS](https://en.wikipedia.org/wiki/ZFS).
- supports [rEFInd](https://rodsbooks.com/refind/), [Limine](https://limine-bootloader.org/), [Syslinux](https://wiki.syslinux.org/wiki/index.php?title=The_Syslinux_Project), [Gummiboot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/), and [ZFSBootMenu](https://docs.zfsbootmenu.org/) boot managers
- supports EFISTUB boot loader
- supports multi-device configurations.
- supports either BIOS or UEFI, or both boot modes.
- installs and configures additional boot manager and file system related software.

void-pi works on Void with Intel or AMD x86 CPU. It wasn't tested with ARM CPUs.

## How to run

### Run installer from another computer.

- Boot from an installation ISO.
- Run `ip a` to get an IP address.
- From another computer run:
    - `ssh anon@ip_address`
    - `sudo bash`
    - Run void-pi.

### Run precompiled executable.
```sh
sudo xbps-install -Suy xbps wget
wget https://github.com/sdbtools/void-pi/releases/latest/download/void-pi.x86_64.tgz
tar -xzf void-pi.x86_64.tgz
./void-pi
```

### Run as script.
```sh
sudo xbps-install gprolog git
git clone https://github.com/sdbtools/void-pi.git
cd void-pi
./void-pi.pl
# or
gprolog --consult-file void-pi.pl
```

### Compile Prolog code locally and run it.

```sh
sudo xbps-install gprolog gcc git
git clone https://github.com/sdbtools/void-pi.git
cd void-pi
gplc --min-size void-pi.pl
./void-pi
```

### Manually run btrbk

- `sudo btrbk run`

### Manually run grub-btrfs

- `grub-mkconfig -o /boot/grub/grub.cfg`

### ZFS Install media

#### mklive.sh

This option is to build a custom Void Linux image from the official [void-mklive](https://github.com/void-linux/void-mklive) repository.

```sh
$ git clone --depth=1 https://github.com/void-linux/void-mklive.git
$ cd void-mklive
$ make
$ sudo ./build-x86-images.sh -- -p zfs
```

#### hrmpf image

Download a pre-built [hrmpf](https://github.com/leahneukirchen/hrmpf/releases) image.

### Bcachefs Install media

#### mklive.sh

This option is to build a custom Void Linux image from the official [void-mklive](https://github.com/void-linux/void-mklive) repository.

```sh
$ git clone --depth=1 https://github.com/void-linux/void-mklive.git
$ cd void-mklive
$ make
$ sudo ./build-x86-images.sh -- -v linux6.7
```

## Features

- completely emulates `void-installer`.
- install from Void ISO or network.
- predefined templates for LVM, LUKS, and combinations of them.
- predefined partitioning templates.
- selected devices will be automatically cleaned up.
- TUI for setting up of file system features and options.
- TUI for setting up of mount options.
- TUI dynamically changes depending on selected template.
- uses `/mnt` for chroot by default.
- allows to use an alternative rootdir via `--rootdir` command line argument.
- all settings can be saved in a file and loaded on startup. File name is controlled via `--config` command line argument.
- passwords are never saved in files even temporarily.
- max password length is limited to 1024 charaters.
- Boot modes
    - UEFI
    - BIOS
    - both
- Boot managers
    - Uses GRUB, rEFInd, Limine, Syslnux, or Gummiboot as a boot manager.
    - Uses EFISTUB as a boot loader.
    - rEFInd is configured to use kernel auto detection.
    - Only GRUB can have `/boot` on LVM or LUKS.
    - ZFSBootMenu is enabled only with the "GPT. Basic" template at this time.
    - If a boot manager doesn't support a file system (or LVM, or LUKS), then installer will create an ext4 `/boot` partition.

Boot manager | Supported /boot filesystems
------------ | ----------------------------------------------------------------------------------
GRUB         | fat, btrfs, ext2, ext3, ext4, xfs, nilfs2, and zfs (zfs has limited support)
Gummiboot    | fat, ext2, ext3, ext4, xfs, nilfs2, and f2fs (btrfs is not supported at this time)
rEFInd       | fat, btrfs, ext2, ext3, and ext4
Limine       | fat, (Support of ext2, ext3, and ext4 was disabled in Limine version 6.20231210.0)
Syslinux     | fat, ext2, ext3, and ext4, and xfs (btrfs is not supported at this time)
EFISTUB      | fat, ext2, ext3, ext4, f2fs, and xfs (btrfs is not supported at this time)
ZFSBootMenu  | zfs

- ZFS
    - Requires a ZFS install media.
    - Supported by GRUB and ZFSBootMenu bootmanagers.
    - In case of GRUB only "GPT. Basic" template is supported at this time.
    - Encryption can be enabled via "FS Settings".
    - In case of GRUB encryption shouldn't be used because GRUB doesn't support it.
- Bcachefs
    - Requires a Bcachefs install media.
- Syslinux
    - In case of UEFI the kernel and initramfs files are located in the EFI system partition (aka ESP), as Syslinux does not (currently) have the ability to access files outside its own partition.
    - IA32 (32-bit) is currently unsupported.
- EFISTUB
    - The kernel and initramfs files are located in the EFI system partition (aka ESP).
    - btrfs is not supported.
- Gummiboot
    - The kernel and initramfs files are located in the EFI system partition (aka ESP).
    - btrfs is not supported.
- ZFSBootMenu
    - Only direct EFI booting is supported at this time.
    - Enabled only with "Manual" and "GPT. Basic" templates at this time.
- LUKS
    - LUKS can be used with GRUB, rEFInd, Limine, and Syslinux.
    - Only GRUB can have `/boot` on LUKS.
    - In case of GRUB whole system is located on LUKS, including encrypted `/boot`. LUKS1 is used because GRUB2 doesn't support LUKS2.
    - In case of rEFInd and Limine installer will create an unencrypted ext4 `/boot` partition. LUKS2 is used.
- LVM
    - Only GRUB can have `/boot` on LVM.
- Multi-device support
    - Multi-device configurations are available with BTRFS and LVM.
- Additional software
    - [snooze](https://github.com/leahneukirchen/snooze) - run a command at a particular time.
    - [btrbk](https://github.com/digint/btrbk) - Tool for creating snapshots and remote backups of btrfs subvolumes.
    - [grub-btrfs](https://github.com/Antynea/grub-btrfs) - improves the grub bootloader by adding a btrfs snapshots sub-menu, allowing the user to boot into snapshots.

Last tested | ISO                                                                                | Result
----------- | ---------------------------------------------------------------------------------- | ------
2024-06-08  | [void-live-x86_64-20240229-base.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-20240229-base.iso) | PASS
2023-06-29  | [void-live-x86_64-musl-20221001-base.iso](https://repo-default.voidlinux.org/live/current/void-live-x86_64-musl-20221001-base.iso) | PASS
2023-10-21  | [void-live-i686-20230628-base.iso](https://repo-default.voidlinux.org/live/current/void-live-i686-20230628-base.iso) | PASS
2023-06-29  | [void-live-i686-20221001-base.iso](https://repo-default.voidlinux.org/live/current/void-live-i686-20221001-base.iso) | N/A
2023-06-29  | [void-live-i686-20210930.iso](https://repo-default.voidlinux.org/live/20210930/void-live-i686-20210930.iso) | PASS
2023-10-14  | [hrmpf-x86_64-6.1.3_1-20230105.iso ](https://github.com/leahneukirchen/hrmpf/releases/download/v20231102/hrmpf-x86_64-6.5.9_1-20231102.iso) | PASS
2023-11-19  | [hrmpf-x86_64-6.5.9_1-20231102.iso](https://github.com/leahneukirchen/hrmpf/releases/download/v20230105/hrmpf-x86_64-6.1.3_1-20230105.iso) | PASS
2023-08-22  | [void-live-lxqt-unofficial-x86_64-6.3.13_1-20230821.iso](https://voidbuilds.xyz/download/void-live-lxqt-unofficial-x86_64-6.3.13_1-20230821.iso) | PASS
2023-12-17  | [void-live-kde-unofficial-x86_64-6.5.13_1-20231217.iso](https://voidbuilds.xyz/download/void-live-kde-unofficial-x86_64-6.5.13_1-20231217.iso) | PASS

## Templates

- Manual configuration of everything
- GPT. Basic
- GPT. LVM
- GPT. LVM. LUKS
- GPT. LUKS. One device
- GPT. LUKS. LVM. One device

## Partitioning Templates

### BTRFS
void-pi creates the following Btrfs subvolumes with a [flat layout][flat layout]:

- root

Subvolume name    | Mounting point    | Mount options
---               | ---               | ---
`@`               | `/`               |
`@snapshots`      | `/.snapshots`     | `nodev,noexec,nosuid` + nodatacow

- root_home

Subvolume name    | Mounting point    | Mount options
---               | ---               | ---
`@`               | `/`               |
`@home`           | `/home`           | `nodev,nosuid`
`@snapshots`      | `/.snapshots`     | `nodev,noexec,nosuid` + nodatacow

- max

Subvolume name    | Mounting point    | Mount options
---               | ---               | ---
`@`               | `/`               |
`@home`           | `/home`           | `nodev,nosuid`
`@opt`            | `/opt`            | `nodev`
`@srv`            | `/srv`            | `nodev,noexec,nosuid` + [nodatacow][nodatacow]
`@var`            | `/var`            | `nodev,noexec,nosuid`
`@var-cache-xbps` | `/var/cache/xbps` | `nodev,noexec,nosuid`
`@var-lib-ex`     | `/var/lib/ex`     | `nodev,noexec,nosuid` + nodatacow
`@var-log`        | `/var/log`        | `nodev,noexec,nosuid` + nodatacow
`@var-opt`        | `/var/opt`        | `nodev,noexec,nosuid`
`@var-spool`      | `/var/spool`      | `nodev,noexec,nosuid` + nodatacow
`@var-tmp`        | `/var/tmp`        | `nodev,noexec,nosuid` + nodatacow
`@snapshots`      | `/.snapshots`     | `nodev,noexec,nosuid` + nodatacow

### ZFS

- root
 
Dataset name      | Mounting point    | Options
---               | ---               | ---
`/ROOT/void`      | `/`               | `canmount=noauto, atime=off`

- root_home

Dataset name      | Mounting point    | Options
---               | ---               | ---
`/ROOT/void`      | `/`               | `canmount=noauto, atime=off`
`/home`           | `/home`           | `atime=off`

- max

Dataset name      | Mounting point    | Options
---               | ---               | ---
`/ROOT/void`      | `/`               | `canmount=noauto, atime=off`
`/home`           | `/home`           | `atime=off`
`/opt`            | `/opt`            | `atime=off`
`/srv`            | `/srv`            | `atime=off`
`/tmp`            | `/tmp`            | `com.sun:auto-snapshot=false, atime=off`
`/var`            | `/var`            | `canmount=off, atime=off`
`/var-lib`        | `/var/lib`        | `canmount=off, atime=off`
`/var-cache-xbps` | `/var/cache/xbps` | `com.sun:auto-snapshot=false, atime=off`
`/var-lib-ex`     | `/var/lib/ex`     | `atime=off`
`/var-log`        | `/var/log`        | `atime=off`
`/var-opt`        | `/var/opt`        | `atime=off`
`/var-spool`      | `/var/spool`      | `atime=off`
`/var-tmp`        | `/var/tmp`        | `com.sun:auto-snapshot=false, atime=off`

### All other

- root
    - `/` (size: whole device)
- root_home
    - `/` (size: 20GB)
    - `/home` (size: remainder)

## Default settings

All default settings can be changed via `Common Attrs` sub-menu.

- host-only: no
- installation source: local
- host name: voidpp
- user name: void
- keymap: us
- locale: en_US.UTF-8
- timezone: America/New_York
- LUKS mapping name: crypt
- MBR size: 1M
- ESP size: [550M][550M]
- Boot partition size: 1G
- btrbk: `/mnt/btr_pool`
    - snapshots are created for @, @opt, @var, @srv, and @home subvolumes.
    - btrbk is scheduled to run every day

## Partitioning

### BIOS boot mode

- Limine and Syslinux
    - `/dev/sdX1` is the root filesystem (size: whole device)
- Grub
    - `/dev/sdX1` is the BIOS boot sector (size: 1M)
    - `/dev/sdX2` is the root filesystem (size: remainder)

### UEFI boot mode

- `/dev/sdX1` is the EFI system partition (size: [550M][550M])
- `/dev/sdX2` is the root filesystem (size: remainder)

### F2FS options

- `extra_attr,inode_checksum,sb_checksum,compression,encrypt`

## Dependencies

Name       | Provides                | Included in Void ISO?
---        | ---                     | ---
dialog     | ncurses user input menu | Y
gptfdisk   | GPT disk partitioning with sgdisk | N
lz4        | Extremely Fast Compression algorithm | N
snooze     | cron replacement | N
btrbk      | Tool for creating snapshots | N
grub-btrfs | Add a btrfs snapshots sub-menu to GRUB | N
zfs        | ZFS filesystem | N

## Licensing

This software is released under the GNU GPLv2 license.

## Credits

- [Void Linux](https://voidlinux.org/)
- [Voidvault](https://github.com/atweiden/voidvault)
 
[550M]: https://unix.stackexchange.com/a/722439
[flat layout]: https://btrfs.wiki.kernel.org/index.php/SysadminGuide#Layout
[nodatacow]: https://wiki.archlinux.org/index.php/Btrfs#Disabling_CoW

