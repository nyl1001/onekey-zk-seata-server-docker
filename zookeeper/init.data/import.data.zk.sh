#!/bin/bash
## for init zookeeper data, you need update this file.
## script for support import data with zookeeper
## author: neil 2021.02.08
##

initType="create"
if [ ! -n "$1" ]; then
  initType="create"
else
  initType=$1
fi

CMD=$(which zkCli.sh)
find="1"

if [ -z $CMD ]; then
  find="0"
fi

if [ $find = "0" ]; then
  CMD="$ZK_HOME/bin/zkCli.sh"
fi

echo $CMD

if [ -z $CMD ]; then
  echo "not found zkCli.sh, please check!!!"
  exit 1
fi

## read from file!!!
failCount=0
tempLog=$(mktemp -u)
addConfig() {
  root=$1
  dataId=$2
  content=$3
  echo "addConfig ${initType} ${root} tempLog begin:"
  $CMD $initType /${root}/${dataId} $content >"${tempLog}" 2>/dev/null
  cat "${tempLog}"
  echo "addConfig ${initType} ${root} tempLog end:"
  #  if [ -z $(cat "${tempLog}") ]; then
  #    echo " Please check the cluster status. "
  #    exit 1
  #  fi
  #  if [ "$(cat "${tempLog}")" == "true" ]; then
  #    echo "Set $1=$2 successfully "
  #  else
  #    echo "Set $1=$2 failure "
  #    failCount=`expr $failCount + 1`
  #  fi
}

count=0
COMMENT_START="#"
$CMD $initType /config "1" >/dev/null
for line in $(cat /init.data/seata-config.txt | sed s/[[:space:]]//g); do
  if [[ "$line" =~ ^"${COMMENT_START}".* ]]; then
    continue
  fi
  count=$(expr $count + 1)
  key=${line%%=*}
  value=${line#*=}
  value=$(eval echo ${value})
  #    if [ "${key}" = "store.db.url" ]
  #      then
  #        value=$(value)
  #    fi
  addConfig config "${key}" "${value}"
done

$CMD $initType /seata "1" >/dev/null
for lineForSeata in $(cat /init.data/zk-seata-config.properties | sed s/[[:space:]]//g); do
  echo "lineForSeata ${lineForSeata}"
  if [[ "$lineForSeata" =~ ^"${COMMENT_START}".* ]]; then
    continue
  fi
  count=$(expr $count + 1)
  key=${lineForSeata%%=*}
  value=${lineForSeata#*=}
  value=$(eval echo ${value})
  echo "lineForSeata key: ${key} value: ${value} "
  #    if [ "${key}" = "store.db.url" ]
  #      then
  #        value=$(value)
  #    fi
  addConfig seata "${key}" "${value}"
done

echo "========================================================================="
echo " Complete initialization parameters,  total-count:$count ,  failure-count:$failCount "
echo "========================================================================="

if [ ${failCount} -eq 0 ]; then
  echo " Init seata zookeeper config finished, please start seata-server. "
else
  echo " init seata zookeeper config fail. "
fi
