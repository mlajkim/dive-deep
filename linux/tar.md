---
tags:
- hands-on tested
---

# tar

Tape Archive


you call the tar file as `tarball` too.

<!-- TOC -->

- [tar](#tar)
  - [History: Why tar?](#history-why-tar)
  - [Prerequisites](#prerequisites)
  - [tar cf: create a new archive](#tar-cf-create-a-new-archive)
  - [tar tf: list contents of archive](#tar-tf-list-contents-of-archive)
  - [tar rf: append to existing archive](#tar-rf-append-to-existing-archive)
    - [Add the same files again: duplicates are allowed](#add-the-same-files-again-duplicates-are-allowed)
  - [tar xf: extract files from archive](#tar-xf-extract-files-from-archive)

<!-- /TOC -->


## History: Why tar?

The old times when they had to use tape to back up, the tape did not have random access, so they had to write all the files in a single stream. Thus, they created the `tar` command to archive multiple files into a single file.

[[tar]] simply stores files and their metadata into a single file without compression.

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=tar_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

touch file1 file2 file3
mkdir dir1 extracted_dir
touch dir1/file4 dir1/file5

ls -al
# drwxr-xr-x  7 mlajkim  staff  224 Dec 13 04:51 .
# drwxr-xr-x  9 mlajkim  staff  288 Dec 13 04:51 ..
# drwxr-xr-x  4 mlajkim  staff  128 Dec 13 04:51 dir1
# drwxr-xr-x  2 mlajkim  staff   64 Dec 13 04:51 extracted_dir
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file1
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file2
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file3
```


## tar cf: create a new archive

- `c`: create
- `f`: file for archive

```sh
tar cf archive.tar file1 file2
ls -al
# total 8
# drwxr-xr-x  8 ajk  staff   256 Dec 13 04:52 .
# drwxr-xr-x  9 ajk  staff   288 Dec 13 04:51 ..
# -rw-r--r--  1 ajk  staff  2048 Dec 13 04:52 archive.tar
# drwxr-xr-x  4 ajk  staff   128 Dec 13 04:51 dir1
# drwxr-xr-x  2 ajk  staff    64 Dec 13 04:51 extracted_dir
# -rw-r--r--  1 ajk  staff     0 Dec 13 04:51 file1
# -rw-r--r--  1 ajk  staff     0 Dec 13 04:51 file2
# -rw-r--r--  1 ajk  staff     0 Dec 13 04:51 file3
```

## tar tf: list contents of archive

- `t`: list
- `f`: file for archive

```sh
tar tf archive.tar
# file1
# file2
```

## tar rf: append to existing archive

- `r`: append
- `f`: file for archive

```sh
tar rf archive.tar file3 dir1
# file1
# file2
# file3
# dir1/
# dir1/file4
# dir1/file5
```

### Add the same files again: duplicates are allowed

```sh
tar rf archive.tar file3 dir1
tar tf archive.tar
# file1
# file2
# file3
# dir1/
# dir1/file4
# dir1/file5
# file3
# dir1/
# dir1/file4
# dir1/file5
```

## tar xf: extract files from archive

- `x`: extract
- `f`: file for archive
- `C`: Default Current Directory: change to directory

```sh
tar xf archive.tar -C ./extracted_dir
ls -al ./extracted_dir
# total 0
# drwxr-xr-x  6 ajk  staff  192 Dec 13 04:55 .
# drwxr-xr-x  8 ajk  staff  256 Dec 13 04:52 ..
# drwxr-xr-x  4 ajk  staff  128 Dec 13 04:51 dir1
# -rw-r--r--  1 ajk  staff    0 Dec 13 04:51 file1
# -rw-r--r--  1 ajk  staff    0 Dec 13 04:51 file2
# -rw-r--r--  1 ajk  staff    0 Dec 13 04:51 file3
```
