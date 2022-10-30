#!/bin/bash
# Default variables

systemctl stop suid
source $HOME/.cargo/env
rm -rf $HOME/.sui/db
wget -qO $HOME/.sui/genesis.blob https://github.com/MystenLabs/sui-genesis/raw/main/devnet/genesis.blob
cd $HOME/sui
git fetch upstream
git stash
git checkout -B devnet --track upstream/devnet
cargo build --release
mv $HOME/sui/target/release/{sui,sui-node,sui-faucet} /usr/bin/
systemctl restart suid
sui -V
wget -qO- eth0.me