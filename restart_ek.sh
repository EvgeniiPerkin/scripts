#!/bin/bash
function=main

C_LGn='\033[1;32m'
C_R='\033[0;31m'
RES='\033[0m'

printf_n(){ printf "$1\n" "${@:2}"; }

main() {
    . <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
    printf_n "${C_LGn}Stop solana service...${RES}"
    systemctl stop solana
    cd /root/solana/solana-snapshot-finder/
    printf_n "${C_LGn}rm ledger...${RES}"
    rm -rf /mnt/ledger/*
    printf_n "${C_LGn}work snapshot-finder...${RES}"
    python3 snapshot-finder.py --snapshot_path /mnt/ledger/ledger -r http://api.testnet.solana.com --min_download_speed 5
    printf_n "${C_LGn}start solana...${RES}"
    systemctl start solana
    printf_n "${C_LGn}Done...${RES}"
}

$function