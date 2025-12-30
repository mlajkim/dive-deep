---
title: "Stop Using Magic: Building a Kubernetes Operator from Scratch"
published: true
tags: [kubernetes, weekly_dive, operator, athenz, contribution, first_time]
series: "Weekly Dive"
cover_image: "./thumbnail.png"
---

# Goal

Hello everyone! This post's primary goal is to demystify how Kubernetes Controllers work by building a custom [Athenz/k8s-athenz-syncer](https://github.com/AthenZ/k8s-athenz-syncer) from scratch! Instead of relying on "magic" libraries or copying existing production code, we are diving deep into the core concepts by implementing the operator ourselves.

By doing this, we can:

- Understand the core concepts of Kubernetes Operators and the Reconciliation Loop.
- Learn how to interact with the Athenz ZMS server via its API programmatically.
- Implement a logic that automatically maps external identity roles (Athenz) to Kubernetes RBAC.
- Identify the subtle details often overlooked when simply deploying pre-made operators.
- Know exactly what to look for to catch the subtle details that other reviewers would miss

<!-- TOC -->

- [Goal](#goal)
- [Result](#result)
- [What I Learned](#what-i-learned)
- [Walkthrough](#walkthrough)
  - [Prerequisites & Setup](#prerequisites--setup)
    - [a. Local Kubernetes Cluster (Kind)](#a-local-kubernetes-cluster-kind)
    - [b. Deploy Athenz Server](#b-deploy-athenz-server)
    - [c. Configure Athenz Domains](#c-configure-athenz-domains)
  - [Implementation: The Hard & Clean Way](#implementation-the-hard--clean-way)
    - [1. Initialize the Project](#1-initialize-the-project)
    - [2. Make an operator that works from scratch](#2-make-an-operator-that-works-from-scratch)
    - [3. Refactor the operator to make it cleaner](#3-refactor-the-operator-to-make-it-cleaner)
    - [4. Write demo/local setup guide in README.md](#4-write-demolocal-setup-guide-in-readmemd)
    - [5. Make `make run` writes a config](#5-make-make-run-writes-a-config)
  - [Verification: Does it actually work?](#verification-does-it-actually-work)
- [What's next?](#whats-next)
  - [I: The "Weekly Dive": Performance Optimization](#i-the-weekly-dive-performance-optimization)
  - [II: Dissecting the Production Code (athenz/k8s-athenz-syncer)](#ii-dissecting-the-production-code-athenzk8s-athenz-syncer)
  - [III: Contributing Back](#iii-contributing-back)
- [Closing](#closing)

<!-- /TOC -->

# Result

I successfully built a working Kubernetes operator and you can find it here:

- How to setup guide: [mlajkim/k8s-athenz-syncer-the-hard-clean-way/README.md](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/blob/main/README.md#how-to-run-locally)
- PR: [PR: k8s-athenz-syncer-the-hard-clean-way](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/pull/1).

The operator, `k8s-athenz-syncer-the-hard-clean-way`, performs the following actions automatically when a **Namespace**  `<ns>` is created in the cluster:

1. Creates a corresponding **Athenz Domain** (e.g., `eks.users.<ns>`).
2. Creates **Athenz Roles** within that domain based on a configuration.
3. Creates **Kubernetes RBAC Roles** that map to those Athenz roles.
4. Periodically polls Athenz to sync member changes into Kubernetes RoleBindings.

**Demo 1: Auto-creation of Resources in Athenz with k8s namespace only**

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/01_create_ns.gif)

**Demo 2: Giving permission with Syncing Membership (Polling)**

Operator `k8s-athenz-syncer-the-hard-clean-way` periodically polls Athenz roles under certain parent domain (e.g., `eks.users`), and syncs the members of the Athenz roles into corresponding Kubernetes RBAC Roles, which results in automatic access control based on Athenz role membership.

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/02_polling_athenz_roles.gif)
Operator `k8s-athenz-syncer-the-hard-clean-way` makes sure that if you delete members from Athenz roles, the members are also removed from corresponding Kubernetes RBAC Roles.

**Demo 3: Restricting permission with Syncing Membership (Polling)**

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/03_remove_athenz_role_members.gif)

# What I Learned

Through this "hard way" implementation, I gained several key technical insights:

1. **The Power of Kubebuilder Scaffolding**
* Starting from scratch doesn't mean writing boilerplate. `kubebuilder` abstracts away the complexity of leader election, metrics server, and signal handling, allowing us to focus purely on the `Reconcile` logic.

2. **Level-Triggered vs. Edge-Triggered**
* Kubernetes controllers are primarily level-triggered. While I implemented a polling mechanism for the external Athenz API, the internal Kubernetes state relies on the `Reconcile` loop constantly attempting to move the current state to the desired state.
* I learned that for external resources (like Athenz), we explicitly need to manage the polling interval or set up webhooks, as Kubernetes cannot "watch" an external API by default.

3. **Security Integration Details**
* Connecting Kubernetes RBAC with an external system isn't just about mapping strings. It involves handling X.509 certificates for authentication (Athenz) and correctly signing Kubernetes CSRs for user testing (`user.mlajkim`).


# Walkthrough

Here is the step-by-step record of how I achieved the result.

## Prerequisites & Setup

### a. Local Kubernetes Cluster (Kind)

I used `kind` to run a cluster locally.

```sh
kind create cluster
kubectl cluster-info --context kind-kind

```

### b. Deploy Athenz Server

I utilized [`@ctyano`](https://github.com/ctyano)'s [`athenz-distribution`](https://github.com/ctyano/athenz-distribution) to deploy a local Athenz instance.

```sh
# Clone and deploy Athenz
git clone https://github.com/ctyano/athenz-distribution.git athenz_distribution
make -C ./athenz_distribution clean-kubernetes-athenz deploy-kubernetes-athenz

# Port forward the UI
kubectl -n athenz port-forward deployment/athenz-ui 3000:3000 &
open http://localhost:3000
```

### c. Configure Athenz Domains

Set up the ZMS server access and create the Top Level Domain (TLD) for testing.

```sh
# Port forward ZMS
kubectl -n athenz port-forward deployment/athenz-zms-server 4443:4443 &

# Create TLD "eks"
curl -k -X POST "https://localhost:4443/zms/v1/domain" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
  -H "Content-Type: application/json" \
  -d '{"name": "eks", "adminUsers": ["user.athenz_admin"]}'

# Create Subdomain "eks.users"
curl -k -X POST "https://localhost:4443/zms/v1/subdomain/eks" \
  --cert ./athenz_distribution/certs/athenz_admin.cert.pem \
  --key ./athenz_distribution/keys/athenz_admin.private.pem \
    -H "Content-Type: application/json" \
  -d '{"parent": "eks", "name": "users", "adminUsers": ["user.athenz_admin"]}'

```

## Implementation: The Hard & Clean Way

### 1. Initialize the Project

I initialized the project using `kubebuilder`.

```sh
repo="github.com/mlajkim"
mkdir -p k8s-athenz-syncer-the-hard-clean-way && cd k8s-athenz-syncer-the-hard-clean-way
kubebuilder init --domain "ajktown.com" --repo "$repo/k8s-athenz-syncer-the-hard-clean-way"

```

### 2. Make an operator that works from scratch

I first created an operator that works in bare minimum and deployed it public to the repository: [k8s-athenz-syncer-the-hard-way](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-way/)


### 3. Refactor the operator to make it cleaner

But I found myself to improve the code structure and make it cleaner. So I created a new repository: [k8s-athenz-syncer-the-hard-clean-way](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/), with `clean` meaning that I re-organized the code structure to make it more modular and readable.

### 4. Write demo/local setup guide in README.md

I realized that visuals speak louder than words when demonstrating infrastructure tools. Instead of greeting users with a wall of text, I structured the [README.md](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/blob/main/README.md) to lead with [GIFs](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/tree/main/assets) that showcase the operator's features immediately. Once I've captured the reader's interest, I provide a ["copy-paste friendly" local setup guide](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/blob/main/README.md#how-to-run-locally) to make the onboarding process as seamless as possible.

### 5. Make `make run` writes a config

To make the README.md easier to follow, I made `make run` write a config file `config.yaml` automatically with [hack/ensure-config.sh](https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/blob/main/hack/ensure-config.sh), so that users don't have to manually create the config file, that they have no idea what to write in there. Also I've utilized `read` command in bash to make it interactive, so that users can just copy and paste the values when they run `make run`.

## Verification: Does it actually work?

You can see the verifications from the step above named "[Result](#result)"


# What's next?

Now that I have a working prototype built from scratch, I want to bridge the gap between this "clean" version and a robust, production-grade operator. My roadmap for the coming weeks is as follows:

## I: The "Weekly Dive": Performance Optimization

I plan to dedicate a full week (my "Weekly Dive") to deeply thinking about performance:

- **Optimization Strategy**: instead of blindly fetching full role memberships every time, I want to investigate using HTTP headers (like ETag or Last-Modified) to implement a delta-sync mechanism.
- **Scaling Complexity**: I am also curious about how Assumed Roles affect performance with `expand=true` in API and logic compared to standard domain roles.


## II: Dissecting the Production Code (athenz/k8s-athenz-syncer)

After my independent study, I will deploy the official upstream Athenz/k8s-athenz-syncer locally:

- **Documentation**: I aim to document exactly what configurations are required to run it and create easy-to-use manifests so anyone can deploy it effortlessly.
- **Code Audit**: I will conduct a line-by-line analysis of the production code. My goal is to reverse-engineer the "why" behind their design decisions—what edge cases did they handle that I missed? Why did they choose specific architectural patterns?

## III: Contributing Back

Finally, I don't just want to be an observer:

- **Feedback Loop**: If I find performance bottlenecks or logic gaps during my audit, I plan to raise Issues or submit PRs to the upstream repository.
- **Community**: I hope to start a conversation with the maintainers (Yahoo Inc.) to validate my assumptions and share my findings.
- **Guide others**: If some teams want to use Athenz role as SSoT for Kubernetes RBAC, I want to help them by sharing my learnings and possibly providing a more production-ready version of my "hard & clean way" operator.

# Closing

If you enjoyed this deep dive, please leave a like & subscribe for more!

![like_this_photo](https://github.com/user-attachments/assets/7c240593-7257-41bc-b0d9-0db48a6e74b7)
