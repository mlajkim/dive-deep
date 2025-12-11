# Week 50, 2025 Weekly Dive

<!-- TOC -->

- [Week 50, 2025 Weekly Dive](#week-50-2025-weekly-dive)
  - [Where do we dive this week?](#where-do-we-dive-this-week)
  - [What can I do as a first time contributor?](#what-can-i-do-as-a-first-time-contributor)
  - [What is fieldnamedocscheck?](#what-is-fieldnamedocscheck)
  - [Where is fieldnamedocscheck used?](#where-is-fieldnamedocscheck-used)
    - [Zero-brain Run `verify-fieldname-docs.sh`](#zero-brain-run-verify-fieldname-docssh)
      - [Disects each code of the 60 lines of sh](#disects-each-code-of-the-60-lines-of-sh)
        - [Disection: Safety check](#disection-safety-check)
        - [Disection: KUBE_ROOT setup](#disection-kube_root-setup)
          - [Di-Disection: Can you run somewhere else with this logic?](#di-disection-can-you-run-somewhere-else-with-this-logic)
          - [We can't fix the path issue](#we-cant-fix-the-path-issue)
        - [Disection: go language check](#disection-go-language-check)
        - [Disection: store every type.go](#disection-store-every-typego)
  - [Zero-brain Run fieldnamedocekscheck](#zero-brain-run-fieldnamedocekscheck)
  - [What is that `-s` flag?](#what-is-that--s-flag)
    - [Can we get a help command for that `-s` flag, without looking at the source code?](#can-we-get-a-help-command-for-that--s-flag-without-looking-at-the-source-code)
  - [Successfully runned with `-s`!](#successfully-runned-with--s)

<!-- /TOC -->

## Where do we dive this week?

I want to be a part of Contriubtor in kubernetes

![kubernetes_contributors](./assets/kubernetes_contributors.png)

And eventually have the `@kubernetes` handle in GitHub:
![personal_kubernetes](./assets/personal_kubernetes.png)


## What can I do as a first time contributor?

So I've git cloned the kubernetes repository without thinking too much, but still have no idea what to fix.

So I asked AI inside the project, what kind of things I can fix as a first time contributor (basically easy stuff)

And the AI has found this todo inside `fieldnamedocscheck`:

```go
// TODO: a manual pass adding back-ticks to the doc strings, then update the linter to
// TODO: check the existence of back-ticks
```

First of all I have no idea what this field_name_docs_check.go does so ... let's just dive in without knowing anything :)

## What is fieldnamedocscheck?

It seems like it checks if the fields in the types are properly documented or not.

## Where is fieldnamedocscheck used?

So what is fieldnamedocscheck? Let see where this cmd `fieldnamedocscheck` is used:

![fieldnamedocscheck_usage_search](./assets/fieldnamedocscheck_usage_search.png)

### Zero-brain Run `verify-fieldname-docs.sh`

> ![NOTE]
> You may be asked to run `brew install bash` if your bash version is insufficient

This script has checked 64 lines of output:

```sh
./hack/verify-fieldname-docs.sh
# Checking ./staging/src/k8s.io/kube-aggregator/pkg/apis/apiregistration/v1
# Checking ./staging/src/k8s.io/kube-aggregator/pkg/apis/apiregistration/v1beta1
# Checking ./staging/src/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
# Checking ./staging/src/k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1beta1
# Checking ./staging/src/k8s.io/api/rbac/v1
# Checking ./staging/src/k8s.io/api/rbac/v1beta1
# Checking ./staging/src/k8s.io/api/rbac/v1alpha1
# Checking ./staging/src/k8s.io/api/apiserverinternal/v1alpha1
# ...
```

#### Disects each code of the 60 lines of sh

Let's open the `verify-fieldname-docs.sh` file and dissect each code.

##### Disection: Safety check

```sh
set -o errexit
set -o nounset
set -o pipefail
```

- `errexit` : Exit immediately if a command exits with a non-zero status
- `nounset` : Treat unset variables as an error when substituting
- `pipefail`: Prevent errors in a pipeline from being masked



##### Disection: KUBE_ROOT setup

> [!TIPS]
> Once you `echo $KUBE_ROOT`, you will get `./hack/..` as a sample.
> That `..` at the end
```sh
KUBE_ROOT=$(dirname "${BASH_SOURCE[0]}")/.. # i.e) ./hack/.. or ../../..
source "${KUBE_ROOT}/hack/lib/init.sh"
source "${KUBE_ROOT}/hack/lib/util.sh"
```

###### Di-Disection: Can you run somewhere else with this logic?

In conclusion, we need to run the `verify-fieldname-docs.sh` from the base directory of kubernetes repository.

```sh
./oss_workspace/oss_kubernetes/hack/verify-fieldname-docs.sh
# KUBE_ROOT=./oss_workspace/oss_kubernetes/hack/..
# go: go.mod file not found in current directory or any parent directory; see 'go help modules'
```

```sh
../../verify-fieldname-docs.sh
# KUBE_ROOT=../../..
# stat ~/oss_workspace/oss_kubernetes/hack/hello/can/cmd/fieldnamedocscheck: directory not found
```

```sh
./verify-fieldname-docs.sh
# KUBE_ROOT=./..
# stat ~/oss_workspace/oss_kubernetes/hack/cmd/fieldnamedocscheck: directory not found
```

###### We can't fix the path issue

Since this chunk of code is used, I do not think we can modify this:

![the_same_code_for_source](./assets/the_same_code_for_source.png)


##### Disection: go language check

Checks if golang sufficient environment is set

```sh
kube::golang::setup_env
```

##### Disection: store every type.go

Store every `type.go` files inside `versioned_api_files` variable:

```sh
versioned_api_files=$(find_files) || true
```


## Zero-brain Run fieldnamedocekscheck

> ![NOTE]
> It is important to give a shot even if you don't know what you are doing :)

```sh
cd /cmd/fieldnamedocscheck
go run field_name_docs_check.go
# F1211 11:49:45.848446   80482 field_name_docs_check.go:33] Please define -s flag as it is the api type file
# exit status 255
```

## What is that `-s` flag?

Not officially, probably, it is a type source file, it seems:

```go
typeSrc = flag.StringP("type-src", "s", "", "From where we are going to read the types")
```

```go
if *typeSrc == "" {
  klog.Fatalf("Please define -s flag as it is the api type file")
}
```

### Can we get a help command for that `-s` flag, without looking at the source code?

```sh
go run field_name_docs_check.go --help
Usage of ~/Library/Caches/go-build/81/..hash../-d/field_name_docs_check:
  -s, --type-src string   From where we are going to read the types
```


## Successfully runned with `-s`!

>[!NOTE]
> If nothing happens, it means all the fields are properly documented :)

```sh
go run field_name_docs_check.go -s ../../staging/src/k8s.io/api/core/v1/types.go
```