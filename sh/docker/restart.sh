#! /bin/bash
cd `dirname $0`

. $ONEKEY_ZK_ENV_PATH/sh/color.sh

# 如果未启动，会直接启动
$OUTPUT "
$WHITE docker container will restart $TAILS
"
docker-compose -f $ONEKEY_ZK_ENV_PATH/docker-compose.yml restart
