#!/bin/bash
systemctl stop suid
rm -rf /var/sui/db/*
wget -O /var/sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
systemctl restart suid