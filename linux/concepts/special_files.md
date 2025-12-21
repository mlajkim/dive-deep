# Special Files in Linux

<!-- TOC -->

- [Special Files in Linux](#special-files-in-linux)
  - [/dev/null](#devnull)
  - [/etc/default/grub](#etcdefaultgrub)
  - [/etc/systemd/system/](#etcsystemdsystem)
  - [/proc/version](#procversion)

<!-- /TOC -->

## /dev/null

This file is a special device file that discards all data written to it. It is often referred to as the "bit bucket" or "black hole" because any data sent to it is effectively deleted.

Command `ls -al not_exist_file_for_sure` should produce an error message like this, but since its error message is redirected to `/dev/null`, there will be no output, and you won't find it in the `/dev/null` as well.

```sh
ls -al not_exist_file_for_sure 2>/dev/null
cat /dev/null
# <nothing shows>
```

## /etc/default/grub

`grub` (or GRand Unified Bootloader) is a boot loader package that supports multiple operating systems on a computer. The `/etc/default/grub` file contains configuration settings for GRUB.

- `GRUB_TIMEOUT=0`: This setting specifies the time (in seconds) that GRUB will wait before automatically booting the default operating system. A value of `0` means that GRUB will not wait and will immediately boot the default OS without displaying the menu.


```sh
cat grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0  security=selinux"

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal (grub-pc only)
#GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
```

## /etc/systemd/system/

Any custom (/etc) unit files to overwrite the default/factory (/lib) unit files are stored in this directory. Please note `systemd` runs the `/etc/` first before `/lib/`, with it defined by its file name.

> [!TIP]
> If you want to add/override certain config, you can add `.d` directory inside `/etc/systemd/system/` with the same service name. For example, to override `nginx.service`, you can create `/etc/systemd/system/nginx.service.d/` directory and add your custom config with mandatory extension `.conf` inside it.

- First Priority: `/etc/systemd/system/nginx.service`
- Second Priority: `/run/systemd/system/nginx.service`
- Third Priority (The Factory): `/lib/systemd/system/nginx.service`

## /proc/version

> [!TIP]
> `proc` stands for "process".

This file contains:
- The Linux kernel version
- The version of GCC used to compile the kernel
- The build date and time of the kernel
- The architecture for which the kernel was built

```sh
cat /proc/version
# Linux version 5.15.0-122-generic (buildd@lcy02-amd64-034) (gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0, GNU ld (GNU Binutils for Ubuntu) 2.38) #132-Ubuntu SMP Thu Aug 29 13:45:52 UTC 2024
```