# TODO: TITLE ME

<!-- TOC -->

- [TODO: TITLE ME](#todo-title-me)
  - [Goal](#goal)
  - [Setup](#setup)
    - [Setup: Local Kubernetes Cluster w/ Kind](#setup-local-kubernetes-cluster-w-kind)
      - [Check](#check)
    - [Setup: Athenz Server in Kubernetes Cluster](#setup-athenz-server-in-kubernetes-cluster)
      - [Check](#check-1)

<!-- /TOC -->


## Goal

The temporary goal is to build a cluster with Athenz installed, and see


## Setup

### Setup: Local Kubernetes Cluster w/ Kind

First of all, we need a kubernetes cluster running locally. We will use `kind` (Kubernetes IN Docker) to create a local cluster.

![kind_cncf_homepage](./assets/kind_cncf_homepage.png)

https://kind.sigs.k8s.io/

```sh
kind create cluster

# Creating cluster "kind" ...
#  ✓ Ensuring node image (kindest/node:v1.34.0) 🖼
#  ✓ Preparing nodes 📦
#  ✓ Writing configuration 📜
#  ✓ Starting control-plane 🕹️
#  ✓ Installing CNI 🔌
#  ✓ Installing StorageClass 💾
# Set kubectl context to "kind-kind"
# You can now use your cluster with:

# kubectl cluster-info --context kind-kind

# Have a question, bug, or feature request? Let us know! https://kind.sigs.k8s.io/#community 🙂
```

#### Check

```sh
k cluster-info
# Kubernetes control plane is running at https://127.0.0.1:55629
# CoreDNS is running at https://127.0.0.1:55629/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

# To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```

### Setup: Athenz Server in Kubernetes Cluster

Let's first setup the basic Athenz environment. We will use @ctyano's `athenz-distribution` repository:

```sh
test_name=athenz_distribution
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/
cd ~/test_dive

git clone https://github.com/ctyano/athenz-distribution.git $tmp_dir
cd $tmp_dir
make clean-kubernetes-athenz deploy-kubernetes-athenz

# Lots of log ...
# kubectl apply -k athenz-ui/kustomize
# namespace/athenz unchanged
# configmap/athenz-ui-config created
# secret/athenz-admin-keys configured
# secret/athenz-ui-keys created
# service/athenz-ui created
# deployment.apps/athenz-ui created
```


#### Check

Let's do this:

```sh
kubectl -n athenz port-forward deployment/athenz-ui 3000:3000

# Forwarding from 127.0.0.1:3000 -> 3000
# Forwarding from [::1]:3000 -> 3000
```

Then open up your browser and go to `http://localhost:3000`. You should see the Athenz UI page:

![athenz_page](./assets/athenz_page.png)