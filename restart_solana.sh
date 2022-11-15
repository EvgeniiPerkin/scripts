#!/bin/bash
# Default variables

C_LGn='\033[1;32m'
C_R='\033[0;31m'
C_Gy='\033[1;37m'
RES='\033[0m'
SOLANA_PATH="/root/.local/share/solana/install/active_release/bin/solana"
SOLANA_SERVICE_FILE="/root/solana/solana.service"
PATH_FINDER="/root/solana/solana-snapshot-finder/"
PATH_LEDGER=""

while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: script for restarting the solana node"
		echo
    echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
    echo
		echo -e "${C_LGn}Options${RES}:"
    echo -e "  -t,   --testnet                       test net"
    echo -e "  -m,   --mainnet                       main net"
		echo 
    echo -e "  -tl,  --testnet-limit                 limit the speed download snapshot testnet"
    echo -e "  -ml,  --mainnet-limit                 limit the speed download snapshot mainnet"
    echo
		return 0
		;;
	-t|--testnet)
		function="main testnet"
		shift
		;;
	-m|--mainnet)
		function="main mainnet"
		shift
		;;
  -tl|--testnet-limit)
    function="main testnet $2"
    shift
    ;;
  -ml|--mainnet-limit)
    function="main mainnet $2"
    shift
    ;;
	*|--)
		break
		;;
	esac
done

printf_n(){ printf "$1\n" "${@:2}"; }

install_solana_snapshot_finder(){
    printf_n "${C_LGn}Install snapshot-finder.${RES}"
    cd /root/solana/
    git clone https://github.com/c29r3/solana-snapshot-finder.git \
        && cd solana-snapshot-finder \
        && python3 -m venv venv \
        && source ./venv/bin/activate \
        && pip3 install -r requirements.txt
}

get_path_ledger() {
    while IFS= read -r line
    do
        if [[ "$line" == *"--ledger"* ]]; then
            PATH_LEDGER="$line"
            PATH_LEDGER=${PATH_LEDGER#-*r}
            local l=${#PATH_LEDGER}-3
            PATH_LEDGER=${PATH_LEDGER:1:$l}
        fi
    done < $SOLANA_SERVICE_FILE
}

main() {
	. <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
    
    printf_n "${C_LGn}Get the ledger catalog.${RES}"
    get_path_ledger
    printf_n "${C_Gy}$PATH_LEDGER${RES}"
    printf_n "${C_LGn}Check the ledger catalog.${RES}"
    if ! [ -d $PATH_LEDGER ]; then
        printf_n "${C_R}There is no ledger directory.${RES}"
        printf_n "${C_R}Check the path of the ledger in the solana service file.${RES}" 
        printf_n "${C_R}Not completed.${RES}"
        return 1 2>/dev/null; exit 1
    fi
    
    printf_n "${C_LGn}Updating packages.${RES}"
    sudo apt update -y &>/dev/null
    sudo apt upgrade -y &>/dev/null
    
    printf_n "${C_LGn}Install git.${RES}"
    sudo apt install git -y &>/dev/null
    
    printf_n "${C_LGn}Stop solana service.${RES}"
    systemctl stop solana.service
    
    printf_n "${C_LGn}Cleaning the directory $PATH_LEDGER/*${RES}"
    rm -rf $PATH_LEDGER/*
    
    if [ -d $PATH_FINDER ]; then
        cd $PATH_FINDER
        git pull
        source ./venv/bin/activate 
    else
        printf_n "${C_LGn}There is no snapshot-finder directory${RES}"
        install_solana_snapshot_finder
    fi
    
    limit_speed=""
    if [[ $2 != "" ]]; then
        limit_speed="--min_download_speed $2"
    fi
    if [[ $1 == "mainnet" ]]; then
        python3 snapshot-finder.py --snapshot_path $PATH_LEDGER $limit_speed
    elif [[ $1 == "testnet" ]]; then
        python3 snapshot-finder.py --snapshot_path $PATH_LEDGER -r http://api.testnet.solana.com $limit_speed
    fi
    
    printf_n "${C_LGn}Start solana service...${RES}"
    systemctl start solana.service
}

$function
