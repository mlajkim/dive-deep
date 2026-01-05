---
title: 'Integrate Athenz Notification Feature with AWS SES'
published: true
tags:
  - athenz
  - aws
  - simpleemailservice
  - plugin
cover_image: ./thumbnail.png
---

# Goal

I’ve been diving into [Athenz](https://github.com/AthenZ/athenz), an open-source RBAC/ABAC platform, running it on a local Kubernetes ([Kind](https://kind.sigs.k8s.io/)) cluster. Everything was working great until I needed to test the approval workflow.

I looked through official documentations and found out [this "Email Notifications - Athenz"](https://athenz.github.io/athenz/email_notifications/), and they tell me that you can simply utilize already built AWS SES integration if you *only* run your Athenz server on AWS infrastructure, but I was running it locally. So, I had to figure out how to make it work on my own.

The official doc also mentioned as the following that you can build your own notification plugin, so I decided to give it a try:

> This requires Athenz to be deployed on AWS. Users may use other Email Providers by following the steps to Enable [Notifications using other Providers](https://athenz.github.io/athenz/email_notifications/#enable-notifications-using-other-providers)

# General Architecture

This is the general architecture of how the `Athenz Custom Plugin` works:

![plugin_n_aws_sms_architecture](./assets/plugin_n_aws_sms_architecture.png)

# Table of Contents

<!-- TOC -->

- [Goal](#goal)
- [General Architecture](#general-architecture)
- [Table of Contents](#table-of-contents)
- [Result](#result)
- [Setup](#setup)
  - [Setup: Working directory](#setup-working-directory)
  - [Setup: Athenz and Local Kubernetes Cluster](#setup-athenz-and-local-kubernetes-cluster)
  - [Setup: Clone Athenz Plugin](#setup-clone-athenz-plugin)
  - [Setup: AWS SES Configuration](#setup-aws-ses-configuration)
  - [Setup: Create secret for AWS SES](#setup-create-secret-for-aws-ses)
  - [Setup: Build jar and deploy plugin as configmap in Kubernetes](#setup-build-jar-and-deploy-plugin-as-configmap-in-kubernetes)
  - [Setup: Modify Athenz ZMS Server Deployment to use the Plugin and Secret](#setup-modify-athenz-zms-server-deployment-to-use-the-plugin-and-secret)
  - [Verify: Does it work?](#verify-does-it-work)
- [What's next?](#whats-next)
- [Dive Hours](#dive-hours)
- [Closing](#closing)

<!-- /TOC -->

# Result

I was able to successfully build and deploy the custom Athenz notification plugin that integrates with AWS SES for sending email notifications. The plugin listens for specific events in Athenz, such as role membership changes or domain modifications, and triggers email notifications through AWS SES.



# Setup

## Setup: Working directory

```sh
test_name=email_notification_plugin
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

## Setup: Athenz and Local Kubernetes Cluster

## Setup: Clone Athenz Plugin

## Setup: AWS SES Configuration

## Setup: Create secret for AWS SES

```sh
make -C plugin create-aws-ses-secret
```

![create_aws_ses_secret_result](./assets/create_aws_ses_secret_result.png)

## Setup: Build jar and deploy plugin as configmap in Kubernetes

## Setup: Modify Athenz ZMS Server Deployment to use the Plugin and Secret

## Verify: Does it work?

# What's next?

# Dive Hours

# Closing

