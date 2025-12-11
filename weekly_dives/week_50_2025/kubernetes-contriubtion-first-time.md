# Week 50, 2025 Weekly Dive

<!-- TOC -->

- [Week 50, 2025 Weekly Dive](#week-50-2025-weekly-dive)
  - [Where do we dive this week?](#where-do-we-dive-this-week)
  - [What can I do as a first time contributor?](#what-can-i-do-as-a-first-time-contributor)
  - [Where is fieldnamedocscheck used?](#where-is-fieldnamedocscheck-used)
  - [Run fieldnamedocekscheck with zero brain](#run-fieldnamedocekscheck-with-zero-brain)
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

And the AI has found this todo:

```go
// TODO: a manual pass adding back-ticks to the doc strings, then update the linter to
// TODO: check the existence of back-ticks
```

First of all I have no idea what this field_name_docs_check.go does so ... let's just dive in without knowing anything :)

## Where is fieldnamedocscheck used?

So what is fieldnamedocscheck? Let see where this cmd `fieldnamedocscheck` is used:

![fieldnamedocscheck_usage_search](./assets/fieldnamedocscheck_usage_search.png)


## Run fieldnamedocekscheck with zero brain

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