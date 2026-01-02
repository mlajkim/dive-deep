# About _raw.260103.md

This is a raw dump file for daily dive on jan-03-2026.

<!-- TOC -->

- [About _raw.260103.md](#about-_raw260103md)
- [Goal: Deploy `athenz/k8s-athenz-syncer` by Jan 3 08:00](#goal-deploy-athenzk8s-athenz-syncer-by-jan-3-0800)
  - [Setup: Clone the repo](#setup-clone-the-repo)
  - [Setup: Try to deploy the AthenZ CRD](#setup-try-to-deploy-the-athenz-crd)
    - [Dive: Create a commit](#dive-create-a-commit)
  - [Setup: Create k8s sa](#setup-create-k8s-sa)
    - [Dive: Write a instruction for namespace & modify correctly](#dive-write-a-instruction-for-namespace--modify-correctly)
  - [Setup: cr and crb](#setup-cr-and-crb)
    - [Next Step: Brain-dead deploy the deployment](#next-step-brain-dead-deploy-the-deployment)

<!-- /TOC -->


# Goal: Deploy `athenz/k8s-athenz-syncer` by Jan 3 08:00

## Setup: Clone the repo

```sh
git clone https://github.com/AthenZ/k8s-athenz-syncer.git k8s_athenz_syncer
```

## Setup: Try to deploy the AthenZ CRD

I treid to create the AthenZ CRD first, but the following error occurred:

```sh
git clone https://github.com/AthenZ/k8s-athenz-syncer.git k8s_athenz_syncer
kubectl apply -f k8s_athenz_syncer/k8s/athenzdomain.yaml

# error: resource mapping not found for name: "athenzdomains.athenz.io" namespace: "" from "k8s_athenz_syncer/k8s/athenzdomain.yaml": no matches for kind "CustomResourceDefinition" in version "apiextensions.k8s.io/v1beta1"
# ensure CRDs are installed first
```

### Dive: Create a commit

Made the following commit, and fixed it:

https://github.com/mlajkim/k8s-athenz-syncer/commit/305902d2114846f5a239955b320ca78c51821d93

Then:

```sh
kubectl apply -f k8s_athenz_syncer/k8s/athenzdomain.yaml
# customresourcedefinition.apiextensions.k8s.io/athenzdomains.athenz.io created
```

## Setup: Create k8s sa

```sh
kubectl apply -f k8s_athenz_syncer/k8s/serviceaccount.yaml
# Error from server (NotFound): error when creating "k8s_athenz_syncer/k8s/serviceaccount.yaml": namespaces "kube-yahoo" not found
```

### Dive: Write a instruction for namespace & modify correctly

Create the [commit](https://github.com/mlajkim/k8s-athenz-syncer/commit/2f4f5b89751f1d88267b09b4d3d565deac1f06d0) and was able to do the following:


```sh
kubectl apply -f k8s/namespace.yaml
# namespace/hekube-k8s-athenz-syncer configured
```

```sh
kubectl apply -f k8s/serviceaccount.yaml
# serviceaccount/k8s-athenz-syncer created
```

## Setup: cr and crb

It worked no problem:

```sh
kubectl apply -f k8s/clusterrole.yaml
kubectl apply -f k8s/clusterrolebinding.yaml
# clusterrole.rbac.authorization.k8s.io/k8s-athenz-syncer created
# clusterrolebinding.rbac.authorization.k8s.io/k8s-athenz-syncer created
```

### Next Step: Brain-dead deploy the deployment

I know it won't work because there are so many configurations it seems missing, but let's try it out and see:

```sh
kubectl apply -f k8s/deployment.yaml
# deployment.apps/k8s-athenz-syncer created
```
