# Celestia blockspacerace utils


### Easy2Stake Public and FREE TO USE Celestia BlockspaceRace Endpoints
* [https://celrace-rpc.easy2stake.com](https://celrace-rpc.easy2stake.com)
* [https://celrace-grpc.easy2stake.com](https://celrace-grpc.easy2stake.com)
* [https://celrace-lcd.easy2stake.com](https://celrace-lcd.easy2stake.com)


### Utility Scrips
`fetch_peers.sh` -> It will connect to the official repo [https://raw.githubusercontent.com/celestiaorg/networks/master/blockspacerace/peers.txt] and configure the peers in your config.toml file.


**How to run**

Make sure you are in the home directory where celestia-appd is installed then:
```sh
git clone https://github.com/easy2stake/blockspacerace
cd blockspacerace; chmod 700 fetch_peers.sh
./fetch_peers.sh
```
