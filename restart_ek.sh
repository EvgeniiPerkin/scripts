#!/bin/bash
function=main

C_LGn='\033[1;32m'
C_R='\033[0;31m'
RES='\033[0m'

while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: script for restarting the solana node with the removal of the messenger"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES} ${C_R}/root/solana/ledger${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
        echo -e "  -h,   --help                         show the help page"
        echo -e "  -dm,  --delete-ledger-main           delete the ledger and run the fender on the main network"
        echo -e "  -m,   --main                         run the fender on the main network"
        echo -e "  -dt,  --delete-ledger-test           delete the ledger and run the fender on the test network"
        echo -e "  -t,   --test                         run the fender on the test network"
		echo
		return 0
		;;
	-k|--koks)
		function="main $2"
		shift
		;;
	*|--)
		break
		;;
	esac
done

printf_n(){ printf "$1\n" "${@:2}"; }

main() {
    if [[ $1 == "" ]]; then
        printf_n "${C_R}You have not specified a directory for the ledger!!!${RES}"
        return 0
    fi
    printf_n $1
    . <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
    #printf_n "${C_LGn}Stop solana service...${RES}"
    #systemctl stop solana
    #cd /root/solana/solana-snapshot-finder/
    #printf_n "${C_LGn}rm ledger...${RES}"
    #rm -rf $1/*
    #printf_n "${C_LGn}work snapshot-finder...${RES}"

    #python3 snapshot-finder.py --snapshot_path $1 -r http://api.testnet.solana.com --min_download_speed 5
    #printf_n "${C_LGn}start solana...${RES}"
    #systemctl start solana
    #printf_n "${C_LGn}Done...${RES}"
    #wget -qO- eth0.me
}

$function