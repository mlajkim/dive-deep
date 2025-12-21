# unit.service

<!-- TOC -->

- [unit.service](#unitservice)
  - [Service](#service)
    - [Create sample service](#create-sample-service)
    - [RuntimeDirectory (And Mode)](#runtimedirectory-and-mode)

<!-- /TOC -->



## Service


### Create sample service

> [!WARNING]
> Only works in ubuntu


```sh
cat <<EOF | sudo tee /usr/local/bin/crash_test.sh > /dev/null
#!/bin/bash
echo 'MyApp Started'
echo 'Processing...'
sleep 2
echo 'MyApp Crashed'
exit 1
EOF

sudo chmod +x /usr/local/bin/crash_test.sh

sudo bash -c "cat <<EOF > /etc/systemd/system/crash_app.service
[Unit]
Description=Crash Test Service

[Service]
ExecStart=/usr/local/bin/crash_test.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF"

sudo systemctl daemon-reload
sudo systemctl start crash_app

sudo journalctl -f

# ec 21 02:32:34 ubuntu-host crash_test.sh[6042]: Processing...
# Dec 21 02:32:36 ubuntu-host crash_test.sh[6042]: MyApp Crashed
# Dec 21 02:32:40 ubuntu-host crash_test.sh[6050]: MyApp Started
# Dec 21 02:32:40 ubuntu-host crash_test.sh[6050]: Processing...
# Dec 21 02:32:42 ubuntu-host crash_test.sh[6050]: MyApp Crashed
```


### RuntimeDirectory (And Mode)

`RuntimeDirectory=sshd` creates `/run/sshd` directory! (This is memory based)