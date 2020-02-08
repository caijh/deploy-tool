#!/bin/bash

# deploy controller
BASE_DIR=""

DEPLOY_TYPE=1

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

function login_jenkins()
{
    $BIN_PATH/jenkinsctl.sh login
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
    if [ $confirm == 'Y' ] || [ $confirm == "y" ]
    then
        echo "全新部署开始"
        start_deploy $deploy_list
    else
        echo "取消部署"
    fi
}

function start_deploy()
{
    for item in $1
    do
        echo $item
        $BIN_PATH/jenkinsctl.sh create_job $item
    done
}

function update()
{
    echo -e "开始更新"
}

main "$@"