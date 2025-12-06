# less

<!-- TOC -->

- [less](#less)
  - [Setup](#setup)
  - [Flags: Core](#flags-core)
  - [Flags: Searching](#flags-searching)
  - [Default Configuration](#default-configuration)

<!-- /TOC -->

## Setup


We will use the following file to test out `less`:

```sh
less /etc/services
```

## Flags: Core

Here are some useful flags for `less`:
- `-N`: Show line numbers
- `-i`: Ignore case when searching
- `-I`: Ignore case when searching unless uppercase is used
- `-x4`: Set tab stops every 4 spaces
- `-S`: Chop long lines rather than wrapping
- `=`: Show file information: i.e) `/etc/services lines 430-461/13926 byte 23961/678260 4%  (press RETURN)`

## Flags: Searching
- `n`: Next search result
- `shift + n`, or `N`: Previous search result

## Default Configuration

Add the following environment variable to your shell configuration to optimize defaults in `.zshrc`:

```sh
export LESS="-R -I -x4 -S"
```