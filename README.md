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

## solana
```
wget -O - https://raw.githubusercontent.com/EvgeniiPerkin/scripts/main/restart_ek.sh | bash /dev/stdin -k <path ledger>
```