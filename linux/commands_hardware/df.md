# df

<!-- TOC -->

- [df](#df)
  - [Overview](#overview)
  - [df -h](#df--h)

<!-- /TOC -->

## Overview

> [!TIP]
> - For the memory usage command, see [free](free.md).
> - For the CPU usage command, see [uptime](uptime.md)

df = `disk free`

## df -h

We can see that `/` (root) uses 13% of 30G disk space:

```sh
df -h
# Filesystem      Size  Used Avail Use% Mounted on
# tmpfs            96M  2.2M   94M   3% /run
# /dev/vda1        30G  3.5G   25G  13% /
# tmpfs           479M     0  479M   0% /dev/shm
# tmpfs           5.0M     0  5.0M   0% /run/lock
# tmpfs            96M     0   96M   0% /run/user/0
```
