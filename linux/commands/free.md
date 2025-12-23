---
tags:
- hands-on-tested
---

# free

<!-- TOC -->

- [free](#free)
  - [Overview](#overview)
  - [free -h](#free--h)
    - [free --mega: see in megabytes](#free---mega-see-in-megabytes)
  - [free --help: helps you output the unit you want](#free---help-helps-you-output-the-unit-you-want)

<!-- /TOC -->

## Overview

> [!TIP]
> - For the disk usage command, see [df](df.md).
> - For the CPU usage command, see [uptime](uptime.md)

## free -h


Here is a quick info:
- `Mem`: Actual physical memory
- `Swap`: Virtual memory on disk
- Total Memory: 1003 MB
- Used Memory: 200 MB
- Free Memory: 565 MB


```sh
free -h
#                total        used        free      shared  buff/cache   available
# Mem:           957Mi       191Mi       539Mi       3.0Mi       226Mi       617Mi
# Swap:          2.0Gi          0B       2.0G
```

### free --mega: see in megabytes

```sh
free --mega
#                total        used        free      shared  buff/cache   available
# Mem:            1003         200         565           3         237         647
# Swap:           2147           0        2147
```


## free --help: helps you output the unit you want

```sh
free --help

# Usage:
#  free [options]

# Options:
#  -b, --bytes         show output in bytes
#      --kilo          show output in kilobytes
#      --mega          show output in megabytes
#      --giga          show output in gigabytes
#      --tera          show output in terabytes
#      --peta          show output in petabytes
#  -k, --kibi          show output in kibibytes
#  -m, --mebi          show output in mebibytes
#  -g, --gibi          show output in gibibytes
#      --tebi          show output in tebibytes
#      --pebi          show output in pebibytes
#  -h, --human         show human-readable output
#      --si            use powers of 1000 not 1024
#  -l, --lohi          show detailed low and high memory statistics
#  -t, --total         show total for RAM + swap
#  -s N, --seconds N   repeat printing every N seconds
#  -c N, --count N     repeat printing N times, then exit
#  -w, --wide          wide output

#      --help     display this help and exit
#  -V, --version  output version information and exit

# For more details see free(1).
```