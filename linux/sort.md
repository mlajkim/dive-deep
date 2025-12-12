# sort

<!-- TOC -->

- [sort](#sort)
  - [Overview: sort](#overview-sort)
  - [Prerequisites](#prerequisites)
  - [sort: text file](#sort-text-file)
    - [sort: does not change original file](#sort-does-not-change-original-file)

<!-- /TOC -->


## Overview: sort

`sort` simply sorts lines of text files.

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=sort_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

cat > file.txt <<EOF
john uk
amy korea
michael usa
sara canada
john uk
EOF

cat file.txt
# drwxr-xr-x  7 mlajkim  staff  224 Dec 13 04:51 .
# drwxr-xr-x  9 mlajkim  staff  288 Dec 13 04:51 ..
# drwxr-xr-x  4 mlajkim  staff  128 Dec 13 04:51 dir1
# drwxr-xr-x  2 mlajkim  staff   64 Dec 13 04:51 extracted_dir
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file1
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file2
# -rw-r--r--  1 mlajkim  staff    0 Dec 13 04:51 file3
```


## sort: text file

You can sort file text directly:

```sh
sort file.txt
# amy korea
# john uk
# john uk
# michael usa
# sara canada
```

### sort: does not change original file

```sh
cat file.txt
# john uk
# amy korea
# michael usa
# sara canada
# john uk
```
