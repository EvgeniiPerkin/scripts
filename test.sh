#!/bin/bash
# Default variables
read -p 'Username Firstname: ' uservar namevar
read -sp 'Password: ' passvar
echo
tee <<EOF >/dev/null /home/user/work/service.test
[Unit]
Description=Massa Node
After=network-online.target

[Service]
User=$uservar
WorkingDirectory='$namevar'
ExecStart="$namevar"
Restart=on-failure
RestartSec=3
LimitNOFILE=65535
pass=$passvar

[Install]
WantedBy=multi-user.target
EOF