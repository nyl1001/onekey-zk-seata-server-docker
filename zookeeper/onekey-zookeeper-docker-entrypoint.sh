#!/bin/bash
## script for support import data with zookeeper
## author: neil 2021.02.08

# set -e

initProcessRecordFile="/data/zk.onekey-zookeeper.inited"
initCmdFile='/init.data/import.data.zk.sh'

needInitData="Y"
if [ -f "$initCmdFile" ]
then
  needInitData="Y"
else
  needInitData="N"
  echo "【onekey-zookeeper】 no init data shell file found, skip."
fi

#
initType="create"
if [ ! -f "$initProcessRecordFile" ]
then
  initType="create"
else
  : > $initProcessRecordFile
  initType="set"
fi


echo "check needInitData is: $needInitData"

## start my import data ====================
if [ $needInitData = "Y" ]
then

  ## start in backgroup by original entry point
  /docker-entrypoint.sh zkServer.sh start

  ## waiting for zookeeper
  sleep 10

  echo "【onekey-zookeeper】 call init data now..."
  date > "$initProcessRecordFile"

  ##import data
  echo ">>>> begin synchronizing seata config to zookeeper <<<<"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  bash $initCmdFile $initType >> $initProcessRecordFile
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo ">>>> finished synchronizing seata config to zookeeper <<<<"
  /docker-entrypoint.sh zkServer.sh stop

  ## mark
  echo "【onekey-zookeeper】 mark: init is finished!"
  date >> "$initProcessRecordFile"
  echo "done" >> "$initProcessRecordFile"
fi

## end my import data ====================


echo "【onekey-zookeeper】 Starting Zookeeper in foreground mode..."
/docker-entrypoint.sh $@