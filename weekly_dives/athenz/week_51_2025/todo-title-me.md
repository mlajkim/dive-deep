# TODO: TITLE ME

<!-- TOC -->

- [TODO: TITLE ME](#todo-title-me)
  - [Goal](#goal)
  - [Setup](#setup)

<!-- /TOC -->


## Goal

The temporary goal is to build a cluster with Athenz installed, and see


## Setup

Let's first setup the basic Athenz environment. We will use @ctyano's `athenz-distribution` repository:

```sh
test_name=athenz_distribution
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/
cd ~/test_dive

git clone https://github.com/ctyano/athenz-distribution.git $tmp_dir
cd $tmp_dir
ls -al
```