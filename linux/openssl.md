---
tags:
- hands-on-tested
---

# openssl

<!-- TOC -->

- [openssl](#openssl)
  - [Overview](#overview)
    - [ssl is actually old](#ssl-is-actually-old)
  - [Prerequisites](#prerequisites)
  - [Good-to-remember commamnds](#good-to-remember-commamnds)
    - [openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr](#openssl-req--newkey-rsa4096--keyout-privkey--out-certcsr)
    - [create self-signed cert: openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt](#create-self-signed-cert-openssl-req--x509--noenc--days-365--keyout-privkey--out-kodekloudcrt)

<!-- /TOC -->

## Overview

> [!TIPS]
> Please use `man openssl` to get more details about the `openssl` command and its subcommands.
> Or you can use `openssl help`

`openssl` creates X.509 cert, private keys and CSRs (certificate signing requests).

### ssl is actually old

`ssl` has been deprecated and we are living under `tls` but the `ssl` is still being used. Simply speaking you can say `tls = ssl` nowadays.

## Prerequisites

Here is the prerequisite setup for the following examples:

```sh
test_name=openssl
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

echo "Target Acquired" > existing_file
ls -al existing_file ghost_file
# ls: ghost_file: No such file or directory
# -rw-r--r--  1 ajk  staff  16 Dec 15 12:27 existing_file
```


## Good-to-remember commamnds

### openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

> [!NOTE]
>

Creates both a new private key and a certificate signing request (CSR)

```sh
openssl req -newkey rsa:4096 -keyout private.key -out cert.csr > /dev/null
ls -al
# total 0
# drwxr-xr-x  3 mlajkim  staff   96 Dec 19 12:11 .
# drwxr-xr-x  6 mlajkim  staff  192 Dec 19 12:11 ..
# -rw-------  1 mlajkim  staff    0 Dec 19 12:11 private.key
```

### create self-signed cert: openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt

> [!TIP]
> Note that you will be prompted to enter the details for the certificate

```sh
openssl req -x509 -noenc -days 365 -keyout private.key -out root.crt
ls -al root.crt
# ....+.....+...+....+..................+......+.....+.+...........+....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*......+.....+..........+.........+.....+.......+.....+.+...+..+.............+..+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*..+.......+......+...........+.+..+.......+......+........+.......+..+......+............+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ....+...................+...+.....+............+...+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*......+....+..+.........+.........+.......+.....+...+....+..+...+.......+...+............+...+..................+.........+.....+.+...+..+.......+...+.........+...........+...+.........+..........+..+....+......+........+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*....+.................+.........+...+.+.....+..........+...........+......+...+..........+..+.........+.+.....+....+..................+......+.....+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# -----
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) [AU]:
# State or Province Name (full name) [Some-State]:
# Locality Name (eg, city) []:
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:
# Organizational Unit Name (eg, section) []:
# Common Name (e.g. server FQDN or YOUR name) []:kodekloud.com
# Email Address []:
# -rw-r--r--  1 mlajkim  staff  1245 Dec 19 12:12 root.crt
```




