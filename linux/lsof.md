---
tags:
- hands-on-tested
---

# lsof

<!-- TOC -->

- [lsof](#lsof)
  - [Prerequisites](#prerequisites)
  - [lsof <file_path>: Get list of processes using the file](#lsof-file_path-get-list-of-processes-using-the-file)
  - [lsof -p <pid>: Get list of files opened by the process](#lsof--p-pid-get-list-of-files-opened-by-the-process)
  - [Cleanup](#cleanup)

<!-- /TOC -->

## Prerequisites

> [!TIP]
> To learn about how `&` works, check [jobs.md](./jobs.md)

Here is the prerequisite setup for the following examples:

```sh
test_name=lsof_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

touch being_tailed_file
tail -f being_tailed_file &
# [1] 72647
```

## lsof <file_path>: Get list of processes using the file

The job is running with pid `72647`:

```sh
lsof being_tailed_file
# COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF      NODE NAME
# tail    72647  ajk    3r   REG   1,17        0 112695438 being_tailed_file
```

## lsof -p <pid>: Get list of files opened by the process

We can see simple job makes use of multiple files:

```sh
lsof -p 72647
# COMMAND   PID USER   FD     TYPE DEVICE SIZE/OFF                NODE NAME
# tail    72647  ajk  cwd      DIR   1,17       96           112695437 /Users/ajk/test_dive/251222_051646_lsof_command
# tail    72647  ajk  txt      REG   1,17   119328 1152921500312524207 /usr/bin/tail
# tail    72647  ajk  txt      REG   1,17  2289328 1152921500312524573 /usr/lib/dyld
# tail    72647  ajk    0u     CHR   16,4    0t695                1045 /dev/ttys004
# tail    72647  ajk    1u     CHR   16,4    0t695                1045 /dev/ttys004
# tail    72647  ajk    2u     CHR   16,4    0t695                1045 /dev/ttys004
# tail    72647  ajk    3r     REG   1,17        0           112695438 /Users/ajk/test_dive/251222_051646_lsof_command/being_tailed_file
# tail    72647  ajk    4u  KQUEUE                                     count=0, state=0xa
```

## Cleanup

Kill the background job:
```sh
kill 72647 > /dev/null 2>&1
lsof being_tailed_file
# (nothing)
```