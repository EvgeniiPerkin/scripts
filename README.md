# Пример использования скриптов:
## starknet
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/starknet.sh | bash
```
```
bash <(curl -Ls https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/starknet.sh)
```
## sui
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/sui.sh | bash
```
```
bash <(curl -Ls https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/sui.sh)
```
```
bash <(curl -Ls https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/update_db_sui.sh)
```
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/update_db_sui.sh | bash
```

## SOLANA
### ek (test net)
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_ek.sh | bash /dev/stdin -l /mnt/ledger/ledger
```
### main net
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin -m
```
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin --mainnet
```
### main net limit the speed
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin -ml 20
```
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin --mainnet-limit 20
```
### test net
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin -t
```
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin --testnet
```
### test net limit the speed
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin -tl 5
```
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_solana.sh | bash /dev/stdin --testnet-limit 5
```
