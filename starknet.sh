#!/bin/bash
# Default variables
function=main
C_LGn='\033[1;32m'
C_R='\033[0;31m'
RES='\033[0m'

printf_n(){ printf "$1\n" "${@:2}"; }

main(){
    . <(wget -qO- https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/logo.sh)
    cd ~/pathfinder
    rustup update
    git fetch
    git checkout v0.3.8
    cargo build --release --bin pathfinder
    mv ~/pathfinder/target/release/pathfinder /usr/local/bin/
    cd py
    source .venv/bin/activate
    PIP_REQUIRE_VIRTUALENV=true pip install -r requirements-dev.txt
    pip install --upgrade pip
    systemctl restart starknetd
    pathfinder -V
    wget -qO- eth0.me
    printf_n "${C_LGn}Done...${RES}"
}

$function
