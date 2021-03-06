#! /bin/bash

. $ONEKEY_ZK_ENV_PATH/sh/function.sh
. $ONEKEY_ZK_ENV_PATH/sh/color.sh
# 初始化基础配置数据
. $ONEKEY_ZK_ENV_PATH/sh/initConfig.sh

# 检查是否启动
isAllDockerContainerWorking
if [ $? = 1 ]; then
  $OUTPUT "
  $WHITE onekey-zk docker is running $TAILS
  "
  docker ps | grep onekey-zk
else
  docker-compose -f $ONEKEY_ZK_ENV_PATH/docker-compose.yml up --build  --remove-orphans -d
  $OUTPUT "
  $GREEN onekey-zk tech docker environment start work, enjoy coding...
  "
fi

