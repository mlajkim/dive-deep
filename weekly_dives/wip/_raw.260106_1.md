# About _raw.260106.md

This is a raw dump file for daily dive on jan-06-2026.

<!-- TOC -->

- [About _raw.260106.md](#about-_raw260106md)
- [Goal: Deploy Athenz/authorization-proxy for arm64](#goal-deploy-athenzauthorization-proxy-for-arm64)
- [Prerequisite Knowledge](#prerequisite-knowledge)
  - [Knows what `Rosetta` is](#knows-what-rosetta-is)
- [Setup](#setup)
  - [Setup: Working directory](#setup-working-directory)
  - [Setup: Clone Provider sidecar](#setup-clone-provider-sidecar)

<!-- /TOC -->

# Goal: Deploy Athenz/authorization-proxy for arm64
https://github.com/AthenZ/authorization-proxy

# Prerequisite Knowledge

## Knows what `Rosetta` is

linux/amd64,
Advanced Micro Devices 64-bit architecture

linux/arm64
Advanced RISC (Reduced Instruction Set Computer) Machines 64-bit architecture

GOARCH=arm64

# Setup

## Setup: Working directory

```sh
test_name=provider_sidecar_arm64
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

## Setup: Clone Provider sidecar

```sh
git clone https://github.com/AthenZ/authorization-proxy sidecar
```