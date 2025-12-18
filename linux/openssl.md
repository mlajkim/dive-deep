# openssl

<!-- TOC -->

- [openssl](#openssl)
  - [Overview](#overview)
    - [ssl is actually old](#ssl-is-actually-old)
  - [man openssl / EXAMPLE](#man-openssl--example)
    - [man openssl-genpkey](#man-openssl-genpkey)
    - [man openssl-x509 | grep -A 40 EXAMPLES](#man-openssl-x509--grep--a-40-examples)
    - [man openssl-req](#man-openssl-req)
      - [man openssl-x509 | grep req](#man-openssl-x509--grep-req)

<!-- /TOC -->

## Overview


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

