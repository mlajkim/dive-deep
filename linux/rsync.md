---
tags:
- hands-on-tested
---

# rsync

remote sync

<!-- TOC -->

- [rsync](#rsync)
  - [Overview](#overview)
  - [Prerequisites](#prerequisites)
  - [rsync: a fast and versatile file copying tool](#rsync-a-fast-and-versatile-file-copying-tool)
    - [Checks already synced files not copied again](#checks-already-synced-files-not-copied-again)
  - [rsync ssh: remote copy\](#rsync-ssh-remote-copy\)

<!-- /TOC -->

## Overview

`rsync` utilizes SSH for data transfer, with modifying only the parts of files that have changed. This makes it faster than traditional copy methods like `scp` or `cp`, especially for large files or directories with many files.

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=rsync_test
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

mkdir dir1 dir2
touch dir1/file1

ls -al . ./dir1 ./dir2
# .:
# total 0
# drwxr-xr-x   4 ajk  staff  128 Dec 13 07:03 .
# drwxr-xr-x  13 ajk  staff  416 Dec 13 07:03 ..
# drwxr-xr-x   3 ajk  staff   96 Dec 13 07:03 dir1
# drwxr-xr-x   2 ajk  staff   64 Dec 13 07:03 dir2

# ./dir1:
# total 0
# drwxr-xr-x  3 ajk  staff   96 Dec 13 07:03 .
# drwxr-xr-x  4 ajk  staff  128 Dec 13 07:03 ..
# -rw-r--r--  1 ajk  staff    0 Dec 13 07:03 file1

# ./dir2:
# total 0
# drwxr-xr-x  3 ajk  staff   96 Dec 13 07:03 .
# drwxr-xr-x  4 ajk  staff  128 Dec 13 07:03 ..
```

## rsync: a fast and versatile file copying tool

- `-a`: archive mode; it preserves permissions, timestamps, symbolic links, etc.
- `-v`: verbose; it provides detailed information about the transfer process.
- `-z`: compress; it compresses file data during the transfer to reduce the amount of data sent over the network.

We can see `file1` has been copied from `dir1` to `dir2`:

```sh
rsync -avz ./dir1/ ./dir2/
ls -al ./dir2

# Transfer starting: 2 files
# file1

# sent 142 bytes  received 42 bytes  87619 bytes/sec
# total size is 0  speedup is 0.00

# total 0
# drwxr-xr-x  3 ajk  staff   96 Dec 13 07:03 .
# drwxr-xr-x  4 ajk  staff  128 Dec 13 07:03 ..
# -rw-r--r--  1 ajk  staff    0 Dec 13 07:03 file1
```

### Checks already synced files not copied again

Note that `file1` has not been included as it is already synced:

```sh
touch dir1/file2
rsync -avz ./dir1/ ./dir2/
ls -al ./dir2

# Transfer starting: 3 files
# ./
# file2

# sent 178 bytes  received 48 bytes  205454 bytes/sec
# total size is 0  speedup is 0.00
# total 0
# drwxr-xr-x  4 ajk  staff  128 Dec 13 07:07 .
# drwxr-xr-x  4 ajk  staff  128 Dec 13 07:03 ..
# -rw-r--r--  1 ajk  staff    0 Dec 13 07:03 file1
# -rw-r--r--  1 ajk  staff    0 Dec 13 07:07 file2
```

## rsync ssh: remote copy\

> [!NOTE]
> The following example is commented out as it requires a remote server setup & has not been tested.

```sh
# rsync -avz -e ssh source_dir/ user@remote:/dest_dir/
```