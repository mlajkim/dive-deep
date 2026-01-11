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
    - [Test](#test)
  - [Setup: Clone k8s-athenz-syncer](#setup-clone-k8s-athenz-syncer)
  - [Setup: Build image](#setup-build-image)
  - [Setup: Load image to kind cluster](#setup-load-image-to-kind-cluster)
  - [Setup: Deploy manifests](#setup-deploy-manifests)
  - [Setup: Create a secret to represent `k8s-athenz-syncer`](#setup-create-a-secret-to-represent-k8s-athenz-syncer)
  - [Setup: Create our custom deployment](#setup-create-our-custom-deployment)
- [What's next?](#whats-next)
- [Dive Hours: XX Hours](#dive-hours-xx-hours)
- [Closing](#closing)

<!-- /TOC -->

# Result

1. k9s: Quickly show runnning syncer
1. k9s: Quickly show current `athenzdomani` => Nothing shows
1. Web: Create domain with UI
1. Web: Create a role as a sample "can-i-see-this-role-in-crd"
1. Web: Maybe add a user
1. cli: Create a namespace that represents the domain
1. k9s: Shows that `athenzdoain` is created
1. Read the yaml of the domain with `d`
1. Note that it is well synced

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

> [!WARNING]
> The following script only works on macOS. Let me know in comments if you want to use other platforms.

Let's set up Kubernetes cluster locally and install Athenz server:

```sh
git clone https://github.com/mlajkim/dive-manifest.git manifest
make -C manifest setup
```

### Test

Let's quickly see if we really have athenz server running:

```sh
kubectl get pods -n athenz
```

## Setup: Set UI for web page 

To test as the result, let's quickly set up so that we can see in browser:

```sh
kubectl -n athenz port-forward deployment/athenz-ui 3000:3000
```


### Test

Open the UI in browser:

```sh
open http://localhost:3000
```

## Setup: Clone k8s-athenz-syncer

> [!NOTE]
> Once the PR https://github.com/AthenZ/k8s-athenz-syncer/pull/45 is released, we will use `mlajkim`'s fork.

```sh
git clone -b fix/deprecated-Dockerfile-images-and-CRD-definition-API https://github.com/mlajkim/k8s-athenz-syncer.git syncer
```

## Setup: Build image

Let's build the image locally so that we can use it locally:

```sh
(cd syncer && docker build -t local/k8s-athenz-syncer:latest .)
```

## Setup: Load image to kind cluster

Since we are using Kind, we need to load the locally built `k8s-athenz-syncer` image into the cluster:

```sh
kind load docker-image local/k8s-athenz-syncer:latest

# Image: "local/k8s-athenz-syncer:latest" with ID "sha256:bb5bcf2d9c362a46444f9476791f6c9e3f81ce6abf6ebc07d3228b9b7da53fa8" not yet present on node "kind-control-plane", loading...
```


## Setup: Deploy manifests

> [!TIP]
> For the detailed explanation of each command, please refer to the [following](https://github.com/mlajkim/k8s-athenz-syncer/tree/fix/deprecated-Dockerfile-images-and-CRD-definition-API?tab=readme-ov-file#install)

> [!WARNING]
> Please we will create our own `deployment.yaml` as the OSS sample requires custom settings that could be a bit tricky to set up quick.

```sh
kubectl create ns kube-yahoo
kubectl apply -f ./syncer/k8s/athenzdomain.yaml
kubectl apply -f ./syncer/k8s/serviceaccount.yaml
kubectl apply -f ./syncer/k8s/clusterrole.yaml
kubectl apply -f ./syncer/k8s/clusterrolebinding.yaml
```

### Test

> [!TIP]
> It is okay to have "No resources found", as the syncer, that manages the `AthenzDomain`, is not yet deployed

The apply above creates a CRD `AthenzDomain` (Shortened to `domain`), so let's quickly check:

```sh
kubectl get domain

# No resources found
```

## Setup: Create a secret to represent `k8s-athenz-syncer`

Unlike the OSS component where it uses [CopperArgos](https://github.com/AthenZ/athenz/blob/master/docs/copper_argos.md) to auto-distribute X.509 certificate to represent the `k8s-athenz-syncer` as an Athenz service, for quick demo we will simply use the root certificate given.

```sh
kubectl create secret generic k8s-athenz-syncer-cert \
  -n kube-yahoo \
  --from-file=cert.pem=./athenz/certs/athenz_admin.cert.pem \
  --from-file=key.pem=./athenz/keys/athenz_admin.private.pem \
  --from-file=ca.pem=./athenz/certs/ca.cert.pem

# secret/k8s-athenz-syncer-cert created
```

## Setup: Create our custom deployment

> [!NOTE]
> Please note that:
> - we can set `athenz-zms-server.athenz` because we are sharing the same kubernetes cluster with Athenz server.
> - we set `update-cron=5s` to quickly see the result

As explained above, since we want the quick set up and want the working `k8s-athenz-syncer`, we will create our own `deployment.yaml`, with a SecretVolume defined above:

```sh
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: k8s-athenz-syncer
  namespace: kube-yahoo
  labels:
    app: k8s-athenz-syncer
spec:
  replicas: 1
  selector:
    matchLabels:
      app: k8s-athenz-syncer
  strategy:
    rollingUpdate:
      maxSurge: 50%
      maxUnavailable: 0%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: k8s-athenz-syncer
    spec:
      containers:
      - name: syncer
        image: local/k8s-athenz-syncer
        imagePullPolicy: IfNotPresent
        resources:
          limits:
            cpu: 1
            memory: 1Gi
          requests:
            cpu: 1
            memory: 1Gi
        args:
        - --zms-url=https://athenz-zms-server.athenz:4443/zms/v1
        - update-cron=5s
        - --cert=/var/run/athenz/cert.pem
        - --key=/var/run/athenz/key.pem
        - --cacert=/var/run/athenz/ca.pem
        - --exclude-namespaces=kube-system,kube-public,kube-k8s-athenz-syncer,default,local-path-storage,kube-node-lease,athenz,ajktown-api,kube-yahoo
        volumeMounts:
        - name: athenz-certs
          mountPath: /var/run/athenz
          readOnly: true
      serviceAccountName: k8s-athenz-syncer
      volumes:
      - name: athenz-certs
        secret:
          secretName: k8s-athenz-syncer-cert
EOF

# deployment.apps/k8s-athenz-syncer created
```

## Verify: Does it work?

Please refer to the [Result](#result) section above to see the verification steps and outcome.


# What's next?

# Dive Hours: XX Hours


- `1/1 Thu`: 6.75 Hours
- `1/2 Fri`: 4.75 Hours
- `1/3 Sat`: ...
- `1/11 Sun`: ...

With:

- https://github.com/mlajkim/dive-manifest/pull/1

# Closing

If you enjoyed this deep dive, please leave a like & subscribe for more!

![cats_thumbs_up](./assets/cats_thumbs_up.png)