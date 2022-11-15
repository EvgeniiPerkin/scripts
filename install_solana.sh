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
		echo -e "${C_LGn}Functionality${RES}: script for install the solana node"
		echo
        echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES} ${C_R}limit${RES}"
        echo
		echo -e "${C_LGn}Options${RES}:"
        echo -e "  -t,   --testnet                       test net"
        echo -e "  -m,   --mainnet                       main net"
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
	*|--)
		break
		;;
	esac
done

install_solana_snapshot_finder(){
    printf_n "${C_LGn}Install snapshot-finder.${RES}"
    cd /root/solana/
    git clone https://github.com/c29r3/solana-snapshot-finder.git \
        && cd solana-snapshot-finder \
        && python3 -m venv venv \
        && source ./venv/bin/activate \
        && pip3 install -r requirements.txt
}

main() {
    printf_n "${C_LGn}Updating packages.${RES}"
    sudo apt update -y &>/dev/null
    sudo apt upgrade -y &>/dev/null

    mkdir /root/solana
    mkdir /root/solana/ledger

    printf_n "${C_LGn}Install solana cli.${RES}"
    if [[ $1 == "mainnet" ]]; then
        sh -c "$(curl -sSfL https://release.solana.com/v1.13.3/install)"
    elif [[ $1 == "testnet" ]]; then
        sh -c "$(curl -sSfL https://release.solana.com/v1.14.7/install)"
    fi

    export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"
    
    sudo bash -c "cat >/etc/sysctl.d/21-solana-validator.conf <<EOF
# Increase UDP buffer sizes
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728

# Increase memory mapped files limit
vm.max_map_count = 1000000

# Increase number of allowed open file descriptors
fs.nr_open = 1000000
EOF"

    sudo sysctl -p /etc/sysctl.d/21-solana-validator.conf
    sudo systemctl daemon-reload
    sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 1000000
EOF"

    if [[ $1 == "mainnet" ]]; then
        solana config set --url https://api.mainnet-beta.solana.com
    elif [[ $1 == "testnet" ]]; then
        solana config set --url https://api.testnet.solana.com
    fi
    solana config set --keypair /root/solana/validator-keypair.json

    ln -s /root/solana/solana.service /etc/systemd/system
    ln -s /root/solana/solana.logrotate /etc/logrotate.d/
    
    systemctl daemon-reload
    systemctl enable solana.service

    printf_n "${C_LGn}Done...${RES}"
}