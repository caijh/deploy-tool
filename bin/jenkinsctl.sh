#!/bin/bash
# controller for jenkins

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..
    JENKINS_BASE_DIR=$BASE_DIR/plugins/jenkins
    JENKINS_OUT=$BASE_DIR/logs/jenkins.out

    if test $# -ne 1
    then
        echo "Usage: $0 {start|stop}"
        exit 1
    else
        case $1 in
            start)
                # cp  $BASE_DIR/config/jenkins.yaml $BASE_DIR/plugins/jenkins/jenkins_home/jenkins.yaml
                start
            ;;
            stop) 
                stop
            ;;
            status)
                status
            ;;
            *) echo "Usage: $0 {start|stop|status}"
            exit 1
            ;;
        esac
    fi
}

start(){
    echo -e 'Jenkins 启动中...'
    echo "fail" > $BIN_PATH/jenkins.state
    JENKINS_HOME=$JENKINS_BASE_DIR/jenkins_home nohup nice java -jar $JENKINS_BASE_DIR/jenkins.war \
        > "$JENKINS_OUT" 2>&1 &

    PID=$!
    echo $PID > $BIN_PATH/jenkins.pid
    if [ $PID -ge 0 ]
    then
        JENKINS_STATE=`cat $BIN_PATH/jenkins.state`
        TRY_TIMES=10
        while [ $JENKINS_STATE != "success" ] && [ $TRY_TIMES -ge 0 ]
        do
            sleep 15s
            TRY_TIMES=$[ $TRY_TIMES - 1 ]
            JENKINS_STATE=`cat $BIN_PATH/jenkins.state`
        done
        if [ $JENKINS_STATE = "success" ] 
        then
            echo -e "Jenkins 启动成功"
        else
            echo -e "Jenkins 启动失败"
        fi
    else
        exit 1
    fi
}

stop(){
    echo -e 'Jenkins 停止中...'
    kill `cat $BIN_PATH/jenkins.pid`
    echo -e  "Jenkins stopped"
    echo "fail" > $BIN_PATH/jenkins.state
}

status(){
 numproc=`ps -ef | grep [j]enkins.war | wc -l`
 if [ $numproc -gt 0 ]; then
  echo "Jenkins is running..."
  else
  echo "Jenkins is stopped..."
 fi
}

main "$@"