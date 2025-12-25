# sysctl

<!-- TOC -->

- [sysctl](#sysctl)
  - [Overview](#overview)
  - [sysctl -a](#sysctl--a)
  - [sysctl -w net.ipv4.ip_forward=1](#sysctl--w-netipv4ip_forward1)
  - [vi /etc/sysctl.d/<any_name>.conf: persistent configuration](#vi-etcsysctldany_nameconf-persistent-configuration)
    - [sysctl -p /etc/sysctl.d/<any_name>.conf](#sysctl--p-etcsysctldany_nameconf)
  - [man sysctl](#man-sysctl)

<!-- /TOC -->


## Overview

The `sysctl` utility retrieves kernel state and allows processes with appropriate privilege to set kernel state.

## sysctl -a

## sysctl -w net.ipv4.ip_forward=1

> [!TIP]
> This is not persistent across reboots! To make it persistent, add or modify the following line in `/etc/sysctl.d/<any_name>.conf`:

- `1`: true
- `0`: false


## vi /etc/sysctl.d/<any_name>.conf: persistent configuration

```sh
net.ipv4.ip_forward=1
```

### sysctl -p /etc/sysctl.d/<any_name>.conf

Reloads the configuration right now instead of rebooting, with `-p` as `permanent`.

## man sysctl
