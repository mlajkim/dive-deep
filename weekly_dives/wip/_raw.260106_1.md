# About _raw.260106.md

This is a raw dump file for daily dive on jan-06-2026.

<!-- TOC -->

- [About _raw.260106.md](#about-_raw260106md)
- [Goal: Knows what `Rosetta` is](#goal-knows-what-rosetta-is)
- [Setup](#setup)
  - [Setup: Working directory](#setup-working-directory)

<!-- /TOC -->

# Goal: Knows what `Rosetta` is

linux/amd64,
Advanced Micro Devices 64-bit architecture

linux/arm64
Advanced RISC (Reduced Instruction Set Computer) Machines 64-bit architecture

GOARCH=arm64



# Setup

## Setup: Working directory

```sh
test_name=email_notification_plugin
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```