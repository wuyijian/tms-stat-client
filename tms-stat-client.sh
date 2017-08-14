#!/bin/bash

red_cl="\033[31m"
grn_clr="\033[32m"
end_clr="\033[0m"

cd `dirname $0`
cwd=`pwd`

appname="tms-stat-client"
app_mainclass="org.apache.flume.node.Application"




function check_pid()
{
    source ./conf/flume-env.sh
    
    javaps=`$JAVA_HOME/bin/jps -l | grep $app_mainclass`
    if [ -n "$javaps" ]; then  
        psid=`echo $javaps | awk '{print $1}'`  
        return 1
    else  
        return 0
    fi 
}

function prepare()
{
    tmpfile=crontab-ori.tempXX
    item='*/1 * * * * cd '${cwd}' && ./keep-alive.sh >> keep-alive.log 2>&1'

    crontab -l >$tmpfile 2>/dev/null

    fgrep "${item}" $tmpfile &>/dev/null
    if [ $? -ne 0 ]
    then
        echo "${item}" >> $tmpfile
        crontab $tmpfile
    fi

    rm -f $tmpfile

}

function post_install()
{
    # stat-client working path
    if [ "x$appname" == x"tms-stat-client" ];then
        mkdir -p /opt/taomee/stat/tmsdata/{inbox,sent}
        chmod -R 777 /opt/taomee/stat/tmsdata
    fi

    echo ""
    echo "Installation completed"
}

function start()
{
    #find_java
    check_pid
    if [ $? -eq 1 ]
    then
        printf "$red_clr%50s$end_clr\n" "$appname is already running"
        exit 1
    fi

    #LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:./bin/" ./bin/${appname} ./conf/bench.conf
    
    ./bin/flume-ng agent --conf conf --conf-file conf/tms-custom-taildir-source.conf --name a1 -Dflume.root.logger=INFO,LOGFILE > ./start.log 2>&1 &

    sleep 7
    check_pid
    if [ $? -eq 0 ]
    then
        printf "$red_clr%50s$end_clr\n" "start $appname failed."
        exit 1
    fi

    ./set-keep-alive.sh 1
}

function stop()
{
    #find_java
    check_pid
    running=$?
    if [ $running -eq 0 ]
    then
        printf "$red_clr%50s$end_clr\n" "$appname is not running"
        exit 1
    fi

    ./set-keep-alive.sh 0

    while [ $running -eq 1 ]
    do
        sleep 1
    	check_pid
        kill $psid
        running=$?
    done

    printf "$grn_clr%50s$end_clr\n" "$appname has been stopped"
}

function restart()
{
    stop
    start
}

function state()
{
    check_pid
    running=$?
    if [ $running -eq 0 ]
    then
        printf "$red_clr%50s$end_clr\n" "$appname is not running"
        exit 1
    fi
    #ps -aux | grep $psid
    $JAVA_HOME/bin/jps -l | grep $app_mainclass 
} 

function usage()
{
    echo "$0 <start|stop|restart|state|setup>"
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        restart 
        ;;
    state)
        state 
        ;;
    postinstall)
        post_install
        ;;
    setup)
        prepare
        start
        ;;
    *)
        usage 
        ;;
    esac

exit 0
