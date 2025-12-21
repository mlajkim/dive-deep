# ps

<!-- TOC -->

- [ps](#ps)
  - [ps aux](#ps-aux)
    - [ps <pid>](#ps-pid)
    - [ps -u <uid>](#ps--u-uid)
      - [ps -U <username>](#ps--u-username)
    - [ps fax: to see process tree](#ps-fax-to-see-process-tree)
  - [pgrep](#pgrep)
  - [top: to continue `ps aux`](#top-to-continue-ps-aux)

<!-- /TOC -->

## ps aux

```sh
ps aux
# USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root           1  0.0  0.0 101064  7412 ?        Ss   19:23   0:00 /sbin/init --log-level=err
# root         256  0.0  0.0  25536  3400 ?        Ss   19:23   0:00 /lib/systemd/systemd-journald
# root         523  0.0  0.0  24332   920 ?        Ss   19:23   0:00 /lib/systemd/systemd-udevd
# _rpc         642  0.0  0.0   8104   448 ?        Ss   19:23   0:00 /sbin/rpcbind -f -w
# systemd+     668  0.0  0.0  25536  4660 ?        Ss   19:23   0:00 /lib/systemd/systemd-resolved
# message+    1291  0.0  0.0   8288  1456 ?        Ss   19:23   0:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-
# root        1335  0.0  0.0  15048  2340 ?        Ss   19:23   0:00 /lib/systemd/systemd-logind
# root        1375  0.0  0.0   8080   320 ?        Ss   19:23   0:00 /bin/bash /usr/local/bin/start-ttyd.sh
# root        1376  0.0  0.0 2170060 24400 ?       Ssl  19:23   0:02 /usr/bin/containerd
# root        1381  0.0  0.0  15428  3676 ?        Ss   19:23   0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
# root        1383  0.0  0.0   9724   876 ?        Rl   19:23   0:00 /usr/bin/ttyd --ping-interval 30 -t fontSize 16 -t theme {"foreground": "#eff0eb", "backgrou
# root        1472  0.0  0.0 2356512 47776 ?       Ssl  19:23   0:00 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
# root        3202  0.0  0.0 296312  6228 ?        Ssl  19:23   0:00 /usr/libexec/packagekitd
# root        3212  0.0  0.0 234496  2964 ?        Ssl  19:23   0:00 /usr/libexec/polkitd --no-debug
# root        4119  0.0  0.0   6524   120 pts/0    Rs+  19:51   0:00 /usr/bin/script -q -f /root/.terminal_logs/terminal.log bash -c sudo su - bob
# root        4121  0.0  0.0   2888   208 pts/1    Ss+  19:51   0:00 sh -c sudo su - bob
# root        4122  0.0  0.0  11840  3640 pts/1    R+   19:51   0:00 sudo su - bob
# root        4123  0.0  0.0  11840   632 pts/2    Ss   19:51   0:00 sudo su - bob
# root        4124  0.0  0.0  10584  3380 pts/2    S    19:51   0:00 su - bob
# bob         4151  0.0  0.0  17076  5416 ?        Ss   19:51   0:00 /lib/systemd/systemd --user
# bob         4158  0.0  0.0 103648  4052 ?        S    19:51   0:00 (sd-pam)
# bob         4195  0.0  0.0   9476  5376 pts/2    S    19:51   0:00 -bash
# bob         4724  0.0  0.0  10388  1592 pts/2    R+   20:35   0:00 ps aux
```

### ps <pid>

```sh
ps 1
    # PID TTY      STAT   TIME COMMAND
    #   1 ?        Ss     0:00 /sbin/init --log-level=err
```

### ps -u <uid>

> [!TIP]
> You can list up uids by `cut -d: -f1,3 /etc/passwd`

```sh
s -u 0
  #   PID TTY          TIME CMD
  #     1 ?        00:00:00 systemd
  #   256 ?        00:00:00 systemd-journal
  #   523 ?        00:00:00 systemd-udevd
  #  1335 ?        00:00:00 systemd-logind
  #  1375 ?        00:00:00 start-ttyd.sh
  #  1376 ?        00:00:02 containerd
  #  1381 ?        00:00:00 sshd
  #  1383 ?        00:00:00 ttyd
  #  1472 ?        00:00:00 dockerd
  #  3202 ?        00:00:00 packagekitd
  #  3212 ?        00:00:00 polkitd
  #  4119 pts/0    00:00:00 script
  #  4121 pts/1    00:00:00 sh
  #  4122 pts/1    00:00:00 sudo
  #  4123 pts/2    00:00:00 sudo
  #  4124 pts/2    00:00:00 su
```

#### ps -U <username>

```sh
ps -U root
  #   PID TTY          TIME CMD
  #     1 ?        00:00:00 systemd
  #   256 ?        00:00:00 systemd-journal
  #   523 ?        00:00:00 systemd-udevd
  #  1335 ?        00:00:00 systemd-logind
  #  1375 ?        00:00:00 start-ttyd.sh
  #  1376 ?        00:00:02 containerd
  #  1381 ?        00:00:00 sshd
  #  1383 ?        00:00:00 ttyd
  #  1472 ?        00:00:00 dockerd
  #  3202 ?        00:00:00 packagekitd
  #  3212 ?        00:00:00 polkitd
  #  4119 pts/0    00:00:00 script
  #  4121 pts/1    00:00:00 sh
  #  4122 pts/1    00:00:00 sudo
  #  4123 pts/2    00:00:00 sudo
  #  4124 pts/2    00:00:00 su
```

### ps fax: to see process tree

We can see good looking tree:

```sh
ps fax
  #   PID TTY      STAT   TIME COMMAND
  #     1 ?        Ss     0:00 /sbin/init --log-level=err
  #   256 ?        Ss     0:00 /lib/systemd/systemd-journald
  #   523 ?        Ss     0:00 /lib/systemd/systemd-udevd
  #   642 ?        Ss     0:00 /sbin/rpcbind -f -w
  #   668 ?        Ss     0:00 /lib/systemd/systemd-resolved
  #  1291 ?        Ss     0:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
  #  1335 ?        Ss     0:00 /lib/systemd/systemd-logind
  #  1375 ?        Ss     0:00 /bin/bash /usr/local/bin/start-ttyd.sh
  #  1383 ?        Sl     0:00  \_ /usr/bin/ttyd --ping-interval 30 -t fontSize 16 -t theme {"foreground": "#eff0eb", "background": "#282a36", "cursor": "#adadad
  #  4119 pts/0    Ss+    0:00      \_ /usr/bin/script -q -f /root/.terminal_logs/terminal.log bash -c sudo su - bob
  #  4121 pts/1    Ss+    0:00          \_ sh -c sudo su - bob
  #  4122 pts/1    S+     0:00              \_ sudo su - bob
  #  4123 pts/2    Ss     0:00                  \_ sudo su - bob
  #  4124 pts/2    S      0:00                      \_ su - bob
  #  4195 pts/2    S      0:00                          \_ -bash
  #  4965 pts/2    R+     0:00                              \_ ps fax
  #  1376 ?        Ssl    0:02 /usr/bin/containerd
  #  1381 ?        Ss     0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
  #  1472 ?        Ssl    0:00 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
  #  3202 ?        Ssl    0:00 /usr/libexec/packagekitd
  #  3212 ?        Ssl    0:00 /usr/libexec/polkitd --no-debug
  #  4151 ?        Ss     0:00 /lib/systemd/systemd --user
  #  4158 ?        S      0:00  \_ (sd-pam)
```


## pgrep

`pgrep` is basically `ps` + `grep`:

```sh
pgrep -a bash
# 4195 -bash
```

## top: to continue `ps aux`


```sh
top
# Processes: 715 total, 2 running, 713 sleeping, 4166 threads                                                    04:30:43
# Load Avg: 1.39, 1.73, 2.30  CPU usage: 5.96% user, 3.39% sys, 90.63% idle
# SharedLibs: 1213M resident, 200M data, 567M linkedit. MemRegions: 0 total, 0B resident, 0B private, 7028M shared.
# PhysMem: 43G used (2769M wired, 3460M compressor), 20G unused.
# VM: 325T vsize, 5703M framework vsize, 610(0) swapins, 5040(0) swapouts.
# Networks: packets: 73650245/84G in, 20353931/7037M out. Disks: 34660502/698G read, 61003889/1280G written.

# PID    COMMAND      %CPU TIME     #TH    #WQ   #PORTS MEM    PURG   CMPRS PGRP  PPID  STATE    BOOSTS
# 938    com.apple.Vi 38.7 17:36:39 17     2     71     8109M  0B     10G-  938   1     sleeping *6[3]
# 396    WindowServer 15.7 33:59:19 29     6     5507+  746M+  72M-   119M  396   1     sleeping *0[1]
# 61309  top          9.6  00:07.17 1/1    0     28     8033K  0B     0B    61309 60661 running  *0[1]
# 0      kernel_task  6.3  13:02:09 898/12 0     0      14M-   0B     0B    0     0     running   0[0]
# 92024  Terminal     5.3  00:10.31 10     3     442    102M+  11M-   0B    92024 1     sleeping *0[4667+]
# 60203  Google Chrom 3.9  01:18.67 25     1     279    227M   16K    0B    37760 37760 sleeping *44[4052]
# 388    bluetoothd   3.1  02:38:41 12     5/2   1113   43M    384K   31M   388   1     sleeping *0[1]
# 46469  Music        2.9  11:48.75 23     5     790    187M-  32M+   92M   46469 1     sleeping *187[16120]
# 408    coreaudiod   2.3  02:53:47 10     2     15817  77M    0B     34M   408   1     sleeping *0
# ...
```
