#!/bin/bash

cd `dirname $0`


appname="tms-stat-client"

keepalive=0
if [ $keepalive -eq 0 ];then
    exit 0
fi

cd `dirname $0`

./${appname}.sh state > /dev/null 2>&1

if [ $? -ne 0 ];then
    echo "${appname} stopped abnormally, try to start it."
    ./${appname}.sh stop
    sleep 5
    echo "restart ${appname} at $(date)"
    ./${appname}.sh start
fi

# reserved one core file
find . -name "core.*" | sort -r | sed '1d' | xargs rm -vf 

exit 0
