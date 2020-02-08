#!/bin/bash

BASE_DIR=""

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..
    deploy
}

function login_jenkins()
{
    read -p "input username:" USERNAME
    read -p "input password:" PASS
    JENKINS_SERVER="http://localhost:8080"
    CRUMB_ISSUER_URL='crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)'
    CRUMB=$(curl --user $USERNAME:$PASS $JENKINS_SERVER/$CRUMB_ISSUER_URL 2>/dev/null)
    echo $CRUMB
    if [ $CRUMB == Jenkins-Crumb* ] 
    then
        echo "username or password 错误"
        login_jenkins
    fi
}

function deploy()
{
    echo -e "开始全新部署"
    deploy_list=()
    deploy_names=()
    i=0
    while read line
    do
        if [ -d $BASE_DIR/deployment/$line ] 
        then
            deploy_names[i]=$line
            deploy_list[i]=$BASE_DIR/deployment/$line
            i=$[ $i + 1 ]
        fi
    done <  "$BASE_DIR/deployment/new.order"
    echo -e "要部署的组件如下："
    for item in  ${deploy_names[*]}
    do
        echo $item
    done
    read -p "确定要部署以上组件,Y-是，其他-收消部署:" confirm
    if [ $confirm == "Y" ] || [ $confirm == "y" ] 
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
    done
}

main "$@"