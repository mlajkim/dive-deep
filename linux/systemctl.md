# systemctl

<!-- TOC -->

- [systemctl](#systemctl)
  - [Overview](#overview)
  - [systemctl reboot](#systemctl-reboot)
    - [systemctl reboot --force](#systemctl-reboot---force)
    - [systemctl reboot --force --force: The strongest reboot](#systemctl-reboot---force---force-the-strongest-reboot)
  - [systemctl poweroff](#systemctl-poweroff)
    - [systemctl poweroff --force](#systemctl-poweroff---force)
    - [systemctl poweroff --force --force: The strongest poweroff](#systemctl-poweroff---force---force-the-strongest-poweroff)
  - [systemctl get-default](#systemctl-get-default)
    - [systemctl set-default multi-user.target: Change default target to multi-user (non-GUI)](#systemctl-set-default-multi-usertarget-change-default-target-to-multi-user-non-gui)
    - [systemctl isolate graphical.target: Switch to graphical target (GUI) immediately](#systemctl-isolate-graphicaltarget-switch-to-graphical-target-gui-immediately)

<!-- /TOC -->

## Overview

> [!TIP]
> `systemctl shutdown/reboot` is more of the mechanical way. to see what operators use, please check [shutdown command](linux/shutdown.md).


## systemctl reboot

```sh
systemctl reboot
```

### systemctl reboot --force

```sh
systemctl reboot --force
```

### systemctl reboot --force --force: The strongest reboot

```sh
systemctl reboot --force --force
```

## systemctl poweroff

```sh
systemctl poweroff
```

### systemctl poweroff --force

```sh
systemctl poweroff --force
```

### systemctl poweroff --force --force: The strongest poweroff

The same as plugging out the power cord:

```sh
systemctl poweroff --force --force
```

## systemctl get-default

It shows the current default target (run level) of the system, with the following types:

- `graphical.target`: multi-user system with a graphical user interface (GUI)
- `multi-user.target`: multi-user system without a graphical user interface (GUI)

```sh
systemctl get-default
# graphical.target
```

### systemctl set-default multi-user.target: Change default target to multi-user (non-GUI)

This will show the text-based login prompt on the next boot:

```sh
systemctl set-default multi-user.target
```

### systemctl isolate graphical.target: Switch to graphical target (GUI) immediately

> [!TIP]
> Note that the default target remains unchanged.

This will switch the current session to graphical target (GUI) without rebooting:

```sh
systemctl isolate graphical.target
```
