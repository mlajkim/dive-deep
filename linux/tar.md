# tar

Tape Archive


you call the tar file as `tarball` too.

<!-- TOC -->

- [tar](#tar)
  - [History: Why tar?](#history-why-tar)
  - [Prerequisites](#prerequisites)
  - [tar cf: create a new archive](#tar-cf-create-a-new-archive)
  - [tar rf: append to existing archive](#tar-rf-append-to-existing-archive)
  - [tar tf: list contents of archive](#tar-tf-list-contents-of-archive)
  - [tar xf: extract files from archive](#tar-xf-extract-files-from-archive)

<!-- /TOC -->


## History: Why tar?

The old times when they had to use tape to back up, the tape did not have random access, so they had to write all the files in a single stream. Thus, they created the `tar` command to archive multiple files into a single file.

[[tar]] simply stores files and their metadata into a single file without compression.

## Prerequisites

Setup:
```sh
test_name=tar_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

touch file1 file2 file3
mkdir dir1 extracted_dir
touch dir1/file4 dir1/file5

```


## tar cf: create a new archive

- `c`: create
- `f`: file for archive

```sh
tar cf archive.tar file1 file2
```

## tar rf: append to existing archive

- `r`: append
- `f`: file for archive

```sh
tar rf archive.tar file3 dir1
```

## tar tf: list contents of archive

- `t`: list
- `f`: file for archive

```sh
tar tf archive.tar
```


## tar xf: extract files from archive

- `x`: extract
- `f`: file for archive
- `C`: change to directory

```sh
tar xf archive.tar
tar xf archive.tar -C ./extracted_dir
```
