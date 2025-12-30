# Stop Using Magic: Build your own Kubernetes Operator from Scratch

<!-- TOC -->

- [Stop Using Magic: Build your own Kubernetes Operator from Scratch](#stop-using-magic-build-your-own-kubernetes-operator-from-scratch)
- [Goal](#goal)
- [Result](#result)
- [How I did it](#how-i-did-it)
  - [Setup](#setup)
    - [Setup: Run local Kubernetes cluster w/ Kind](#setup-run-local-kubernetes-cluster-w-kind)
    - [Setup: Deploy Athenz server in the local cluster](#setup-deploy-athenz-server-in-the-local-cluster)
    - [Setup: Set local endpoint for ZMS Server](#setup-set-local-endpoint-for-zms-server)
    - [Setup: Create TLD](#setup-create-tld)
    - [Setup: Create Subdomains under the fresh TLD](#setup-create-subdomains-under-the-fresh-tld)
    - [Setup: Install kubebuilder for quick boilerplate of operator](#setup-install-kubebuilder-for-quick-boilerplate-of-operator)
    - [Setup: Create K8s user "user.mlajkim" for demo](#setup-create-k8s-user-usermlajkim-for-demo)
  - [Dev: Implement a syncer without refactoring](#dev-implement-a-syncer-without-refactoring)
  - [Dev: Implement refactored version](#dev-implement-refactored-version)
- [What I learn](#what-i-learn)
- [What's next?](#whats-next)

<!-- /TOC -->


# Goal

The primary goal is to demystify how you can create your own Kubernetes Controllers work by showing what I did to build a custom [Athenz/k8s-athenz-syncer](https://github.com/AthenZ/k8s-athenz-syncer) from scratch ("The Hard & Clean Way"). By doing this I expect to show you:
- Understand the core concepts of Kubernetes Operators and Controllers
- Learn how to interact with Athenz ZMS server via its API
- Understand how to manage Athenz domains and roles programmatically
- Learn what are the small details that are often overlooked by simply deploying it

However, I do not want to just build already-proudction level stuff right away, but instead want to simply build something that works first. Then maybe I can improve it later with different blog posts.

# Result

I was able to build a Kubernetes operator from scratch with the following PR: https://github.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/pull/1

This operator `k8s-athenz-syncer-the-hard-clean-way` creates the following when you simply create a namespace in your Kubernetes cluster:
- Athenz domain under certain parent domain (e.g., `eks.users`)
- Athenz roles under the created domain, that you can define in the config file
- Kubernetes RBAC Roles that correspond to the created Athenz roles, that you define in the config file

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/01_create_ns.gif)

Operator `k8s-athenz-syncer-the-hard-clean-way` periodically polls Athenz roles under certain parent domain (e.g., `eks.users`), and syncs the members of the Athenz roles into corresponding Kubernetes RBAC Roles.

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/02_polling_athenz_roles.gif)
Operator `k8s-athenz-syncer-the-hard-clean-way` makes sure that if you delete members from Athenz roles, the members are also removed from corresponding Kubernetes RBAC Roles.

![Demo](https://raw.githubusercontent.com/mlajkim/k8s-athenz-syncer-the-hard-clean-way/3926c3d57774b5be1ed91afcace70db1115ac73c/assets/03_remove_athenz_role_members.gif)

# How I did it

Here are the steps that I took to build the conclusion above

## Setup

### Setup: Run local Kubernetes cluster w/ Kind

### Setup: Deploy Athenz server in the local cluster

### Setup: Set local endpoint for ZMS Server

### Setup: Create TLD

### Setup: Create Subdomains under the fresh TLD

### Setup: Install kubebuilder for quick boilerplate of operator

### Setup: Create K8s user "user.mlajkim" for demo

## Dev: Implement a syncer without refactoring

## Dev: Implement refactored version

# What I learn

# What's next?
