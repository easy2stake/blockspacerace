#!/bin/bash

echo '''

*******************************************************************************************************************
-> Script can be tuned to run any tendermint blockchain. Defaults are set for celestia-appd
-> This script has to be run inside the user where celestia-appd is built as it uses \$HOME variable
-> Make sure there is connectivity to the RPC & port is open (curl https://celrace-rpc.easy2stake.com/status)
-> Warning! This script will ask you to perform "unsafe-reset-all" which removes all the data, WAL and reset the node to genesis state
-> Make sure to stop the process before executing this script
*******************************************************************************************************************

'''

echo "Checking if the celestia-appd process running..."
if pgrep -x "celestia-appd" > /dev/null
then
    echo "The celestia-appd process is running and must be manually stopped ! Please stop it now and restart the statesync script !"
    exit 1
else
    echo "The celestia-appd process is not running. The script will continue!"
fi
echo ''

read -p '!!!! ATTENTION !!!! -> ALL BLOCKCHAIN DATA WILL BE DELETED. Proceed[y/n]? [default: n]: ' agree2
agree2=${agree2:-n}
if [ $agree2 = 'y' ]; then
  echo "You chosed to continue. Your data folder will be removed !"
else
  echo "Exiting"
  exit 1
fi

read -p 'We need the [path | name] of the tendermint binary [default: celestia-appd]: ' pname
pname=${pname:-celestia-appd}

read -p 'What RPC server do you want to use for statesync? (URL or Public IP & port) [default: http://celrace-sync.easy2stake.com:80]: ' ss_rpc
ss_rpc=${ss_rpc:-http://celrace-sync.easy2stake.com:80}

# Generating the p2p id based on the used RPC
url="$ss_rpc/status"
res=$(curl -s $url)
id=$(jq '.result.node_info.id' -r <<< $res)
port=$(jq '.result.node_info.listen_addr | split(":")[2]' -r <<< $res)
ip=$(echo $url | sed -e 's/.*\/\/\([^\/]*\).*/\1/' | cut -d ":" -f 1)
p2p_id="$id@$ip:$port"

read -p 'Home path where data & config folders are placed  [default: $HOME/.celestia-app/]: ' homedir
homedir=${homedir:-$HOME/.celestia-app}

latest_block=$(curl -s $ss_rpc/block | jq -r .result.block.header.height); \
trust_block=$((latest_block - 2000)); \
trust_hash=$(curl -s "$ss_rpc/block?height=$trust_block" | jq -r .result.block_id.hash)

awk -v SS=$ss_rpc -v TB=$trust_block -v TH="$trust_hash" \
    'BEGIN{FS=OFS=" = "}
     /^enable/{$2="true"}
     /^rpc_servers/{$2="\""SS","SS"\""}
     /^trust_height/{$2=TB}
     /^trust_hash/{$2="\""TH"\""}
     1' $homedir/config/config.toml > $homedir/config/config.toml.bak && \
mv $homedir/config/config.toml.bak $homedir/config/config.toml

# Adding the persistent peer to config.
pp=$(cat $homedir/config/config.toml | grep "persistent_peers " | cut -d "\"" -f 2)
if [ -z "$pp" ]; then
  pp="$p2p_id"
else
  pp="$pp,$p2p_id"
fi
sed -i 's/persistent_peers *= *"[^"]*"/persistent_peers = "'"$pp"'"/' $homedir/config/config.toml

echo "Saving addresbook, in case --keep-addr-book flag does not work! File is saved saved in $homedir/config/addrbook.json.bak. Feel free to delete the backup file if you don't need it"
cp $homedir/config/addrbook.json $homedir/config/addrbook.json.bak
$pname tendermint unsafe-reset-all --home $homedir --keep-addr-book

echo 'Done!'
