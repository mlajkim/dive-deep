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

> [!TIP]
> In hurry? Jump directly to [Result](#result) section to see the outcome of this dive.

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
  - [Setup: AWS SES Recipient Setup](#setup-aws-ses-recipient-setup)
    - [Setup: Open AWS SES Console](#setup-open-aws-ses-console)
  - [Setup: Get AWS SES SMTP Credentials](#setup-get-aws-ses-smtp-credentials)
    - [Setup: Get Smtp credentials](#setup-get-smtp-credentials)
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

```sh
git clone https://github.com/mlajkim/athenz-amazon-ses-notification-plugin.git plugin
```

## Setup: AWS SES Recipient Setup

First, we need to set up **trusted** email addresses in AWS SES. AWS restricts sending emails to unverified addresses to prevent them from being flagged as spam. Therefore, we must first verify the email addresses we intend to use. For this example, we will simply use our personal email address:

![setup_allowed_email](./assets/setup_allowed_email.png)


### Setup: Open AWS SES Console



Open [Amazon SES Console's identity management page](https://ap-northeast-1.console.aws.amazon.com/ses/home?region=ap-northeast-1#/identities), and hit the `Create identity` button:

![aws_ses_create_identity](./assets/aws_ses_create_identity.png)

Select `Email address` as identity type, and input your personal email address that you want to use it as the recipient of Athenz notification emails:

![create_identity](./assets/create_identity.png)

You will shortly receive a verification email from AWS SES. Open the email and click the `Verify email address` button to complete the verification process:

![verify_email](./assets/verify_email.png)

## Setup: Get AWS SES SMTP Credentials

For Athenz Server to connect to the public AWS SES service, we need to create SMTP credentials that Athenz server will use to authenticate itself when sending emails via AWS SES:

![set_smtp_credentials_architecture](./assets/set_smtp_credentials_architecture.png)


### Setup: Get Smtp credentials

Click `Create SMTP Credentials` button on the [SMTP Settings page](https://ap-northeast-1.console.aws.amazon.com/ses/home?region=ap-northeast-1#/smtp):

![set_smtp_credentials](./assets/set_smtp_credentials.png)

Store the generated username and password somewhere safe, as we will need them later when creating Kubernetes secret:

![username_and_password](./assets/username_and_password.png)

## Setup: Create secret for AWS SES

With the `STMP Username` and `SMTP Password` we just created, we can now create a Kubernetes secret that will store these credentials securely. The plugin repo contains a Makefile target that automates this process for us. Simply run the following command:

```sh
make -C plugin create-aws-ses-secret
```

![create_aws_ses_secret_result](./assets/create_aws_ses_secret_result.png)

## Setup: Build jar and deploy plugin as configmap in Kubernetes

![build_plugin](./assets/build_plugin.png)

We will build the plugin (as RedBox) jar file and deploy it as a configmap in our local Kubernetes cluster. The plugin repo contains a Makefile target that automates this process for us. Simply run the following command:

```sh
make -C plugin deploy
```

![make_deploy_result](./assets/make_deploy_result.png)

## Setup: Modify Athenz ZMS Server Deployment to use the Plugin and Secret

We have the following ready so far:
- AWS SES SMTP Credentials stored as Kubernetes Secret
- Athenz Notification Plugin stored as Kubernetes ConfigMap

Now we need to let ZMS Server know about these resources by modifying its deployment manifest. The plugin repo contains a Makefile target that automates this process for us. Simply run the following command:

```sh
make -C plugin patch
```

![alt patch_zms_deployment](./assets/patch_zms_deployment.png)

## Verify: Does it work?

# What's next?

# Dive Hours

# Closing

