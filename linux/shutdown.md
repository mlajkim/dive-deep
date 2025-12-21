# shutdown

> [!NOTE]
> Command `shutdown` has not been hands-on tested as it requires actual system shutdown.

<!-- TOC -->

- [shutdown](#shutdown)
  - [Overview](#overview)
  - [shutdown 02:00: Schedule a shutdown at 2 AM](#shutdown-0200-schedule-a-shutdown-at-2-am)
    - [shutdown 02:00 'Wall Message': Schedule a shutdown at 2 AM with a message](#shutdown-0200-wall-message-schedule-a-shutdown-at-2-am-with-a-message)
  - [shutdown +15: Shut down in 15 minutes](#shutdown-15-shut-down-in-15-minutes)

<!-- /TOC -->


## Overview

> [!TIP]
> `shutdown` command is more of the operator way. to see what systemd uses, please check [systemctl command](linux/systemctl.md).


## shutdown 02:00: Schedule a shutdown at 2 AM

```sh
shutdown 02:00
```

### shutdown 02:00 'Wall Message': Schedule a shutdown at 2 AM with a message

> [!TIP]
> Note that the message is optional.

You can provide a custom message that will be broadcasted to all logged-in users before the shutdown occurs:

```sh
shutdown 02:00 'Scheduled restart to upgrade our Linux kernel'
```

## shutdown +15: Shut down in 15 minutes

```sh
shutdown +15
```