#!/bin/bash

current_date=$(date +%y%m%d%H%M)
# You may chenge this config if needed
peers_url=https://raw.githubusercontent.com/celestiaorg/networks/master/blockspacerace/peers.txt 	# The official blockspace repo containing the peers
peers_file=peers.txt											# A temporary file used to download the peers from the repo
config_file=$HOME/.celestia-app/config/config.toml							# The celestia-app [ex: validator node] configuration file location
config_file_backup=$HOME/config.toml.bak_$current_date

# Used to validate the p2p address string. Do not change these
ip_pattern='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'
port_pattern='^[0-9]+$'
address_pattern='^[a-fA-F0-9]{40}@'

validated_addresses=()

# Download the peers from the repo to the temporary file
echo "-> Downloading the list of peers from the configured repo: $peers_url"
curl -s -o $peers_file $peers_url
echo ""

# Validate the peer list
while read line; do
    address=$(echo "$line" | tr -d '[:space:]')
    if [[ $address =~ $address_pattern ]]; then
        ip=$(echo "$address" | cut -d '@' -f 2 | cut -d ':' -f 1)
        port=$(echo "$address" | cut -d '@' -f 2 | cut -d ':' -f 2)
        if [[ $ip =~ $ip_pattern && $port =~ $port_pattern ]]; then
            validated_addresses+=("$address")
        fi
    fi
done < $peers_file

# Print the peer list to the screen
output_str=$(IFS=,; echo "${validated_addresses[*]}")
echo "-> The valid peers to be setup in your config.toml [$config_file] are:"
echo "$output_str"
echo ""

# Backup the current configuration file
echo "-> Backing up the current configuration file to $config_file_backup ..."
cp $config_file $config_file_backup
echo ''

# Replace the peers in config.toml file
echo "-> Replacing the persistent_peers in the configuration file $config_file ..."
sed -i "s/^persistent_peers *= *\".*\"/persistent_peers = \"$output_str\"/" $config_file
echo ""

# Print the current configuration file
echo "-> Your persistent peers have inside $config_file are now set to:"
grep "^persistent_peers[ =]" $config_file
echo ""
echo "-> Done. The script backed up your previus configuration file to $config_file_backup. Feel free to delete it if you no longer need the backup."
