#!/bin/bash

if [ $# -ne 1 ];then
    echo "`basename $0` <0|1>"
    exit 1
fi

if [ $1 -ne 0 -a $1 -ne 1 ];then
    echo "`basename $0` <0|1>"
    exit 1
fi

cd `dirname $0`
if [ -e ./keep-alive.sh ];then
    if [ $1 -eq 0 ];then
        sed -i 's/keepalive=./keepalive=0/g' ./keep-alive.sh
        echo "keep alive disabled."
    else
        sed -i 's/keepalive=./keepalive=1/g' ./keep-alive.sh
        echo "keep alive enabled."
    fi
fi

exit 0
