---
tags:
- hands-on-tested
---

# journalctl

<!-- TOC -->

- [journalctl](#journalctl)
  - [Background: Why such command](#background-why-such-command)
  - [sudo journalctl --unit=ssh.service -n 20 --no-pager](#sudo-journalctl---unitsshservice--n-20---no-pager)
  - [journalctl -p <priorty>](#journalctl--p-priorty)
  - [journalctl -S XX:XX -U XX:XX](#journalctl--s-xxxx--u-xxxx)
  - [journalctl -b 0: Runs the logs from the current boot](#journalctl--b-0-runs-the-logs-from-the-current-boot)
  - [journalctl -g <pattern>: Filter logs with a specific pattern](#journalctl--g-pattern-filter-logs-with-a-specific-pattern)

<!-- /TOC -->

## Background: Why such command

Every log is stored under `/var/log/*`. Now it is hard to manage all these logs. `journalctl` is a command line utility that is used to view the logs collected by `systemd-journald` service.


## sudo journalctl --unit=ssh.service -n 20 --no-pager

```sh
sudo journalctl --unit=ssh.service -n 20 --no-pager
# Dec 21 22:52:15 ubuntu-host sshd[5204]: Accepted publickey for root from 192.10.69.10 port 54576 ssh2: RSA SHA256:5WgrenIgBS6/Y4CKBEHSoXRci0zwsG3a6n/hGScKmSg
# Dec 21 22:52:15 ubuntu-host sshd[5204]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
# Dec 21 22:52:15 ubuntu-host sshd[5204]: Received disconnect from 192.10.69.10 port 54576:11: disconnected by user
# Dec 21 22:52:15 ubuntu-host sshd[5204]: Disconnected from user root 192.10.69.10 port 54576
# Dec 21 22:52:15 ubuntu-host sshd[5204]: pam_unix(sshd:session): session closed for user root
# Dec 21 22:52:15 ubuntu-host sshd[5221]: Accepted publickey for root from 192.10.69.10 port 54588 ssh2: RSA SHA256:5WgrenIgBS6/Y4CKBEHSoXRci0zwsG3a6n/hGScKmSg
# Dec 21 22:52:15 ubuntu-host sshd[5221]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
# Dec 21 22:52:15 ubuntu-host sshd[5221]: Received disconnect from 192.10.69.10 port 54588:11: disconnected by user
# Dec 21 22:52:15 ubuntu-host sshd[5221]: Disconnected from user root 192.10.69.10 port 54588
# Dec 21 22:52:15 ubuntu-host sshd[5221]: pam_unix(sshd:session): session closed for user root
# Dec 21 22:52:18 ubuntu-host sshd[5238]: Accepted publickey for root from 192.10.69.10 port 54604 ssh2: RSA SHA256:5WgrenIgBS6/Y4CKBEHSoXRci0zwsG3a6n/hGScKmSg
# Dec 21 22:52:18 ubuntu-host sshd[5238]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
# Dec 21 22:52:18 ubuntu-host sshd[5238]: Received disconnect from 192.10.69.10 port 54604:11: disconnected by user
# Dec 21 22:52:18 ubuntu-host sshd[5238]: Disconnected from user root 192.10.69.10 port 54604
# Dec 21 22:52:18 ubuntu-host sshd[5238]: pam_unix(sshd:session): session closed for user root
# Dec 21 22:52:18 ubuntu-host sshd[5258]: Accepted publickey for root from 192.10.69.10 port 54618 ssh2: RSA SHA256:5WgrenIgBS6/Y4CKBEHSoXRci0zwsG3a6n/hGScKmSg
# Dec 21 22:52:18 ubuntu-host sshd[5258]: pam_unix(sshd:session): session opened for user root(uid=0) by (uid=0)
# Dec 21 22:52:18 ubuntu-host sshd[5258]: Received disconnect from 192.10.69.10 port 54618:11: disconnected by user
# Dec 21 22:52:18 ubuntu-host sshd[5258]: Disconnected from user root 192.10.69.10 port 54618
# Dec 21 22:52:18 ubuntu-host sshd[5258]: pam_unix(sshd:session): session closed for user root
```


## journalctl -p <priorty>

Priority level:

- info
- warning
- err
- crit

```sh
sudo journalctl -p err
# Dec 21 22:29:07 ubuntu-host systemd[262]: kmod-static-nodes.service: Failed at step EXEC spawning /bin/kmod: No such file or directory
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to start Create List of Static Device Nodes.
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to mount RPC Pipe File System.
# Dec 21 22:29:07 ubuntu-host auditd[617]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:08 ubuntu-host sshd[1582]: error: kex_exchange_identification: Connection closed by remote host
# Dec 21 22:29:08 ubuntu-host auditd[1411]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:08 ubuntu-host auditd[2079]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:09 ubuntu-host auditd[2688]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:09 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:09 ubuntu-host sshd[2865]: error: kex_exchange_identification: Connection closed by remote host
# Dec 21 22:29:09 ubuntu-host auditd[2864]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:09 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:10 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:46:30 ubuntu-host sshd[3412]: error: kex_exchange_identification: client sent invalid protocol identifier "exit"
```


## journalctl -S XX:XX -U XX:XX

- `-S` means "since" (can be also `XXXX-XX-XX XX:XX` format)
- `-U` means "until"

```sh
sudo journalctl -p err -S 22:29:08 -U 22:29:09
# Dec 21 22:29:08 ubuntu-host sshd[1582]: error: kex_exchange_identification: Connection closed by remote host
# Dec 21 22:29:08 ubuntu-host auditd[1411]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:08 ubuntu-host auditd[2079]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
```

## journalctl -b 0: Runs the logs from the current boot

```sh
sudo journalctl -p err -b 0
# Dec 21 22:29:07 ubuntu-host systemd[262]: kmod-static-nodes.service: Failed at step EXEC spawning /bin/kmod: No such file or directory
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to start Create List of Static Device Nodes.
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to mount RPC Pipe File System.
# Dec 21 22:29:07 ubuntu-host auditd[617]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:07 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:08 ubuntu-host sshd[1582]: error: kex_exchange_identification: Connection closed by remote host
# Dec 21 22:29:08 ubuntu-host auditd[1411]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:08 ubuntu-host auditd[2079]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:08 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:09 ubuntu-host auditd[2688]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:09 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:09 ubuntu-host sshd[2865]: error: kex_exchange_identification: Connection closed by remote host
# Dec 21 22:29:09 ubuntu-host auditd[2864]: Cannot change priority (Operation not permitted)
# Dec 21 22:29:09 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:29:10 ubuntu-host systemd[1]: Failed to start Security Auditing Service.
# Dec 21 22:46:30 ubuntu-host sshd[3412]: error: kex_exchange_identification: client sent invalid protocol identifier "exit"
```

## journalctl -g <pattern>: Filter logs with a specific pattern

```sh
sudo journalctl -p info -g "^c"
# Dec 21 22:29:07 ubuntu-host udevadm[354]: cec: Failed to write 'add' to '/sys/bus/cec/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: clockevents: Failed to write 'add' to '/sys/bus/clockevents/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: clocksource: Failed to write 'add' to '/sys/bus/clocksource/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: container: Failed to write 'add' to '/sys/bus/container/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: cpu: Failed to write 'add' to '/sys/bus/cpu/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: CHT Whiskey Cove PMIC: Failed to write 'add' to '/sys/bus/i2c/drivers/CHT Whiskey Cove PMIC/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: charger-manager: Failed to write 'add' to '/sys/bus/platform/drivers/charger-manager/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: cherryview-pinctrl: Failed to write 'add' to '/sys/bus/platform/drivers/cherryview-pinctrl/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: clk-lpt: Failed to write 'add' to '/sys/bus/platform/drivers/clk-lpt/uevent': Permission denied
# Dec 21 22:29:07 ubuntu-host udevadm[354]: clk-pmc-atom: Failed to
```


