# ls

<!-- TOC -->

- [ls](#ls)
    - [ls --full-time: Show detailed list with full timestamp information](#ls---full-time-show-detailed-list-with-full-timestamp-information)
  - [ls -Z](#ls--z)

<!-- /TOC -->

### ls --full-time: Show detailed list with full timestamp information

```sh
bob@ubuntu-host ~ ➜  ls --full-time
# total 28
# drwxr-xr-x 2 bob  bob  4096 2025-11-30 03:34:51.257802989 +0000 data
# drwxr-xr-x 2 root root 4096 2025-11-30 03:28:49.777370985 +0000 Documents
# -rw-r--r-- 2 bob  bob     0 2025-11-30 03:59:18.399808495 +0000 hlink
# -rw-r--r-- 1 root root    0 2015-12-18 01:30:09.000000000 +0000 important_file
# drwxr-xr-x 3 bob  bob  4096 2025-11-30 03:30:25.150540329 +0000 Invoice
# lrwxrwxrwx 1 bob  bob     4 2025-11-30 03:50:08.113054525 +0000 link_to_temp -> /tmp
# lrwxrwxrwx 1 bob  bob     4 2025-11-30 03:51:18.053912227 +0000 link_to_tmp -> /tmp
# -rw-r--r-- 1 bob  bob     0 2025-11-30 03:27:59.768757844 +0000 myfile.txt
# drwxr-xr-x 5 bob  bob  4096 2025-11-30 03:43:54.904476755 +0000 new-data
# drwxrwxr-x 5 bob  bob  4096 2025-11-30 03:42:59.499796494 +0000 old-data
# -rw-r--r-- 1 root root   28 2025-11-30 04:01:58.577775236 +0000 old_file
# drwxrwxr-x 2 bob  bob  4096 2025-11-30 03:44:14.780720796 +0000 test
```

## ls -Z

> [!TIP]
> Learn more about SELinux context in [./concepts/selinux.md](./concepts/selinux.md)


```sh
ls -Z
```