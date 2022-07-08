#!/bin/bash
# Default variables

C_LGn='\033[1;32m'
RES='\033[0m'

while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: script for restarting the salon node with the removal of the messenger"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h,  --help        show the help page"
		echo -e "  -p,  --path-ledger the path to the ledger"
		echo -e "  -s,  --source      install the node using a source code"
		echo -e "  -rb                replace bootstraps"
		echo -e "  -un, --uninstall   unistall the node"
		echo
		return 0
		;;
	-p|--path-ledger)
		function="main"
		shift
		;;
	*|--)
		break
		;;
	esac
done


SOLANA_PATH="/root/.local/share/solana/install/active_release/bin/solana"

printf_n(){ printf "$1\n" "${@:2}"; }

main(){
    printf_n "stop solana service..."
    printf_n $1
    # systemctl stop solana.service
    # rm -rf /root/solana/ledger/*
    # rm -rf /mnt/ledger/*
}
$function