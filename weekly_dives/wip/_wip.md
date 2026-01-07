---
title: 'One-Click Deploy: Simplifying k8s-athenz-syncer Setup'
published: true
tags: # four tags only, no '-' or special characters except
  - athenz
  - kubernetes
  - k8sathenzsyncer
# cover_image: ./thumbnail.png # 🟡 give me thumbnail
---

# Goal

TODO: Write goal here above the line.


Does it modify modifiedDate too? Does it make the performance better?

We should definitely study the details out there.

Also want to learn if I can use this as well:

- `/v1/domain/{domainName}/group/admin`
- `/v1/domain/{domainName}/group/viewer`

<!-- TOC -->

- [cover_image: ./thumbnail.png # 🟡 give me thumbnail](#cover_image-thumbnailpng--🟡-give-me-thumbnail)
- [Goal](#goal)
- [Result](#result)
- [Walkthrough: Setup](#walkthrough-setup)
  - [a.](#a)
- [Walkthrough: Implementation](#walkthrough-implementation)
  - [1.](#1)
- [Walkthrough: Verification](#walkthrough-verification)
  - [I.](#i)
- [What's next?](#whats-next)
- [Dive Hours: XX Hours](#dive-hours-xx-hours)
- [Closing](#closing)

<!-- /TOC -->

# Result

1. Wanted to improve performance when getting members of a role inside a domain including group members and delegated role members.
1. Realized that using `modifedDate` could not be ideal
1. Wanted to learn how Athenz has designed this part
1. Decided to deploy `athenz/athenz-k8s-syncer` to see how it works.

# Walkthrough: Setup

## a.

# Walkthrough: Implementation

## 1.

# Walkthrough: Verification

## I.

# What's next?

# Dive Hours: XX Hours


- `1/1 Thu`: 6.75 Hours
- `1/2 Fri`: 4.75 Hours

# Closing

If you enjoyed this deep dive, please leave a like & subscribe for more!

![cats_thumbs_up](./assets/cats_thumbs_up.png)