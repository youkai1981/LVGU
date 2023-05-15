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

echo "-------------------------------以为LVGU部署合约MyDeposits--------------------------------------"
echo "transaction hash: 0xe0ec314cbce3dc80674d9bdb54efea9cf83a4b23842c253df9ff22a32d451c92"
echo "contract address: 0xaa3d8d31becc8a8a48fe01e39cd351aa2416fe7e"
echo "currentAccount: 0xa8838135853f2aee5bd0f81c31b5761b49eb927a"

read -p "请记录contract address,按任意键继续！"

cd ~/fisco/console && bash start.sh
