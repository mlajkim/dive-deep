---
tags:
- hands-on-tested
---

# nice

<!-- TOC -->

- [nice](#nice)
  - [Prerequisites](#prerequisites)
  - [get nice](#get-nice)
  - [renice](#renice)
  - [renice with higher priority](#renice-with-higher-priority)
  - [nice: run a command with a modified scheduling priority](#nice-run-a-command-with-a-modified-scheduling-priority)

<!-- /TOC -->

## Prerequisites

> [!TIP]
> To learn about how `&` works, check [jobs.md](./jobs.md)

Here is the prerequisite setup for the following examples:

```sh
test_name=nice_command
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir

mkdir dir
touch dir/file1 dir/file2 dir/file3

sleep 1000 &
# [1] 74540
```

## get nice

> [!TIP]
> Put the correct pid

> [!NOTE]
> Note that NICE has range of `-20` ~ `19`, where `-20` is the highest priority

We can see that nice is set up with `5` by default:

```sh
ps -o pid,ni,stat -p 74540
#   PID NI STAT
# 74540  5 SN
```

## renice

> [!TIP]
> You can only set up higher priority, as root user

We can see NICE `5`=>`10`:

```sh
renice 10 -p 74540
ps -o pid,ni,stat -p 74540
#   PID NI STAT
# 74540 10 SN
```

## renice with higher priority

You need `sudo` to set up higher priority, but for now we won't higher it:

```sh
renice 5 -p 74540
# renice: failed to set priority for 1391 (process ID): Operation not permitted

sudo renice 9 -p 1391
# 1391 (process ID) old priority 0, new priority 9
```

## nice: run a command with a modified scheduling priority

Create a tar with lowest priority:

```sh
nice -n 19 tar -czf backup.tar.gz dir
```