# TODO: TITLE ME

<!-- TOC -->

- [TODO: TITLE ME](#todo-title-me)
- [Goal](#goal)
- [Conclusion](#conclusion)
- [Steps for the conclusion](#steps-for-the-conclusion)
  - [Setup](#setup)
    - [Setup: Local Kubernetes Cluster w/ Kind](#setup-local-kubernetes-cluster-w-kind)
      - [Check](#check)
    - [Setup: Athenz Server in Kubernetes Cluster](#setup-athenz-server-in-kubernetes-cluster)
      - [Check](#check-1)
    - [Setup: Kubebuilder](#setup-kubebuilder)
  - [Exp1: Create a brute-force approaching](#exp1-create-a-brute-force-approaching)
    - [Exp1: Initialize Syncer Project](#exp1-initialize-syncer-project)
      - [Check: Structure](#check-structure)
    - [Exp1: Initalize git](#exp1-initalize-git)
    - [Exp1: Initalize a API](#exp1-initalize-a-api)
      - [Checl: Structure](#checl-structure)
      - [Check: Domain](#check-domain)
      - [Check: Repo](#check-repo)
    - [Exp1: Define API](#exp1-define-api)

<!-- /TOC -->


# Goal

The temporary goal is to build a cluster with Athenz installed, and see



🟡 TODO: The following is temporary:

You guys want to leanr about it but have no idea right? here is the tutorial for you all :)

The goal of this document is to setup a syncer mechanism between Athenz and Kubernettes RBAC by:
- Make really
- Make a custom syncer that syncs from Athenz to K8s RBAC (Good Challenge & Learn a lot about both Athenz and K8s RBAC) only by ZMS
- Then learn how to deploy k8s-athenz-syncer properly with good UI UX and how it is differ
- We can also see what is better and what is missing in the k8s-athenz-sycner and possibly contribute back.
- Maybe I can mock creating the same cluster!

1. Create the similar one only with ZMS API and see how it affects the k8s-athenz-syncer

- /domain?prefix={athenzDomain}   (ex: /domain?prefix=shared-kubernetes-cluster-helper)
- /domain/{domainName}/role/{roleName}?auditLog=true&expand=true


1. Learn about the core logic of https://github.com/AthenZ/k8s-athenz-syncer with deployment examples
1. Maybe create a very simple deployer for the k8s-athenz-syncer with good UI UX to really make others be able to test => Learn a lot from athenz distribution as I can test Athenz so easy.


🟡 Everything above is temporary (note purpose)

# Conclusion

🟡 TODO Write me

# Steps for the conclusion

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

### Setup: Kubebuilder

If you do not have `kubebuilder` yet, please install it first:

```sh
brew install kubebuilder
```


## Exp1: Create a brute-force approaching

Let's first create something that works, but not elegant *yet*.

https://kubernetes.io/docs/concepts/extend-kubernetes/operator/

![kubernetes_operator](./assets/kubernetes_operator.png)


![kube_builder](./assets/kube_builder.png)
https://book.kubebuilder.io/


### Exp1: Initialize Syncer Project

> [!TIP]
> As the `init` implies, you only run once for one repository, and you simply create apis under the same repository.

- `domain`: k8s already has `Pod`, `SA`, `Role`, `RoleBinding`, so we need to specify our own ID so that it does not conflict with existing ones.

```sh
domain="ajktown.com"
repo="github.com/mlajkim/athenz-syncer"

mkdir -p my-athenz-syncer && cd my-athenz-syncer
kubebuilder init --domain $domain --repo $repo &> /dev/null
# Lots of log...
# go: downloading github.com/cenkalti/backoff/v4 v4.3.0
# go: downloading github.com/grpc-ecosystem/grpc-gateway/v2 v2.26.3
# go: downloading go.opentelemetry.io/otel/sdk/metric v1.34.0
# Next: define a resource with:
# $ kubebuilder create api
```

#### Check: Structure

Let' see what kind of file structure we have now:

```sh
tree .
# .
# ├── Dockerfile
# ├── Makefile
# ├── PROJECT
# ├── README.md
# ├── cmd
# │   └── main.go
# ├── config
# │   ├── default
# │   │   ├── cert_metrics_manager_patch.yaml
# │   │   ├── kustomization.yaml
# │   │   ├── manager_metrics_patch.yaml
# │   │   └── metrics_service.yaml
# │   ├── manager
# │   │   ├── kustomization.yaml
# │   │   └── manager.yaml
# │   ├── network-policy
# │   │   ├── allow-metrics-traffic.yaml
# │   │   └── kustomization.yaml
# │   ├── prometheus
# │   │   ├── kustomization.yaml
# │   │   ├── monitor.yaml
# │   │   └── monitor_tls_patch.yaml
# │   └── rbac
# │       ├── kustomization.yaml
# │       ├── leader_election_role.yaml
# │       ├── leader_election_role_binding.yaml
# │       ├── metrics_auth_role.yaml
# │       ├── metrics_auth_role_binding.yaml
# │       ├── metrics_reader_role.yaml
# │       ├── role.yaml
# │       ├── role_binding.yaml
# │       └── service_account.yaml
# ├── go.mod
# ├── go.sum
# ├── hack
# │   └── boilerplate.go.txt
# └── test
#     ├── e2e
#     │   ├── e2e_suite_test.go
#     │   └── e2e_test.go
#     └── utils
#         └── utils.go
```

### Exp1: Initalize git

To track progress, let's initialize git:

```sh
git init
git add .
git commit -m "Initial commit: Initialize kubebuilder project"
```

### Exp1: Initalize a API

The full name will be: `<group>.<domain>/<version>, Kind=<kind>`, as:

```yaml
apiVersion: identity.ajktown.com/v1
kind: AthenzSyncer
...
```

```sh
group="identity"
version="v1"
kind="AthenzSyncer"

kubebuilder create api --group $group --version $version --kind $kind --resource --controller
```


#### Checl: Structure

```sh
tree .
# .
# ├── Dockerfile
# ├── Makefile
# ├── PROJECT
# ├── README.md
# ├── api
# │   └── v1
# │       ├── athenzsyncer_types.go
# │       ├── groupversion_info.go
# │       └── zz_generated.deepcopy.go
# ├── bin
# │   ├── controller-gen -> /Users/jekim/test_dive/251226_080757_athenz_distribution/my-athenz-syncer/bin/controller-gen-v0.19.0
# │   └── controller-gen-v0.19.0
# ├── cmd
# │   └── main.go
# ├── config
# │   ├── crd
# │   │   ├── kustomization.yaml
# │   │   └── kustomizeconfig.yaml
# │   ├── default
# │   │   ├── cert_metrics_manager_patch.yaml
# │   │   ├── kustomization.yaml
# │   │   ├── manager_metrics_patch.yaml
# │   │   └── metrics_service.yaml
# │   ├── manager
# │   │   ├── kustomization.yaml
# │   │   └── manager.yaml
# │   ├── network-policy
# │   │   ├── allow-metrics-traffic.yaml
# │   │   └── kustomization.yaml
# │   ├── prometheus
# │   │   ├── kustomization.yaml
# │   │   ├── monitor.yaml
# │   │   └── monitor_tls_patch.yaml
# │   ├── rbac
# │   │   ├── athenzsyncer_admin_role.yaml
# │   │   ├── athenzsyncer_editor_role.yaml
# │   │   ├── athenzsyncer_viewer_role.yaml
# │   │   ├── kustomization.yaml
# │   │   ├── leader_election_role.yaml
# │   │   ├── leader_election_role_binding.yaml
# │   │   ├── metrics_auth_role.yaml
# │   │   ├── metrics_auth_role_binding.yaml
# │   │   ├── metrics_reader_role.yaml
# │   │   ├── role.yaml
# │   │   ├── role_binding.yaml
# │   │   └── service_account.yaml
# │   └── samples
# │       ├── identity_v1_athenzsyncer.yaml
# │       └── kustomization.yaml
# ├── go.mod
# ├── go.sum
# ├── hack
# │   └── boilerplate.go.txt
# ├── internal
# │   └── controller
# │       ├── athenzsyncer_controller.go
# │       ├── athenzsyncer_controller_test.go
# │       └── suite_test.go
# └── test
#     ├── e2e
#     │   ├── e2e_suite_test.go
#     │   └── e2e_test.go
#     └── utils
#         └── utils.go

# 19 directories, 46 files
```

#### Check: Domain

Check domain:

```sh
head -n 1 config/samples/identity_v1_athenzsyncer.yaml
# apiVersion: identity.ajktown.com/v1
```

#### Check: Repo

You can see your domain and repo in the `go.mod` file:

```sh
head -n 1 go.mod
# module github.com/mlajkim/athenz-syncer
```


### Exp1: Define API

So far we only have boilerplate code, and we need to define our own:

- Spec: Desired State
- Status: Observed State
- Controller: Reconcile loop that brings the current state to the desired state.


