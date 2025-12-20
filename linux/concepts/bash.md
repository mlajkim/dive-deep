# Concepts: Bash

<!-- TOC -->

- [Concepts: Bash](#concepts-bash)
  - [How Bash Opens up](#how-bash-opens-up)
    - [`Script File`](#script-file)
      - [Shebang line](#shebang-line)

<!-- /TOC -->

## How Bash Opens up

1. Login
1. Program `bash` opens up
1. Any commands are interpreted by `bash` (So we call `bash` as `shell interpreter`)

Now `Script File` is basically a list of commands that the `shell interpreter (bash)` can understand and execute one by one.

### `Script File`

#### Shebang line

That `#!` is the shebang line, and the following path (`/bin/bash` or `/usr/bin/env bash`) specifies the interpreter that should be used to execute the script.

```sh
#!/bin/bash
```