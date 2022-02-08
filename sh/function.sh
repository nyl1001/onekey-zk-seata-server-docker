#! /bin/bash

. $ONEKEY_ZK_ENV_PATH/sh/commonShellConfig.sh
# 检查容器是否已经开始工作
function isAllDockerContainerWorking() {
  allWorkingOnekeyZkContainerList=$(docker ps | grep onekey-zk | awk '{print $2}')
  if [ -z "$allWorkingOnekeyZkContainerList" ]; then
    return 0
  fi

  for curContainer in ${allOnekeyZkDockerArray[@]}; do
    if [[ ! "${allWorkingOnekeyZkContainerList[@]}" =~ "${curContainer}" ]]; then
      return 0
    fi
  done

  return 1
}

function isAllDockerContainerStopped() {
  allWorkingOnekeyZkContainerList=$(docker ps | grep onekey-zk | awk '{print $2}')
  if [ -z "$allWorkingOnekeyZkContainerList" ]; then
    return 1
  fi

  for curContainer in ${allOnekeyZkDockerArray[@]}; do
    if [[ "${allWorkingOnekeyZkContainerList[@]}" =~ "${curContainer}" ]]; then
      return 0
    fi
  done

  return 1
}

function isStringInFile() {
    FIND_STR=$1
    FIND_FILE=$2
    # 判断匹配函数，匹配函数不为0，则包含给定字符
    if [ `grep -c "$FIND_STR" $FIND_FILE` -ne '0' ];then
        return 1
    fi
    return 0
}