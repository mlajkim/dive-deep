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
  - [Setup: Check if Docker is running](#setup-check-if-docker-is-running)
  - [Brain-dead try: build](#brain-dead-try-build)
    - [Check](#check)
  - [Try: build with different platform](#try-build-with-different-platform)
    - [Check](#check-1)

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

## Setup: Check if Docker is running

```sh
docker ps
```

## Brain-dead try: build

> [!TIP]
> `docker buildx` allows you to build both linux/amd64 and linux/arm64 images on an M Series Mac.

```sh
cd sidecar
docker build -t provider-sidecar .
docker images | grep provider-sidecar

# provider-sidecar                                                 latest          209ed2a27bca   18 seconds ago   30.6M
```

### Check

oh, the image is building for arm64!

```sh
docker inspect provider-sidecar:latest | grep Architecture

#         "Architecture": "arm64",
```

## Try: build with different platform

```sh
docker build --platform linux/amd64 -t provider-sidecar:intel .
```

### Check

```sh
docker inspect provider-sidecar:intel | grep Architecture

        # "Architecture": "amd64",
```