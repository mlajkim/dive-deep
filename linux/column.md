---
tags:
- hands-on-tested
---

# column

<!-- TOC -->

- [column](#column)
  - [Prerequisites](#prerequisites)
  - [column](#column-1)
  - [column -t -s server_stats.txt](#column--t--s-server_statstxt)

<!-- /TOC -->

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=column_test
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

cat > server_stats.txt <<EOF
Server,CPU,RAM
db-master,85,64
web-01,15,32
api-server,45,16
cache-01,5,8
backup-svr,90,128
web-02,12,32
EOF

cat server_stats.txt
# Server,CPU,RAM
# db-master,85,64
# web-01,15,32
# api-server,45,16
# cache-01,5,8
# backup-svr,90,128
# web-02,12,32
```


## column

Note that how it formats the output, just like `ls` does:

```sh
column server_stats.txt
Server,CPU,RAM		web-01,15,32		cache-01,5,8		web-02,12,32
db-master,85,64		api-server,45,16	backup-svr,90,128
```

## column -t -s server_stats.txt

- `-t`: creates a table
- `-s`: specifies the delimiter (in this case, a `comma`)

```sh
column -t -s "," server_stats.txt
# Server      CPU  RAM
# db-master   85   64
# web-01      15   32
# api-server  45   16
# cache-01    5    8
# backup-svr  90   128
# web-02      12   32
```