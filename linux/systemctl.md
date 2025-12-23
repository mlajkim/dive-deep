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
  - [systemctl start/stop/restart/reload/status/disable/is-enabled/enable <service_name>](#systemctl-startstoprestartreloadstatusdisableis-enabledenable-service_name)
    - [systemctl enable/disable --now <service_name>](#systemctl-enabledisable---now-service_name)
    - [system mask/unmask <service_name>](#system-maskunmask-service_name)
  - [systemctl list-units --all --type <unit_type>](#systemctl-list-units---all---type-unit_type)
  - [systemctl list-dependencies](#systemctl-list-dependencies)

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

> [!NOTE]
> It simply stores the symbolic link to the default target unit file: `ls -l /etc/systemd/system/default.target`
> Meaning, you can simply get list of targets like ` ls  /lib/systemd/system/ | grep graphic`

It shows the current default target (run level) of the system, with the following types:

- `graphical.target`: multi-user system with a graphical user interface (GUI)
- `multi-user.target`: multi-user system without a graphical user interface (GUI)
- `emergency.target`: minimal environment for emergency maintenance
- `rescue.target`: single-user mode for system recovery (more applications than emergency)

```sh
systemctl get-default
# graphical.target
```

### systemctl set-default multi-user.target: Change default target to multi-user (non-GUI)

This will show the text-based login prompt on the next boot:

```sh
sudo systemctl set-default graphical.target
# Removed /etc/systemd/system/default.target.
# Created symlink /etc/systemd/system/default.target → /lib/systemd/system/graphical.target.
```

### systemctl isolate graphical.target: Switch to graphical target (GUI) immediately

> [!TIP]
> Note that the default target remains unchanged.

This will switch the current session to graphical target (GUI) without rebooting:

```sh
systemctl isolate graphical.target
```

## systemctl start/stop/restart/reload/status/disable/is-enabled/enable <service_name>

> [!TIP]
> Note that the `start` won't load the new configuration file.

- `start`: Start the specified service.
- `stop`: Stop the specified service.
- `restart`: Restart the specified service (basically `stop` + `start`) (Yes PID changes)
- `reload`: Reload the configuration of the specified service without stopping it (No PID change)
- `status`: Show the current status of the specified service.
- `disable`: Disable the specified service from starting at boot time.
- `is-enabled`: Check if the specified service is enabled to start at boot time.
- `enable`: Enable the specified service to start at boot time.

### systemctl enable/disable --now <service_name>

This will enable/disable the specified service and start/stop it immediately.

Pretty handy!

- `enable --now`: `enable` + `start`
- `disable --now`: `disable` + `stop`


### system mask/unmask <service_name>

Sometimes, other services start/disable a service automatically even after you `disable` it.

To prevent a service from being started by any means, you can `mask` it. This creates a symbolic link that points to `/dev/null`, effectively making it impossible to start the service.

```sh
sudo systemctl mask apache
# Created symlink /etc/systemd/system/apache2.service → /dev/null.
```
2
Or:

```sh
sudo systemctl unmask apache2
# Removed /etc/systemd/system/apache2.service.
```

## systemctl list-units --all --type <unit_type>

> [!TIP]
> You can do `man systemctl.<unit_type>` to see more about each unit type, especially for exam

> [!TIP]
> You can check out already available unit files in `/etc/systemd/system/` and `/lib/systemd/system/` to get start point. To learn more about these directories, please check [here](/linux/concepts/special_files.md#etcsystemdsystem).

Here are the unit file types you can list:

- `service`: Services
- `socket`: Sockets
- `device`: Devices
- `mount`: Mount points
- `automount`: Automount points
- `swap`: Swap spaces
- `target`: Targets
- `path`: Paths
- `timer`: Timers


`-all` shows all units, including inactive ones.


## systemctl list-dependencies

