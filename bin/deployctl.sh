#!/bin/bash

# deploy controller
BASE_DIR=""

DEPLOY_TYPE=1

JENKINS_SERVER="http://localhost:8080"
CRUMB=""

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..

    choose_deploy_type
    DEPLOY_TYPE=$?

    start_jenkins

    login_jenkins

    if [ $DEPLOY_TYPE -eq 1 ]
    then
        deploy
    else
        update
    fi

    stop_jenkins
}

function start_jenkins()
{
    $BIN_PATH/jenkinsctl.sh start
    RETVAL=$?
    case $RETVAL in
        0)
        ;;
        *)
        exit 1
        ;;
    esac
}

function login_jenkins()
{
    read -p "input username:" USERNAME
    read -p "input password:" PASS
    CRUMB_ISSUER_URL='crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    CRUMB=$(curl --user $USERNAME:$PASS $JENKINS_SERVER/$CRUMB_ISSUER_URL 2>/dev/null)
    echo $CRUMB
    if [[ "$CRUMB" =~ ^Jenkins-Crumb.* ]] 
    then
        echo "username or password 错误"
        login_jenkins
    fi
}

function choose_deploy_type()
{
    read -p '请选择部署类型: 1-(全新部署),2(更新部署),q(quit):' deploy_type
    case $deploy_type in
        1|2) return $deploy_type
        ;;
        q) exit
        ;;
        *) choose_deploy_type
        ;;
    esac
}

function stop_jenkins()
{
    $BIN_PATH/jenkinsctl.sh stop
}


function deploy()
{
    deploy_list=()
    i=0
    while read line
    do
        echo $line
        if [ -d $BASE_DIR/deployment/$line ] 
        then
            deploy_list[i]=$BASE_DIR/deployment/$line
            i=$[ $i + 1 ]
        fi
    done <  "$BASE_DIR/deployment/new.order"
    echo -n "要部署的组件如下："
    for item in  ${deploy_list[*]}
    do
        echo $item
    done
    read -p "确定要部署以上组件,Y-是，N-收消部署" confirm
    if [ $confirm -eq 'Y' ] 
    then
        echo "全新部署开始"
    else
        echo "取消部署"
    fi
}

function update()
{
    echo -e "开始更新"
}

main "$@"