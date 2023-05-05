# Celestia blockspacerace utils


## Easy2Stake Public and FREE TO USE Celestia BlockspaceRace Endpoints
* [https://celrace-rpc.easy2stake.com](https://celrace-rpc.easy2stake.com)
* [https://celrace-grpc.easy2stake.com](https://celrace-grpc.easy2stake.com)
* [https://celrace-lcd.easy2stake.com](https://celrace-lcd.easy2stake.com)


## Utility Scrips
### 1. Tendermint State Sync - Configure statesync instantly in 3 simple steps. No headackes !

**Quickly setup any tendermint based chain with State Sync. Useful when:**
- you run out of space on a node
- you need to setup a new node and you don't need the full history

More about *state-sync* on the official docs: https://docs.tendermint.com/v0.34/tendermint-core/state-sync.html

### Instructions: 
[**Defaults are set for celestia-appd.**]

1. Download `statesync.sh` and run it.
It **must** be run inside the same user where your `.celestia-app` homedir is set.
    ```sh
    # Inside your "celestia" user
    wget https://raw.githubusercontent.com/easy2stake/blockspacerace/main/statesync.sh
    bash statesync.sh
    ``` 
    
2. Script will ask you to perform unsafe-reset-all, which removes all the data. This is needed for the state-sync to work. You cannot continue if you don't accept.
     ```sh
    !!!! ATTENTION !!!! -> ALL BLOCKCHAIN DATA WILL BE DELETED. Proceed? [default: n]: y
    ```
    
3. Provide the required information depending on your own setup. Defaults should work for the majority of celestia node setups.
    ```sh
    1. We need the [path | name] of the tendermint binary [default: celestia-appd]:
    2. What RPC server do you want to use for statesync? (URL or Public IP & port) [default: http://celrace-sync.easy2stake.com:80]:
    3. Home path where data & config folders are placed  [default: $HOME/.celestia-app/]:
    ```

### 2. Fetch Peers
`fetch_peers.sh` -> It will connect to the official repo [https://raw.githubusercontent.com/celestiaorg/networks/master/blockspacerace/peers.txt] and configure the peers in your config.toml file.


**How to run**

Make sure you are in the home directory where celestia-appd is installed then:
```sh
wget https://raw.githubusercontent.com/easy2stake/blockspacerace/main/fetch_peers.sh
bash fetch_peers.sh
```
