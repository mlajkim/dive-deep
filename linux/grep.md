# grep

> ![NOTE]
> grep is to search texts. If you want to search files instead, please check out [[find]] command.

<!-- TOC -->

- [grep](#grep)
  - [Setup](#setup)
  - [Search file contents recursively](#search-file-contents-recursively)
  - [You can exclude lines matching a pattern using `-v` flag](#you-can-exclude-lines-matching-a-pattern-using--v-flag)

<!-- /TOC -->


## Setup


## Search file contents recursively

Search through files recursively `-r` for the case-insensitive `-i` word "password" in `/etc/` directory:
```sh
grep -ir 'password' /etc/
```


## You can exclude lines matching a pattern using `-v` flag

```sh
grep -v 'pattern' file.txt  # Exclude lines matching 'pattern'
```