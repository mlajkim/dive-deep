---
tags:
- 🟡 todo-requires-hands-on-tested
---

# git

<!-- TOC -->

- [git](#git)
  - [Overview](#overview)
    - [delete branch: git branch --delete testing](#delete-branch-git-branch---delete-testing)
    - [git log --raw](#git-log---raw)

<!-- /TOC -->

## Overview


```sh
git add *.cpp

# root@caleston-lp10 kode on  master [+?] ➜  git commit -m "Added C++ files"
# [master (root-commit) ae3a3a3] Added C++ files
#  2 files changed, 0 insertions(+), 0 deletions(-)
#  create mode 100644 file1.cpp
#  create mode 100644 file2.cpp
```


### delete branch: git branch --delete testing

```sh
git branch --delete testing
```



###  git log --raw

```sh
git log --raw
# commit 9c06d2b4a331f6ae8195cb67134fc6703e51fe81 (HEAD -> master)
# Author: Bob <bob@kodekloud.com>
# Date:   Fri Dec 19 02:02:18 2025 +0000

#     Modified a project file

# :100644 100644 e69de29 a11f211 M        file2.cpp
```