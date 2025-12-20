# Special Files in Linux

<!-- TOC -->

- [Special Files in Linux](#special-files-in-linux)
  - [/prod/version](#prodversion)

<!-- /TOC -->

## /prod/version

This file contains:
- The Linux kernel version
- The version of GCC used to compile the kernel
- The build date and time of the kernel
- The architecture for which the kernel was built

```sh
cat /proc/version
```