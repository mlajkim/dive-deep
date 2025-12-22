---
tags:
- hands-on-tested
---

# jobs

<!-- TOC -->

- [jobs](#jobs)
  - [jobs: get list of background running jobs](#jobs-get-list-of-background-running-jobs)
  - [&: Create a job (running background process)](#-create-a-job-running-background-process)
  - [jobs: check status of background jobs](#jobs-check-status-of-background-jobs)

<!-- /TOC -->


## jobs: get list of background running jobs


## &: Create a job (running background process)


```sh
sleep 100 &
# [1] 65375
#
# Job Number = 1
# Process ID = 65375
```

## jobs: check status of background jobs

```sh
jobs
# [1] 65375
# [1]  + running    sleep 100
```