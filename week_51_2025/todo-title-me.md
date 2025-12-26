# 🟡 TODO: TITLE ME

<!-- TOC -->

- [🟡 TODO: TITLE ME](#🟡-todo-title-me)
- [Goal](#goal)
- [Conclusion](#conclusion)
- [Steps for the conclusion](#steps-for-the-conclusion)
  - [Setup](#setup)
    - [Setup: Local Kubernetes Cluster w/ Kind](#setup-local-kubernetes-cluster-w-kind)
      - [Check](#check)
    - [Setup: Athenz Server in Kubernetes Cluster](#setup-athenz-server-in-kubernetes-cluster)
      - [Check](#check-1)
    - [Setup: Athenz ZMS Server Outside](#setup-athenz-zms-server-outside)
      - [Check](#check-2)
    - [Setup: Kubebuilder](#setup-kubebuilder)
  - [Exp1: Create a brute-force approaching](#exp1-create-a-brute-force-approaching)
    - [Exp1: Initialize Syncer Project](#exp1-initialize-syncer-project)
      - [Check: Structure](#check-structure)
    - [Exp1: Initalize git](#exp1-initalize-git)
    - [Exp1: Initalize an API](#exp1-initalize-an-api)
      - [Checl: Structure](#checl-structure)
      - [Check: Domain](#check-domain)
      - [Check: Repo](#check-repo)
    - [Exp1: Define API](#exp1-define-api)
    - [Exp1: Define Spec](#exp1-define-spec)
    - [Exp1: Define yaml](#exp1-define-yaml)
    - [Exp1: Define Controller](#exp1-define-controller)
    - [Exp1: Register CRD](#exp1-register-crd)
      - [Check](#check-3)
    - [Exp1: Run Controller](#exp1-run-controller)
    - [Exp1: Finally create](#exp1-finally-create)
      - [Check: Log from Controller](#check-log-from-controller)
- [Dive Records](#dive-records)

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

> [!TIP]
> Make take few minutes to see the UI up and running.

Let's do this:

```sh
kubectl -n athenz port-forward deployment/athenz-ui 3000:3000

# Forwarding from 127.0.0.1:3000 -> 3000
# Forwarding from [::1]:3000 -> 3000
```

Then open up your browser and go to `http://localhost:3000`. You should see the Athenz UI page:

![athenz_page](./assets/athenz_page.png)

![alt athenz_page](./assets/athenz_page.png)


### Setup: Athenz ZMS Server Outside

```sh
kubectl -n athenz port-forward deployment/athenz-zms-server 4443:4443
```

#### Check

> [!CAUTION]
> For the test, we will use the root certificate but do not use the root certificate for production use.

Try to connect to the ZMS server with auto generated root certificate from `athenz-manifest`:

```sh
curl -k -X GET "https://localhost:4443/zms/v1/domain" \
  --cert ./certs/athenz_admin.cert.pem \
  --key ./keys/athenz_admin.private.pem

# {"names":["home","sys","sys.auth","sys.auth.audit","sys.auth.audit.domain","sys.auth.audit.org","user","user.ajkim","user.dev"]}
```

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

### Exp1: Initalize an API

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

So far we only have boilerplate code, and we need to define the oeperator's:

- Spec: Desired State
- Status: Observed State
- Controller: Reconcile loop that brings the current state to the desired state.


### Exp1: Define Spec

Modify `api/v1/athenzsyncer_types.go`:

```go
type AthenzSyncerSpec struct {
	// INSERT ADDITIONAL SPEC FIELDS - desired state of cluster
	// Important: Run "make" to regenerate code after modifying this file
	// The following markers will use OpenAPI v3 schema to validate the value
	// More info: https://book.kubebuilder.io/reference/markers/crd-validation.html

	// foo is an example field of AthenzSyncer. Edit athenzsyncer_types.go to remove/update
	// +optional
	Foo *string `json:"foo,omitempty"`

	// `athenzDomain` is the Athenz domain to be synced by this AthenzSyncer.
	// It also syncs all the subdomains under this domain.
	AthenzDomain string `json:"athenzDomain"`

	// `zmsURL` is the ZMS endpoint URL of the Athenz server to sycn against
	ZMSURL string `json:"zmsURL"`
}
```


Then:

```sh
make manifests
# "~/test_dive/251226_080757_athenz_distribution/my-athenz-syncer/bin/controller-gen" rbac:roleName=manager-role crd webhook paths="./..." output:crd:artifacts:config=config/crd/bases
```

### Exp1: Define yaml


`config/samples/identity_v1_athenzsyncer.yaml`

```yaml
apiVersion: identity.ajktown.com/v1
kind: AthenzSyncer
metadata:
  labels:
    app.kubernetes.io/name: my-athenz-syncer
    app.kubernetes.io/managed-by: kustomize
  name: athenzsyncer-sample
spec:
  athenzDomain: "athenz-syncer"
  zmsURL: "https://localhost:4443/zms/v1"

```


### Exp1: Define Controller

`internal/controller/athenzsyncer_controller.go`

### Exp1: Register CRD

All the files under `config/crd/bases` are applied:

```sh
make install
...
# customresourcedefinition.apiextensions.k8s.io/athenzsyncers.identity.ajktown.com created
```

#### Check

```sh
k api-resources | grep $domain
# athenzsyncers                                    identity.ajktown.com/v1           true         AthenzSynce
```

### Exp1: Run Controller

> [!TIP]
> Please note that `make run` will build and run the controller outside the cluster.

Controller for now works locally to receive your request:

```sh
make run
# 2025-12-26T11:48:04+09:00	INFO	setup	starting manager
# 2025-12-26T11:48:04+09:00	INFO	starting server	{"name": "health probe", "addr": "[::]:8081"}
# 2025-12-26T11:48:04+09:00	INFO	Starting EventSource	{"controller": "athenzsyncer", "controllerGroup": "identity.ajktown.com", "controllerKind": "AthenzSyncer", "source": "kind source: *v1.AthenzSyncer"}
# 2025-12-26T11:48:04+09:00	INFO	Starting Controller	{"controller": "athenzsyncer", "controllerGroup": "identity.ajktown.com", "controllerKind": "AthenzSyncer"}
# 2025-12-26T11:48:04+09:00	INFO	Starting workers	{"controller": "athenzsyncer", "controllerGroup": "identity.ajktown.com", "controllerKind": "AthenzSyncer", "worker count": 1}
```


### Exp1: Finally create

Finally, create the AthenzSyncer resource:

```sh
kubectl apply -f ./config/samples/identity_v1_athenzsyncer.yaml
# athenzsyncer.identity.ajktown.com/athenzsyncer-sample created
```

#### Check: Log from Controller

🟡 TODO: Fix the fire

```sh
2025-12-26T11:52:38+09:00	INFO	Reconciling AthenzSyncer ...	{"controller": "athenzsyncer", "controllerGroup": "identity.ajktown.com", "controllerKind": "AthenzSyncer", "AthenzSyncer": {"name":"athenzsyncer-sample","namespace":"default"}, "namespace": "default", "name": "athenzsyncer-sample", "reconcileID": "f5431c86-a12a-414e-a242-83744a3139bb", "AthenzSyncer": {"name":"athenzsyncer-sample","namespace":"default"}, "Target": "athenz-syncer", "URL": "https://localhost:4443/zms/v1"}
2025-12-26T11:52:38+09:00	ERROR	🔥 Failed to connect to Athenz Server	{"controller": "athenzsyncer", "controllerGroup": "identity.ajktown.com", "controllerKind": "AthenzSyncer", "AthenzSyncer": {"name":"athenzsyncer-sample","namespace":"default"}, "namespace": "default", "name": "athenzsyncer-sample", "reconcileID": "f5431c86-a12a-414e-a242-83744a3139bb", "error": "Get \"https://localhost:4443/zms/v1/domain/athenz-syncer\": dial tcp [::1]:4443: connect: connection refused"}
github.com/mlajkim/athenz-syncer/internal/controller.(*AthenzSyncerReconciler).Reconcile
	/Users/jekim/test_dive/251226_080757_athenz_distribution/my-athenz-syncer/internal/controller/athenzsyncer_controller.go:75
sigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller[...]).Reconcile
	/Users/jekim/go/pkg/mod/sigs.k8s.io/controller-runtime@v0.22.4/pkg/internal/controller/controller.go:216
sigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller[...]).reconcileHandler
	/Users/jekim/go/pkg/mod/sigs.k8s.io/controller-runtime@v0.22.4/pkg/internal/controller/controller.go:461
sigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller[...]).processNextWorkItem
	/Users/jekim/go/pkg/mod/sigs.k8s.io/controller-runtime@v0.22.4/pkg/internal/controller/controller.go:421
sigs.k8s.io/controller-runtime/pkg/internal/controller.(*Controller[...]).Start.func1.1
	/Users/jekim/go/pkg/mod/sigs.k8s.io/controller-runtime@v0.22.4/pkg/internal/controller/controller.go:296
```


<!-- 🟡 TODO: Give me time: # Dive Records: 15h -->

# Dive Records

- `12/26 Fri`: 4.5h