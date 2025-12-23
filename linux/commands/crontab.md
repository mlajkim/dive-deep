---
tags:
- hands-on-tested
---

# crontab

<!-- TOC -->

- [crontab](#crontab)
  - [Overview](#overview)
  - [crontab -l -u bob: List the cron jobs of the current user](#crontab--l--u-bob-list-the-cron-jobs-of-the-current-user)
  - [crontab -e -u bob](#crontab--e--u-bob)

<!-- /TOC -->


## Overview

For more advanced one, check out [Anacron](./anacron.md).


## crontab -l -u bob: List the cron jobs of the current user

> [!TIP]
> you can run with `sudo` to see root's cron jobs

```sh
crontab -l -u bob
```

## crontab -e -u bob

Edit the cron jobs of the current user

```sh
crontab -e -u bob
# no crontab for root - using an empty one

# Select an editor.  To change later, run 'select-editor'.
#   1. /bin/nano        <---- easiest
#   2. /usr/bin/vim.basic

Choose 1-2 [1]: 2
# crontab: installing new crontab
```