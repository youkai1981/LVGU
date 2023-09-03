#! /bin/bash
set -e

chmod -R 777 /root/app
apt-get update -y
apt-get install openjdk-8-jdk -y

if cd /root/app/chain/nodes/127.0.0.1/ && \
bash gen_node_cert.sh -c ../cert/agency -o newNode && \
cp -r newNode/conf/ node0/ && \
rm -r newNode/ && \
bash start_all.sh
then
  echo "init chain"
else
  echo "init chain Failed"
fi

sleep 1
cd /root/app/java/manager/  
nodeid="$(cat /root/app/chain/nodes/127.0.0.1/node0/conf/node.nodeid)"
sh blockchain-machine-cmd.sh createGroup group.json ./group_out.json
sleep 1
sh blockchain-machine-cmd.sh deployContract contract.json ./contract_out.json
sleep 1
hash="$(cat ./contract_out.json | ./jq .txHash)"
contractAddress=$(curl -X POST --data '{"jsonrpc":"2.0","method":"getTransactionReceipt","params":[1001,'${hash}'],"id":1}' http://127.0.0.1:8045 | ./jq .result.logs[0].address)
sed -i 's/nodeid/'${nodeid}'/' ../gateway/config.json 
sed -i 's/"new_contractAddress"/'${contractAddress}'/' ../gateway/config.json 
echo "init data"

sleep 1
cd /root/app/java/gateway/
mkdir -p /root/app/logs
nohup java -Dlogging.config="/root/app/java/logback_gateway.xml" -jar blockchain-machine-deposition-0.0.1-SNAPSHOT.jar > "/root/app/logs/blockchain-machine-deposition.log" &
echo "start gateway"

sleep 5
hostname -I | awk '{print "节点IP: "$1}' && \
lsof -iTCP -sTCP:LISTEN -P -n | awk '/java/ {split($9,a,":"); print "端口: "a[length(a)]}' && \
awk -F'[,:]' '/contractAddress/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "合约地址: "$2}' /root/app/java/gateway/config.json
awk -F'[,:]' '/ownerAddress/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "owner账号: "$2}' /root/app/java/gateway/config.json
awk -F'[,:]' '/privateKey/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "owner私钥: "$2}' /root/app/java/gateway/config.json
awk -F'[,:]' '/appCode/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "网关账号: "$2}' /root/app/java/gateway/config.json

