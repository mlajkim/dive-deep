# Special Files in Linux

<!-- TOC -->

- [Special Files in Linux](#special-files-in-linux)
  - [/dev/null](#devnull)
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