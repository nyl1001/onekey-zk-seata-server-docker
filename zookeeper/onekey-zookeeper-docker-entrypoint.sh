#!/bin/bash
## script for support import data with zookeeper
## author: neil 2021.02.08

# set -e

initedfile="/data/zk.onekey-zookeeper.inited"
initcmdfile='/init.data/import.data.zk.sh'

needcallinit="Y"

#
if [ ! -f "$initedfile" ]
then
  needcallinit="Y${needcallinit}"
else
  echo "【onekey-zookeeper】 data has been initialized, can not be initialized again."
fi

if [ -f "$initcmdfile" ]
then
  needcallinit="Y${needcallinit}"
else
  echo "【onekey-zookeeper】 no init data file found, skip."
fi

echo "check needcallinit is: $needcallinit"

## start my import data ====================
if [ $needcallinit = "YYY" ]
then

  ## start in backgroup by original entry point
  /docker-entrypoint.sh zkServer.sh start

  ## waiting for zookeeper
  sleep 10

  echo "【onekey-zookeeper】 call init data now..."
  date > "$initedfile"

  ##import data
  echo ">>>> begin synchronizing seata config to zookeeper <<<<"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  bash $initcmdfile >> $initedfile
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo "###########################################################"
  echo ">>>> finished synchronizing seata config to zookeeper <<<<"
  /docker-entrypoint.sh zkServer.sh stop

  ## mark
  echo "【onekey-zookeeper】 mark: init is finished!"
  date >> "$initedfile"
  echo "done" >> "$initedfile"
fi

## end my import data ====================


echo "【onekey-zookeeper】 Starting Zookeeper in foreground mode..."
/docker-entrypoint.sh $@