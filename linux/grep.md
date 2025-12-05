# grep

> ![NOTE]
> grep is to search texts. If you want to search files instead, please check out [[find]] command.

<!-- TOC -->

- [grep](#grep)
  - [Setup](#setup)
  - [Search file contents recursively](#search-file-contents-recursively)

<!-- /TOC -->


## Setup


## Search file contents recursively

Search through files recursively `-r` for the case-insensitive `-i` word "password" in `/etc/` directory:
```sh
grep -ir 'password' /etc/
```