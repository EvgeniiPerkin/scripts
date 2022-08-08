#!/bin/bash
systemctl stop suid
rm -rf /var/sui/db/*
systemctl restart suid