# tar

Tape Archive


you call the tar file as `tarball` too.

<!-- TOC -->

- [tar](#tar)
  - [History: Why tar?](#history-why-tar)
  - [tar cf: create a new archive](#tar-cf-create-a-new-archive)
  - [tar rf: append to existing archive](#tar-rf-append-to-existing-archive)
  - [tar tf: list contents of archive](#tar-tf-list-contents-of-archive)
  - [tar xf: extract files from archive](#tar-xf-extract-files-from-archive)

<!-- /TOC -->


## History: Why tar?

The old times when they had to use tape to back up, the tape did not have random access, so they had to write all the files in a single stream. Thus, they created the `tar` command to archive multiple files into a single file.

[[tar]] simply stores files and their metadata into a single file without compression.


## tar cf: create a new archive

- `c`: create
- `f`: file for archive

```sh
tar cf archive.tar file1 file2 dir1
```

## tar rf: append to existing archive

- `r`: append
- `f`: file for archive

```sh
tar rf archive.tar file3 dir2
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
tar xf archive.tar -C /path/to/extract/
```
