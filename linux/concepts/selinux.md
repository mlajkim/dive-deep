# selinux

<!-- TOC -->

- [selinux](#selinux)
  - [Overview](#overview)
    - [Mechanism](#mechanism)
      - [Mechanism: Label](#mechanism-label)
  - [Basic commands](#basic-commands)
  - [sestatus](#sestatus)
  - [selinux activate](#selinux-activate)
  - [getenforce](#getenforce)
  - [audit2why](#audit2why)
  - [ps -eZ | grep sshd_t](#ps--ez--grep-sshd_t)
  - [audit2allow --all -M <module_name>](#audit2allow---all--m-module_name)

<!-- /TOC -->


## Overview

Security enforcement mechanism for Linux kernel.

### Mechanism

SELinux sets a **label** for:

- file
- process
- port
- user

We call **context** for what's written in the label.

#### Mechanism: Label

`User : Role : Type : Level`

A label is made of 4 parts, separated by colons (`:`):

- `User`: SELinux user (This is different from Linux user)
- `Role`: SELinux role
- `Type`: SELinux type (most important part)
- `Level`: MLS (Multi-Level Security) level (not used much in practice)


## Basic commands

> [!NOTE]
> Unlike other commands, the set up commands are managed in this file.

## sestatus



## selinux activate

> [!TIP]
> You can see the `GRUB_CMDLINE_LINUX= security=selinux` by `cat /etc/default/grub`.

## getenforce

> [!WARNING]
> You do not want to set it to `Enforcing` right away. You first learn from `Permissive` mode.

You can check the current mode:

- Disabled: SELinux is turned off.
- Permissive: SELinux prints warnings instead of enforcing.
- Enforcing: SELinux policy is enforced.

## audit2why

Prints the reason why a particular access was denied.


## ps -eZ | grep sshd_t

## audit2allow --all -M <module_name>