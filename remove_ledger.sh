#!/bin/bash
# Default variables

C_LGn='\033[1;32m'
C_R='\033[0;31m'
RES='\033[0m'
SOLANA_PATH="/root/.local/share/solana/install/active_release/bin/solana"

# Options
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
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
	-dm|--delete-ledger-main)
		function="delete_ledger_main_network $2"
		shift
		;;
	-m|--main)
		function="main_network $2"
		shift
		;;
	-dt|--delete-ledger-test)
		function="delete_ledger_test_network $2"
		shift
		;;
	-t|--test)
		function="test_network $2"
		shift
		;;
	*|--)
		break
		;;
	esac
done

printf_n(){ printf "$1\n" "${@:2}"; }

delete_ledger_main_network()){
    main $1 "m" true
}

main_network()){
    main $1 "m" false
}

delete_ledger_test_network()){
    main $1 "t" true
}

test_network()){
    main $1 "t" false
}

install_solana_snapshot_finder(){
    printf_n "${C_LGn}Install snapshot-finder${RES}"
    git clone https://github.com/c29r3/solana-snapshot-finder.git \
        && cd solana-snapshot-finder \
        && python3 -m venv venv \
        && source ./venv/bin/activate \
        && pip3 install -r requirements.txt
}

main(){
    if [[ $1 == "" ]]; then
        printf_n "${C_R}You have not specified a directory for the ledger!!!${RES}"
        return 0
    fi
    printf_n "${C_LGn}Stop solana service...${RES}"
    systemctl stop solana.service

    printf_n "${C_LGn}Updating and install default packages...${RES}"
    apt-get update && apt-get install python3-venv git -y 

    if [[ $3 ]]; then
        printf_n "${C_LGn}Cleaning the directory $1*${RES}"
        rm -rf "$1/*"
    fi

    if ! [ -d /root/solana/solana-snapshot-finder/ ]; then
        printf_n "${C_LGn}There is no snapshot-finder directory${RES}"
        install_solana_snapshot_finder
    fi
    if ! [ -f /root/solana/solana-snapshot-finder/snapshot-finder.py ]; then
        printf_n "${C_LGn}There is no snapshot-finder file${RES}"
        rm -rf /root/solana/solana-snapshot-finder/
        install_solana_snapshot_finder
    fi 

    cd /root/solana/solana-snapshot-finder/

    if [[ $2 == "m" ]]; then
        python3 snapshot-finder.py --snapshot_path $1
    elif [[ $2 == "t" ]]; then
        python3 snapshot-finder.py --snapshot_path $1 -r http://api.testnet.solana.com
    fi

    printf_n "${C_LGn}Start solana service...${RES}"
    systemctl start solana
    printf_n "${C_LGn}Done. Check the cathup solana!${RES}"
}
$function