---
title: 'One-Click Deploy: Simplifying k8s-athenz-syncer Setup'
published: true
tags: # four tags only, no '-' or special characters except
  - athenz
  - kubernetes
  - k8sathenzsyncer
---

```sh
# cover_image: ./thumbnail.png # 🟡 give me thumbnail
```

# Goal

Athenz provides the following API endpoints for getting Athenz domain and its role/policy information:

- `/v1/domain/{domainName}/group/admin`
- `/v1/domain/{domainName}/group/viewer`

But imagine you have your applications in kubernetes clusters and want to have some kind of sync mechanism of the data rather than getting them all the time. Also, what if you want to make sure that your applications do not depend on Athenz that much?

But let's be realistic—building your own client to fetch, cache, and manage these resources within Kubernetes is a hassle. Why spend time reinventing the wheel when you just want to consume the data?

That's why I looked into [Athenz/k8s-athenz-syncer](https://github.com/AthenZ/k8s-athenz-syncer). It’s an existing tool designed to sync Athenz data into Kubernetes Custom Resources (CRDs) called `AthenzDomain` (Obviously), effectively handling the heavy lifting for us. In this post, I’ll walk through how to deploy this syncer, fix a few build issues I encountered, and explore how it can save us from writing unnecessary boilerplate code.


<!-- TOC -->

- [Goal](#goal)
- [Result](#result)
- [Setup](#setup)
  - [Setup: Working directory](#setup-working-directory)
  - [Setup: Athenz and Local Kubernetes Cluster](#setup-athenz-and-local-kubernetes-cluster)
- [Walkthrough: Implementation](#walkthrough-implementation)
  - [1.](#1)
- [Walkthrough: Verification](#walkthrough-verification)
  - [I.](#i)
- [What's next?](#whats-next)
- [Dive Hours: XX Hours](#dive-hours-xx-hours)
- [Closing](#closing)

<!-- /TOC -->

# Result

TODO

# Setup

## Setup: Working directory

Let's quickly set up working directory. You may use your own, but here is an idempotennt code for quick set up:

```sh
test_name=deploy_k8s_athenz_syncer
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

## Setup: Athenz and Local Kubernetes Cluster

Let's set up Kubernetes cluster locally and install Athenz server:

```sh
git clone https://github.com/mlajkim/dive-manifest.git manifest && cd manifest
make setup
```

# Walkthrough: Implementation

## 1.

# Walkthrough: Verification

## I.

# What's next?

# Dive Hours: XX Hours


- `1/1 Thu`: 6.75 Hours
- `1/2 Fri`: 4.75 Hours

# Closing

If you enjoyed this deep dive, please leave a like & subscribe for more!

![cats_thumbs_up](./assets/cats_thumbs_up.png)