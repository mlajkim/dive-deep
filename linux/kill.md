---
tags:
- hands-on-tested
---

# kill

<!-- TOC -->

- [kill](#kill)
  - [Prerequisites](#prerequisites)
  - [kill -l: Get List of Signals](#kill--l-get-list-of-signals)
    - [Learn details of well-known signals](#learn-details-of-well-known-signals)
  - [kill <pid>: Send SIGTERM to a Process](#kill-pid-send-sigterm-to-a-process)
    - [kill -<number> <pid>:](#kill--number-pid)

<!-- /TOC -->

## Prerequisites

> [!TIP]
> To learn more about `jobs`, check [jobs.md](./jobs.md)

Here is the prerequisite setup for the following examples:

```sh
sleep 10000 &
sleep 10000 &
jobs -l
# [1]  - 67981 running    sleep 10000
# [2]  + 68011 running    sleep 10000
```

## kill -l: Get List of Signals

```sh
kill -l
#  1) SIGHUP       2) SIGINT       3) SIGQUIT      4) SIGILL       5) SIGTRAP
#  6) SIGABRT      7) SIGBUS       8) SIGFPE       9) SIGKILL     10) SIGUSR1
# 11) SIGSEGV     12) SIGUSR2     13) SIGPIPE     14) SIGALRM     15) SIGTERM
# 16) SIGSTKFLT   17) SIGCHLD     18) SIGCONT     19) SIGSTOP     20) SIGTSTP
# 21) SIGTTIN     22) SIGTTOU     23) SIGURG      24) SIGXCPU     25) SIGXFSZ
# 26) SIGVTALRM   27) SIGPROF     28) SIGWINCH    29) SIGIO       30) SIGPWR
# 31) SIGSYS      34) SIGRTMIN    35) SIGRTMIN+1  36) SIGRTMIN+2  37) SIGRTMIN+3
# 38) SIGRTMIN+4  39) SIGRTMIN+5  40) SIGRTMIN+6  41) SIGRTMIN+7  42) SIGRTMIN+8
# 43) SIGRTMIN+9  44) SIGRTMIN+10 45) SIGRTMIN+11 46) SIGRTMIN+12 47) SIGRTMIN+13
# 48) SIGRTMIN+14 49) SIGRTMIN+15 50) SIGRTMAX-14 51) SIGRTMAX-13 52) SIGRTMAX-12
# 53) SIGRTMAX-11 54) SIGRTMAX-10 55) SIGRTMAX-9  56) SIGRTMAX-8  57) SIGRTMAX-7
# 58) SIGRTMAX-6  59) SIGRTMAX-5  60) SIGRTMAX-4  61) SIGRTMAX-3  62) SIGRTMAX-2
# 63) SIGRTMAX-1  64) SIGRTMAX
```

### Learn details of well-known signals

| Signal & id |                Description                |
|:-----------:|:-----------------------------------------:|
| SIGTERM 15  |            Termination signal             |
|  SIGKILL 9  | Kill signal (cannot be caught or ignored) |
|  SIGINT 2   |     Interrupt from keyboard (Ctrl+C)      |
|  SIGHUP 1   |  Hangup detected on controlling terminal  |

## kill <pid>: Send SIGTERM to a Process

```sh
kill 68011
# [2]  + terminated  sleep 10000
```

### kill -<number> <pid>:

```sh
kill -2 69896
# [2]  + interrupt  sleep 10000
```
