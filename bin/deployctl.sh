#!/bin/bash

# deploy controller

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..

    choose_deploy_type
    deploy_type=$?

    start_jenkins

    login_jenkins

    if [ $deploy_type -eq 1 ]
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
    echo 'login to jenkins'
}

function choose_deploy_type()
{
    echo -e '请选择部署类型: 1-(全新部署),2(更新部署),q(quit)'
    read deploy_type;    
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
    echo -e "开始全新部署"
    sleep 30s
}

function update()
{
    echo -e "开始更新"
}

main "$@"