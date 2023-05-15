#!/bin/bash
apt update
if [ $? -ne 0 ]; then
    echo "update failed!!!"
    exit
fi

apt upgrade -y
if [ $? -ne 0 ]; then
    echo "upgrade failed!!!"
    exit
fi

apt install -y openjdk-8-jdk git 
if [ $? -ne 0 ]; then
    echo "openjdk-8-jdk or git  failed!!!"
    exit
fi

if [ ! -d "/PrimiHubDataDIR" ]; then
  cd ~/ && git clone https://github.com/youkai1981/PrimiHubDataDIR.git
    if [ $? -ne 0 ]; then
        echo "git clone failed!!!"
        exit
    fi
else
    echo "PrimiHubDataDIR已经存在,请删除后重新运行！"
    echo "如已安装请执行cd ~/fisco && bash nodes/127.0.0.1/start_all.sh "
    exit
fi

mv PrimiHubDataDIR/* ./ && rm -rf PrimiHubDataDIR

chmod 777 ~/fisco/nodes/127.0.0.1/*.sh
chmod 777 ~/fisco/nodes/127.0.0.1/fisco-bcos

cd ~/fisco && bash nodes/127.0.0.1/start_all.sh

echo "-------------------------------以为lvgu部署合约MyDeposits--------------------------------------"
echo "transaction hash: 0x16dbb01eb5e04aedddd3191ed504077f50113ea6252231ae367c2384646e0f87"
echo "contract address: 0x08cf96bcd0f1de7e00cd2c8ab3f6c7f8d28b008c"
echo "currentAccount: 0xf5eaba15967aca0064e08e47756f7aabbb645177"

read -p "请记录contract address,按任意键继续！"

cd ~/fisco/console && bash start.sh
