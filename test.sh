#!/bin/bash
# Default variables

path_ledger=""

while IFS= read -r line
do
    if [[ "$line" == *"--ledger"* ]]; then
        path_ledger="$line"
        path_ledger=${path_ledger#-*r}
        l=${#path_ledger}-3
        path_ledger=${path_ledger:1:$l}
        echo ${#path_ledger}
        echo $path_ledger
    fi
done < /root/solana/solana.service

echo $1