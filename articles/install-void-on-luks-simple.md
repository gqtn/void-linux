# LUKS Encrypted Void Linux install

[Download Void Linux ISO](https://voidlinux.org/download/) and write to a USB Flash Drive (or DVD) and boot from it.

You can connect to internet and install `gparted` (`sudo xbps-install gparted`), or use cli tools like `cfdisk` for partitioning. Now create a boot partition, preferably 1GB or at least 512MB. (Because Void Linux does not delete the old kernel files from /boot when new kernel is installed. We'll have to clean up the old kernel version files more often if we have a smaller partition.) I keep it in ext2, because I've heard some problems with ext4. But [people say](https://superuser.com/questions/470688/why-100mb-ext2-boot-partition-recommended-for-linux) ext4 should be ok to use with modern distros.

We'll have to have a separate boot partition because encrypted boot partition cannot be read by GRUB. But Note: [it is possible to install with encrypted boot](http://www.unixsheikh.com/tutorials/real-full-disk-encryption-using-grub-on-void-linux-for-bios.html).

In this article we will use a simple structure for our LUKS setup without a volume group.


## Creating LUKS drive and mounting

```
sudo -s
modprobe dm-crypt
modprobe dm-mod
cryptsetup luksFormat -v -s 512 -h sha512 /dev/sdx3
cryptsetup open /dev/sdx3 void_root
mkfs.ext4 -L root /dev/mapper/void_root
mount /dev/mapper/void_root /mnt
```


## Mounting /boot

```
mkdir -p /mnt/boot
mount /dev/sdx1 /mnt/boot
```
_* assuming `/dev/sdx1` is your boot drive_


## Chrooting into the drive

```
for dir in dev proc sys; do
>mkdir /mnt/$dir
>mount --rbind /$dir /mnt/$dir
>done
```

or

```
mount --rbind /dev /mnt/dev
mount --rbind /proc /mnt/proc
mount --rbind /sys /mnt/sys
```

We are ready to `chroot`. But before that, install a base system of Void Linux:

```
xbps-install -Sy -R https://alpha.de.repo.voidlinux.org/current -r /mnt base-system lvm2 cryptsetup grub os-prober nano
```

You can change it to the mirror that is closest to you. e.g.:

```
xbps-install -Sy -R https://void.webconverger.org/current -r /mnt base-system lvm2 cryptsetup grub os-prober nano
```

Consult the [Download](http://www.voidlinux.org/download/) page for mirrors. I had to try twice because the mirror above was not responding for some reason the first time. But second time was fine.

This will download and install all of the required packages. Overview of flags:

```
-S -- used to force xbps to update from the repository rather than relying on local package cache

-y -- automatically answer "yes" to all questions

-R -- specify a particular repository url

-r -- specify a non-standard root directory (we need to use this to tell xbps to install packages in /mnt. Without this option we'd install all the packages to our live system, which isn't what we want.)
```

Now chroot into the new system:
```
chroot /mnt /bin/bash
```

Now you can access the new Void Linux installation to continue with the setup.


## Initial Setup

Set the root password:
```
passwd root
```

Set ownership and permissions for the root directory:
```
chown root:root /
chmod 755 /
```

Set the machine's hostname using
```
echo <your-hostname> > /etc/hostname.
```

Now edit your /etc/fstab:
```
xbps-install -Sy nano
nano /etc/fstab
```

A typical fstab would look like:
```
# <file system>	  <dir> <type>  <options>             <dump>  <pass>
tmpfs             /tmp  tmpfs   defaults,nosuid,nodev 0       0
UUID=b82bbadd-f33a-45b1-ba84-e665183dc707         /     ext4    defaults              0       0
UUID=e803d7a5-999e-46e0-af02-3d8938df4106         /boot ext2    defaults              0       0
```

Or with dev id (not recommended):
```
# <file system>	  <dir> <type>  <options>             <dump>  <pass>
tmpfs             /tmp  tmpfs   defaults,nosuid,nodev 0       0
/dev/sda2         /     ext4    defaults              0       0
/dev/sda1         /boot ext2    defaults              0       0
```

grub-install /dev/sda

```
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "en_US.UTF-8 UTF-8" >> /etc/default/libc-locales
xbps-reconfigure -f glibc-locales
```

Now run:
```
nano /etc/default/grub
```

Find the `GRUB_CMDLINE_LINUX` line and set it with UUID. Run `sudo blkid` or `sudo cryptsetup luksDump /dev/sdx3` then use the UUID of the `/dev/mapper/void_root` like this:
```
GRUB_CMDLINE_LINUX="rd.luks.uuid=529ab394-4abc-4a1u-9cd9-1864a1b7j6k9"
```

Add this also:
`GRUB_ENABLE_CRYPTODISK=y`

Look for `rd.auto=1` in either `GRUB_CMDLINE_LINUX` or `GRUB_CMDLINE_LINUX_DEFAULT` and probably remove it, because it asks for passwords for all the LUKS encrypted drive passwords even if you are not accessing all of them to boot. This is described as a shortcut on the [original wiki](https://wiki.voidlinux.org/Install_LVM_LUKS), but is an annoying thing.

* To see installed linux kernels `xbps-query --regex -Rs '^linux[0-9.]+-[0-9._]+'`

Now run this to create linux image and update grub config:
```
xbps-reconfigure -f linux4.19
```


## Finishing things up

Install `dhcpcd` or `NetworkManager` so that you can connect to internet. I personally like NetworkManager because it is easier to use wifi. We also need to enable `dbus` service, because without it, `nmcli` returns a `could not create nmclient object` error. So:
```
xbps-install NetworkManager
ln -s /etc/sv/dbus/ /var/service/
ln -s /etc/sv/NetworkManager/ /var/service/
```

With this, you can use the `nmcli` commands as normal.

Then `exit` and `umount -R /mnt`. Now reboot and boot to your new LUKS encrypted Void linux!


## Troubleshooting LUKS

If you can't boot into your new linux, it is possible that your UUID is wrong or something else. If this is a problem you face, check out [this page](https://fedoraproject.org/wiki/How_to_debug_Dracut_problems).

**Ref:**

- https://wiki.voidlinux.org/Install_LVM_LUKS

- https://docs.voidlinux.org/print.html

- https://docs.voidlinux.org/config/kernel.html

- https://wiki.gentoo.org/wiki/Dracut#LVM_on_LUKS

- http://people.redhat.com/harald/dracut.html

- https://bugzilla.redhat.com/show_bug.cgi?id=598602#c4










