# About _raw.260105.md

This is a raw dump file for daily dive on jan-05-2026.

<!-- TOC -->

- [About _raw.260105.md](#about-_raw260105md)
- [Goal: Setup email server that sends an email](#goal-setup-email-server-that-sends-an-email)
  - [Conclusion](#conclusion)
  - [Setup](#setup)
    - [Setup: Working directory](#setup-working-directory)
    - [Setup: Kind k8s cluster & Athenz server](#setup-kind-k8s-cluster--athenz-server)
    - [Setup: Clone plugin](#setup-clone-plugin)
    - [Setup: cd to plugin](#setup-cd-to-plugin)
    - [Setup: Successfully mount the jar on ZMS server first with configmap.](#setup-successfully-mount-the-jar-on-zms-server-first-with-configmap)
    - [Setup: Setup email server that sends an email](#setup-setup-email-server-that-sends-an-email)
    - [Setup: prepare id and password](#setup-prepare-id-and-password)
    - [Setup: Create secret in namespace athenz](#setup-create-secret-in-namespace-athenz)
    - [Setup: Modifies configmap of zms server](#setup-modifies-configmap-of-zms-server)
      - [Check: Let's see if the plugin jar is mounted correctly](#check-lets-see-if-the-plugin-jar-is-mounted-correctly)
    - [Setup: Add `zms.config` so that ZMS server can read the plugin](#setup-add-zmsconfig-so-that-zms-server-can-read-the-plugin)
    - [Setup: restart deployment once again so that the config is reloaded](#setup-restart-deployment-once-again-so-that-the-config-is-reloaded)
      - [Check](#check)
  - [Connect to DB](#connect-to-db)

<!-- /TOC -->

# Goal: Setup email server that sends an email

## Conclusion

## Setup

### Setup: Working directory

```sh
test_name=email_notification_plugin
tmp_dir=$(date +%y%m%d_%H%M%S_$test_name)
mkdir -p ~/test_dive/$tmp_dir
cd ~/test_dive/$tmp_dir
```

### Setup: Kind k8s cluster & Athenz server

- Local k8s server setup guide: https://dev.to/mlajkim/stop-using-magic-building-a-kubernetes-operator-from-scratch-mo2#a-local-kubernetes-cluster-kind
- Local athenz server setup guide: https://dev.to/mlajkim/stop-using-magic-building-a-kubernetes-operator-from-scratch-mo2#b-deploy-athenz-server


### Setup: Clone plugin

```sh
git clone https://github.com/mlajkim/athenz-amazon-ses-notification-plugin plugin
```

### Setup: cd to plugin

We will mostly work inside `plugin` directory, so let's `cd` into it:

```sh
cd plugin
```

### Setup: Successfully mount the jar on ZMS server first with configmap.

The following command will create the plugin configmap in namespace `athenz`:

```sh
kubectl apply -f ./plugin/configmap-jar.yaml

# configmap/ses-plugin-lib created
```

### Setup: Setup email server that sends an email

![aws_ses_create_identity](./assets/aws_ses_create_identity.png)

https://ap-northeast-1.console.aws.amazon.com/ses/home?region=ap-northeast-1#/identities

![create_identity](./assets/create_identity.png)

![verify_email](./assets/verify_email.png)

### Setup: prepare id and password

![set_smtp_credentials](./assets/set_smtp_credentials.png)

![username_and_password](./assets/username_and_password.png)

### Setup: Create secret in namespace athenz

> [!TIP]
> USERNAME starts with `AKIA...`

Your plugin requires the username and password you've just setup:

```sh
YOUR_SMTP_USERNAME="AKIAZYQCOUSKSNWF3HEU"
YOUR_SMTP_PASSWORD="XXXXXX___________________XXXXXX"

kubectl create secret generic aws-ses-secret \
  --from-literal=username="$YOUR_SMTP_USERNAME" \
  --from-literal=password="$YOUR_SMTP_PASSWORD" \
  -n athenz

# secret/aws-ses-secret created
```

### Setup: Modifies configmap of zms server

> [!NOTE]
> This step has been simplified with `make patch` command


Modifying the zms server deployment will restart the pod:

```sh
kubectl edit deployment athenz-zms-server -n athenz
```

Add the following env for the main container:

```yaml

        - name: AWS_SES_USER
          valueFrom:
            secretKeyRef:
              name: aws-ses-secret
              key: username
        - name: AWS_SES_PASS
          valueFrom:
            secretKeyRef:
              name: aws-ses-secret
              key: password
```

Main container also has this env, meaning you can mount that path for your custom plugin jars:

```yaml

        - name: USER_CLASSPATH
          value: /usr/lib/jars/*:/athenz/plugins/*
```

Add the following volumeMount:

```yaml

        - name: ses-plugin-vol
          mountPath: /usr/lib/jars/ses-plugin.jar
          subPath: ses-plugin.jar
```

And finally add the following config volume that stores your plugin!:

```yaml

      - name: ses-plugin-vol
        configMap:
          name: ses-plugin-lib
```

#### Check: Let's see if the plugin jar is mounted correctly

We can see `ses-plugin.jar` is mounted correctly, with correct size (around 700KB):

```sh
kubectl exec -it -n athenz $(kubectl get pod -n athenz -l app.kubernetes.io/name=athenz-zms-server -o jsonpath="{.items[0].metadata.name}") -- ls -al /usr/lib/jars/

# Defaulted container "athenz-zms-server" out of: athenz-zms-server, athenz-plugins (init), athenz-zms-server-wait (init)
# total 720
# drwxr-xr-x 2 root root   4096 Jan  5 15:39 .
# drwxr-xr-x 1 root root   4096 Jan  5 15:39 ..
# -rw-r--r-- 1 root root 726997 Jan  5 15:39 ses-plugin.jar
```

### Setup: Add `zms.config` so that ZMS server can read the plugin

```sh
kubectl edit configmap athenz-zms-config -n athenz
```


Add the following lines:

```yaml
apiVersion: v1
data:
  zms.properties: |
    # (custom) mlajkim plugin:
    athenz.zms.notification_service_factory_class=com.mlajkim.athenz.AwsSesPlugin
# ...
```

### Setup: restart deployment once again so that the config is reloaded

```sh
kubectl rollout restart deployment athenz-zms-server -n athenz

# deployment.apps/athenz-zms-server restarted
```

#### Check

Simply see if the zms deployment's status is `Running`:

```sh
kubectl get pods -n athenz -l app.kubernetes.io/name=athenz-zms-server

# NAME                                 READY   STATUS    RESTARTS   AGE
# athenz-zms-server-75966c95c6-2n5ft   1/1     Running   0          10s
```

## Connect to DB

```sh
SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| zms_server         |
| zts_store          |
+--------------------+

USE zms_server;
Database changed
MariaDB [zms_server]>

 SHOW TABLES;
+--------------------------------+
| Tables_in_zms_server           |
+--------------------------------+
| assertion                      |
| assertion_condition            |
| domain                         |
| domain_contacts                |
| domain_tags                    |
| domain_template                |
| entity                         |
| group_tags                     |
| host                           |
| pending_principal_group_member |
| pending_role_member            |
| policy                         |
| policy_tags                    |
| principal                      |
| principal_group                |
| principal_group_audit_log      |
| principal_group_member         |
| public_key                     |
| quota                          |
| role                           |
| role_audit_log                 |
| role_member                    |
| role_tags                      |
| service                        |
| service_domain_dependency      |
| service_host                   |
| service_tags                   |
+--------------------------------+

SELECT role_id, principal_id, req_time, last_notified_time, server FROM pending_role_member;
+---------+--------------+-------------------------+-------------------------+--------+
| role_id | principal_id | req_time                | last_notified_time      | server |
+---------+--------------+-------------------------+-------------------------+--------+
|      12 |            5 | 2026-01-05 16:30:49.519 | 2026-01-05 15:45:42.690 | NULL   |
|      12 |            6 | 2026-01-05 16:42:05.236 | 2026-01-05 15:45:42.686 | NULL   |
|      12 |            7 | 2026-01-05 15:52:23.720 | 2026-01-05 15:52:23.720 | NULL   |
|      12 |            8 | 2026-01-05 16:30:09.039 | 2026-01-05 16:30:09.039 | NULL   |
|      12 |            9 | 2026-01-05 16:40:32.073 | 2026-01-05 16:40:32.073 | NULL   |
|      12 |           11 | 2026-01-05 16:44:31.431 | 2026-01-05 16:44:18.746 | NULL   |
+---------+--------------+-------------------------+-------------------------+--------+

SELECT * FROM pending_role_member;

UPDATE pending_role_member SET last_notified_time = NULL;

+---------+--------------+-------------------------+-------------------------+-------------------------+-------------------------+--------------------+--------+-------------------+---------------+
| role_id | principal_id | expiration              | review_reminder         | audit_ref               | req_time                | last_notified_time | server | req_principal     | pending_state |
+---------+--------------+-------------------------+-------------------------+-------------------------+-------------------------+--------------------+--------+-------------------+---------------+
|      12 |            5 | 2026-01-05 14:40:00.000 | 2026-01-05 16:30:00.000 | updated using Athenz UI | 2026-01-05 16:30:49.519 | NULL               | NULL   | user.athenz_admin | ADD           |
|      12 |            6 | NULL                    | 2026-01-05 15:40:00.000 | updated using Athenz UI | 2026-01-05 16:42:05.236 | NULL               | NULL   | user.athenz_admin | ADD           |
|      12 |            7 | 2026-01-05 19:00:00.000 | NULL                    | test                    | 2026-01-05 15:52:23.720 | NULL               | NULL   | user.athenz_admin | ADD           |
|      12 |            8 | NULL                    | NULL                    | test                    | 2026-01-05 16:30:09.039 | NULL               | NULL   | user.athenz_admin | ADD           |
|      12 |            9 | NULL                    | NULL                    | asd                     | 2026-01-05 16:40:32.073 | NULL               | NULL   | user.athenz_admin | ADD           |
|      12 |           11 | 2026-01-06 12:00:00.000 | 2026-01-05 16:45:00.000 | asd                     | 2026-01-05 16:44:31.431 | NULL               | NULL   | user.athenz_admin | ADD           |
+---------+--------------+-------------------------+-------------------------+-------------------------+-------------------------+--------------------+--------+-------------------+---------------+

SELECT * from domain_contacts;
Empty set (0.003 sec)

```
