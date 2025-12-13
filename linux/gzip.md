---
tags:
- hands-on-tested
---

# gzip

<!-- TOC -->

- [gzip](#gzip)
  - [Prerequisites](#prerequisites)
  - [gzip: compress files](#gzip-compress-files)
    - [gzip cannot compress directories](#gzip-cannot-compress-directories)
  - [gzip -l: list compressed files](#gzip--l-list-compressed-files)
  - [gunzip: decompress files](#gunzip-decompress-files)
    - [unzip on .gz files: returns error](#unzip-on-gz-files-returns-error)
  - [gzip -k: keep original files](#gzip--k-keep-original-files)
  - [gzip -h: get help](#gzip--h-get-help)

<!-- /TOC -->

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=gzip_test
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

cat > file1 <<EOF
She would have done anything then, as Nancy and George walked down the aisle together, to join the side of sweetness, certainty and innocence, knowing she could begin her life without feeling that she had done something foolish and hurtful. No matter what she decided, she thought, there would not be a way to avoid the consequences of what she had done, or what she might do now. It occurred to her, as she walked down the aisle with Jim and her mother and joined the well-wishers outside the church, where the weather had brightened, that she was sure that she did not love Tony now. He seemed part of a dream from which she had woken with considerable force some time before, and in this waking time his presence, once so solid, lacked any substance or form; it was merely a shadow at the edge of every moment of the day and night.
EOF

cat > file2 <<EOF
During the first part of your life, you only become aware of happiness once you have lost it. Then an age comes, a second one, in which you already know, at the moment when you begin to experience true happiness, that you are, at the end of the day, going to lose it. When I met Belle, I understood that I had just entered this second age. I also understood that I hadn’t reached the third age, in which anticipation of the loss of happiness prevents you from living.
EOF

touch file3

mkdir dir1

ls -al
# total 16
# drwxr-xr-x   5 ajk  staff  160 Dec 13 05:45 .
# drwxr-xr-x  12 ajk  staff  384 Dec 13 05:45 ..
# drwxr-xr-x   2 ajk  staff   64 Dec 13 05:45 dir1
# -rw-r--r--   1 ajk  staff  835 Dec 13 05:45 file1
# -rw-r--r--   1 ajk  staff  470 Dec 13 05:45 file2
# -rw-r--r--   1 ajk  staff    0 Dec 13 05:45 file3
```


## gzip: compress files

> [!NOTE]
> To compress as one, you need to archive first using the [[tar]] command. To see more, please check [tar](/linux/tar).

Note that:
- `gzip` deletes original files after compression
- `gzip` does not compress directories
- `gzip` creates individual `.gz` files for each input file

```sh
gzip file1 file2 file 3
ls -al
# total 16
# total 24
# drwxr-xr-x   6 ajk  staff  192 Dec 13 05:47 .
# drwxr-xr-x  12 ajk  staff  384 Dec 13 05:45 ..
# drwxr-xr-x   2 ajk  staff   64 Dec 13 05:45 dir1
# -rw-r--r--   1 ajk  staff  464 Dec 13 05:45 file1.gz
# -rw-r--r--   1 ajk  staff  291 Dec 13 05:45 file2.gz
# -rw-r--r--   1 ajk  staff   26 Dec 13 05:45 file3.gz
```

### gzip cannot compress directories

```sh
gzip dir1
# gzip: dir1: Is a directory
```

## gzip -l: list compressed files

> [!NOTE]
> Note that the reason why it is negative ratio for `file3.gz` is because the original file is empty, and gzip adds some metadata (`26 bytes`) to create the compressed file.

You can list how well files are compressed using `gzip -l`, about 40% for files bigger than `26 bytes`:

```sh
gzip -l file1.gz file2.gz file3.gz
  # compressed uncompressed  ratio uncompressed_name
  #        464          835  44.4% file1
  #        291          470  38.2% file2
  #         26            0 -99.9% file3
  #        781         1305  40.2% (totals)
```

## gunzip: decompress files

```sh
gunzip file1.gz
ls -al
# total 24
# drwxr-xr-x   6 ajk  staff  192 Dec 13 05:49 .
# drwxr-xr-x  12 ajk  staff  384 Dec 13 05:45 ..
# drwxr-xr-x   2 ajk  staff   64 Dec 13 05:45 dir1
# -rw-r--r--   1 ajk  staff  835 Dec 13 05:45 file1
# -rw-r--r--   1 ajk  staff  291 Dec 13 05:45 file2.gz
# -rw-r--r--   1 ajk  staff   26 Dec 13 05:45 file3.gz
```

### unzip on .gz files: returns error

```sh
unzip file1.gz
# Archive:  file1.gz
#   End-of-central-directory signature not found.  Either this file is not
#   a zipfile, or it constitutes one disk of a multi-part archive.  In the
#   latter case the central directory and zipfile comment will be found on
#   the last disk(s) of this archive.
# unzip:  cannot find zipfile directory in one of file1.gz or
#         file1.gz.zip, and cannot find file1.gz.ZIP, period.
```

## gzip -k: keep original files

By default without `-k`, `gzip` removes the original files after compression.

We can see that both original and compressed files exist after using `gzip -k`:

```sh
gzip -k file1
ls -al | grep file1
# -rw-r--r--   1 ajk  staff  835 Dec 13 05:45 file1
# -rw-r--r--   1 ajk  staff  464 Dec 13 05:45 file1.gz
```

## gzip -h: get help

Pretty helpful:

```sh
gzip -h
# Apple gzip 457.140.3
# usage: gzip [-123456789acdfhklLNnqrtVv] [-S .suffix] [<file> [<file> ...]]
#  -1 --fast            fastest (worst) compression
#  -2 .. -8             set compression level
#  -9 --best            best (slowest) compression
#  -c --stdout          write to stdout, keep original files
#     --to-stdout
#  -d --decompress      uncompress files
#     --uncompress
#  -f --force           force overwriting & compress links
#  -h --help            display this help
#  -k --keep            don't delete input files during operation
#  -l --list            list compressed file contents
#  -N --name            save or restore original file name and time stamp
#  -n --no-name         don't save original file name or time stamp
#  -q --quiet           output no warnings
#  -r --recursive       recursively compress files in directories
#  -S .suf              use suffix .suf instead of .gz
#     --suffix .suf
#  -t --test            test compressed file
#  -V --version         display program version
#  -v --verbose         print extra statistics
```