## 项目说明

区块链机脚本

### 负责人说明

### 版本功能说明

### 目录清单+说明

查看端口

```bash
lsof -iTCP -sTCP:LISTEN -P -n | awk '/java/ {split($9,a,":"); print "端口: "a[length(a)]}'
```

查看合约地址

```bash
awk -F'[,:]' '/contractAddress/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "合约地址: "$2}' /root/app/java/gateway/config.json
```

查看owner账号

```bash
awk -F'[,:]' '/ownerAddress/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "owner账号: "$2}' /root/app/java/gateway/config.json
```

查看owner私钥

```bash
awk -F'[,:]' '/privateKey/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "owner私钥: "$2}' /root/app/java/gateway/config.json
```

查看网关账号

```bash
awk -F'[,:]' '/appCode/{sub(/^ *"/, "", $2); sub(/"$/, "", $2); print "网关账号: "$2}' /root/app/java/gateway/config.json
```

## 部署方式

本项目采用克隆仓库并执行脚本一键安装方式部署

### 部署环境

Linux服务器

切换到root sudo -i

在/root/下执行命令

## 一键部署命令

git clone http://192.168.0.253:9080/blockchainmachine/blockchainmachine-script.git && mv blockchainmachine-script/app . && bash onekey.sh

### 其他注意事项

### 常见问题

脚本没有配置开机启动，如服务器重启请执行

```bash
cd /root/app/java/gateway/ && nohup java -Dlogging.config="/root/app/java/logback_gateway.xml" -jar blockchain-machine-deposition-0.0.1-SNAPSHOT.jar > "/root/app/logs/blockchain-machine-deposition.log" &a
```

### 验证是否安装完成

```bash
ps aux|grep fisco-bcos

tail -f /root/app/chain/nodes/127.0.0.1/node0/log/log* | grep connected

tail -f /root/app/chain/nodes/127.0.0.1/node0/log/log* | grep +++
```

### 日志路径文件名

### 接口说明

测试文件（postman文件导出，直接执行）--做一个测试页面

 

 