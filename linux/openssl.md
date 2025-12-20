---
tags:
- 🟡 todo-requires-hands-on-tested
- hands-on-tested
---

# openssl

<!-- TOC -->

- [openssl](#openssl)
  - [Overview](#overview)
  - [Good-to-remember commamnds](#good-to-remember-commamnds)
    - [openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr](#openssl-req--newkey-rsa4096--keyout-privkey--out-certcsr)
    - [create self-signed cert: openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt](#create-self-signed-cert-openssl-req--x509--noenc--days-365--keyout-privkey--out-kodekloudcrt)
    - [ssl is actually old](#ssl-is-actually-old)
  - [man openssl / EXAMPLE](#man-openssl--example)
    - [man openssl-genpkey](#man-openssl-genpkey)
    - [man openssl-x509 | grep -A 40 EXAMPLES](#man-openssl-x509--grep--a-40-examples)
    - [man openssl-req](#man-openssl-req)
      - [man openssl-x509 | grep req](#man-openssl-x509--grep-req)

<!-- /TOC -->

## Overview

> [!TIPS]
> Please use `man openssl` to get more details about the `openssl` command and its subcommands.
> Or you can use `openssl help`

`openssl` creates X.509 cert, private keys and CSRs (certificate signing requests).

## Good-to-remember commamnds

### openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr

> [!NOTE]
>

Creates both a new private key and a certificate signing request (CSR)

```sh
openssl req -newkey rsa:4096 -keyout priv.key -out cert.csr
```

### create self-signed cert: openssl req -x509 -noenc -days 365 -keyout priv.key -out kodekloud.crt

> [!TIP]
> Note that you will be prompted to enter the details for the certificate

```sh
openssl req -x509 -noenc -days 365 -keyout priv.key -out root.crt
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
```


### ssl is actually old

`ssl` has been deprecated and we are living under `tls` but the `ssl` is still being used. Simply speaking you can say `tls = ssl` nowadays.

## man openssl / EXAMPLE

> [!TIP]
> The `EXAMPLE` is the most important section

### man openssl-genpkey

> [!TIP]
> As you can see from the `genkey` description, `genkey` is deprecated and `genpkey` is the new way to generate private keys

```sh
man openssl-genpkey
```

### man openssl-x509 | grep -A 40 EXAMPLES

[!TIP]
> The `Examples` section is pretty useful

It outputs the following sections:

- Name
- Synopsis
- Description
- Options
- Examples


### man openssl-req

#### man openssl-x509 | grep req

> [!TIP]
> You can always expand

```sh
man openssl-x509 | grep req
# ...
# Convert a certificate to a certificate request:
#         openssl x509 -x509toreq -in cert.pem -out req.pem -key key.pem
#        Convert a certificate request into a self-signed certificate using
#         openssl x509 -req -in careq.pem -extfile openssl.cnf -extensions v3_ca \
#        Sign a certificate request using the CA certificate above and add user
#         openssl x509 -req -in req.pem -extfile openssl.cnf -extensions v3_usr \
#        It is possible to produce invalid certificates or requests by
```
