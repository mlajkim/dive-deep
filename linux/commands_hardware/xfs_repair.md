---
tags:
- hands-on-tested
---

# xfs_repair

<!-- TOC -->

- [xfs_repair](#xfs_repair)
  - [Overview](#overview)
  - [xfs_repair -v /dev/vdb1](#xfs_repair--v-devvdb1)

<!-- /TOC -->

## Overview

> [!TIP]
> First do the [df](df.md) to get the info

xfs stands for `extended file system` and is for `Ubuntu` systems


## xfs_repair -v /dev/vdb1

- `-v`: verbose mode
- `-n`: dry run, no changes made

```sh
sudo xfs_repair -n /dev/vdb
# Phase 1 - find and verify superblock...
# Phase 2 - using internal log
#         - zero log...
#         - scan filesystem freespace and inode maps...
#         - found root inode chunk
# Phase 3 - for each AG...
#         - scan (but don't clear) agi unlinked lists...
#         - process known inodes and perform inode discovery...
#         - agno = 0
#         - agno = 1
#         - agno = 2
#         - agno = 3
#         - process newly discovered inodes...
# Phase 4 - check for duplicate blocks...
#         - setting up duplicate extent list...
#         - check for inodes claiming duplicate blocks...
#         - agno = 0
#         - agno = 1
#         - agno = 2
#         - agno = 3
# No modify flag set, skipping phase 5
# Phase 6 - check inode connectivity...
#         - traversing filesystem ...
#         - traversal finished ...
#         - moving disconnected inodes to lost+found ...
# Phase 7 - verify link counts...
# No modify flag set, skipping filesystem flush and exiting.
```