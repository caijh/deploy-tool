#!/bin/bash
# controller for jenkins

JENKINS_SERVER="http://localhost:8080"
USERNAME=""
PASS=""
CRUMB=""
COOKIE_JAR=/tmp/cookies

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..
    JENKINS_BASE_DIR=$BASE_DIR/plugins/jenkins
    JENKINS_HOME=$JENKINS_BASE_DIR/jenkins_home
    JENKINS_OUT=$BASE_DIR/logs/jenkins.out
    COOKIE_JAR=$BASE_DIR/tmp/cookies

    if [ $# -lt 1 ]
    then
        usage
        exit 1
    else
        case $1 in
            start)
                # cp  $BASE_DIR/config/jenkins.yaml $BASE_DIR/plugins/jenkins/jenkins_home/jenkins.yaml
                cp  $BASE_DIR/plugins/init/jenkins.init.groovy $BASE_DIR/plugins/jenkins/jenkins_home/init.groovy
                start
            ;;
            stop) 
                stop
            ;;
            status)
                status
            ;;
            login)
                login
            ;;
            create_job)
                create_job $2
            ;;
            build)
                build $2
            ;;
            *)
            usage
            exit 1
            ;;
        esac
    fi
}

function usage()
{
    echo "Usage: $0 {start|stop|status|create_job}"
}

start(){
    echo -e 'Jenkins 启动中...'
    echo "Fail" > $JENKINS_HOME/jenkins.state
    DEPLOYMENT_HOME=$BASE_DIR/deployment JENKINS_HOME=$JENKINS_HOME nohup nice java -jar $JENKINS_BASE_DIR/jenkins.war \
        > "$JENKINS_OUT" 2>&1 &

    PID=$!
    echo $PID > $BIN_PATH/jenkins.pid
    if [ $PID -ge 0 ]
    then
        JENKINS_STATE=`cat $JENKINS_HOME/jenkins.state`
        TRY_TIMES=10
        while [ $JENKINS_STATE != "Success" ] && [ $TRY_TIMES -ge 0 ]
        do
            sleep 15s
            TRY_TIMES=$[ $TRY_TIMES - 1 ]
            JENKINS_STATE=`cat $JENKINS_HOME/jenkins.state`
        done
        if [ $JENKINS_STATE = "Success" ] 
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
    echo "Stop" > $JENKINS_HOME/jenkins.state
}

status(){
 numproc=`ps -ef | grep [j]enkins.war | wc -l`
 if [ $numproc -gt 0 ]; then
  echo "Jenkins is running..."
 else
  echo "Jenkins is stopped..."
 fi
}

function login()
{
    read -p "input username:" USERNAME
    read -p "input password:" PASS
    CRUMB_ISSUER_URL='crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    CRUMB=$(curl --silent --cookie-jar $COOKIE_JAR --user $USERNAME:$PASS $JENKINS_SERVER/$CRUMB_ISSUER_URL 2>/dev/null)
    echo $CRUMB
    if [ $CRUMB == Jenkins-Crumb* ] 
    then
        echo "username or password 错误"
        login
    fi
}

function create_job()
{
    if [ x"$1" == x ] 
    then
        echo "deployment not found"
        exit 1
    fi
    RET=$(curl --cookie $COOKIE_JAR -X POST $JENKINS_SERVER/createItem?name=$1 -u $USERNAME:$PASS -H "$CRUMB" -H "Content-Type:application/xml" --data-binary "@$BASE_DIR/config/config.xml")
    echo $RET
    if [ $RET -ne 200] 
    then
        echo $RET
    fi
}

function build()
{
    curl -X POST $JENKINS_SERVER/job/$1/build  --cookie $COOKIE_JAR --user $USERNAME:$PASS -H "$CRUMB"
}

main "$@"