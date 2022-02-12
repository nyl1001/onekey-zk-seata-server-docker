#!/bin/bash

rootDir=$ONEKEY_ZK_ENV_PATH

. ${rootDir}/sh/color.sh

# 拷贝docker-compose文件
cp $rootDir/docker-compose.yml.bak $rootDir/docker-compose.yml

cp ${rootDir}/.env-default ${rootDir}/.env
cp ${rootDir}/seata/conf/registry-default.conf ${rootDir}/seata/conf/registry.conf

hostIp=$(/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | awk '{print $2}' | tr -d "addr:" | sed 1q)
echo "HOST_IP: $hostIp"

sysType=$(uname -s)
case $sysType in
    "Linux")
        sed -i "s/{hostIpVariable}/${hostIp}/g" ${rootDir}/.env
        ;;
    "Darwin")
        sed -i '' "s/{hostIpVariable}/${hostIp}/g" ${rootDir}/.env
        ;;
    *)
        $OUTPUT "system $sysType not supported!"
        exit -1
        ;;
esac

# 检查网络
checkNetworkExist
if [ $? != 1 ]; then
  docker network create onekey_zkenv_default
else
  docker network rm onekey_zkenv_default
  docker network create onekey_zkenv_default
fi

$OUTPUT "$GREEN init docker config successfully"
