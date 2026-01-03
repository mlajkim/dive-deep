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
  - [Setup: Create certificate as k8s secret instead](#setup-create-certificate-as-k8s-secret-instead)
  - [Create docker image locally](#create-docker-image-locally)
    - [Dive: Improve Dockerfile](#dive-improve-dockerfile)
  - [Setup: Create Deploy](#setup-create-deploy)
  - [Verify: Syncs every minute](#verify-syncs-every-minute)

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

## Setup: Create certificate as k8s secret instead

The sample deployment requires `athenz-sia` which is fine, but again


Create secret with cert filed inserted:

```sh
kubectl create secret generic k8s-athenz-syncer-cert \
  -n kube-k8s-athenz-syncer \
  --from-file=cert.pem=./athenz_distribution/certs/athenz_admin.cert.pem \
  --from-file=key.pem=./athenz_distribution/keys/athenz_admin.private.pem \
  --from-file=ca.pem=./athenz_distribution/certs/ca.cert.pem

# secret/k8s-athenz-syncer-cert created
```

## Create docker image locally

```sh
go mod tidy
docker build -t local/k8s-athenz-syncer:latest .
kind load docker-image local/k8s-athenz-syncer:latest
```

### Dive: Improve Dockerfile

Had the following problem:

- Very old golang version `1.14` => `1.25`


## Setup: Create Deploy

```sh
kubectl apply -f k8s/mydeploy.yaml
# deployment.apps/k8s-athenz-syncer created
```

## Verify: Syncs every minute


**Create subdomain**

After creating the a namespace called `ajktown-db`, it synced `ajktown.db` as the following:

```sh
kg domain
NAME          AGE
# ajktown.api   28m
# ajktown.db    47s
```

You can also describe the domain:

```sh
kubectl describe domain ajktown.api
# Name:         ajktown.api
# Namespace:
# Labels:       <none>
# Annotations:  <none>
# API Version:  athenz.io/v1
# Kind:         AthenzDomain
# Metadata:
#   Creation Timestamp:  2026-01-02T21:11:14Z
#   Generation:          3
#   Resource Version:    757982
#   UID:                 fb7bbab3-5150-4833-af83-77bfde09de45
# Spec:
#   Domain:
#     Account:
#     Application Id:
#     Audit Enabled:       false
#     Azure Subscription:
#     Business Service:
#     Cert Dns Domain:
#     Description:         AJK Town API Subdomain
# ...
```
