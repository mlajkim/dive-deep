# gzip

<!-- TOC -->

- [gzip](#gzip)
  - [gzip: compress files](#gzip-compress-files)
  - [gzip -l: list compressed files](#gzip--l-list-compressed-files)
  - [unzip: decompress files](#unzip-decompress-files)
  - [gzip -k: keep original files](#gzip--k-keep-original-files)
  - [gzip -h: get help](#gzip--h-get-help)

<!-- /TOC -->


## gzip: compress files

```sh
gzip file1 fil2
```

## gzip -l: list compressed files

```sh
gzip -l file1.gz file2.gz
```

## unzip: decompress files

```sh
unzip file1.gz file2.gz
```

## gzip -k: keep original files

By default without `-k`, `gzip` removes the original files after compression.

```sh
gzip -k file1 file2
```

## gzip -h: get help

```sh
gzip -h
```