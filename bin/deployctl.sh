#!/bin/bash

set +e
set -o noglob

#
# Set Colors
#

bold=$(tput bold)
underline=$(tput sgr 0 1)
reset=$(tput sgr0)

red=$(tput setaf 1)
green=$(tput setaf 76)
white=$(tput setaf 7)
tan=$(tput setaf 202)
blue=$(tput setaf 25)

#
# Headers and Logging
#

underline() { printf "${underline}${bold}%s${reset}\n" "$@"
}
h1() { printf "\n${underline}${bold}${blue}%s${reset}\n" "$@"
}
h2() { printf "\n${underline}${bold}${white}%s${reset}\n" "$@"
}
debug() { printf "${white}%s${reset}\n" "$@"
}
info() { printf "${white}➜ %s${reset}\n" "$@"
}
success() { printf "${green}✔ %s${reset}\n" "$@"
}
error() { printf "${red}✖ %s${reset}\n" "$@"
}
warn() { printf "${tan}➜ %s${reset}\n" "$@"
}
bold() { printf "${bold}%s${reset}\n" "$@"
}
note() { printf "\n${underline}${bold}${blue}Note:${reset} ${blue}%s${reset}\n" "$@"
}

set -e
set +o noglob

# deploy controller
BASE_DIR=""

DEPLOY_TYPE=1

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..

    check_plugins

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

function check_plugins {
    if ! java -version &> /dev/null 
    then
        error "需要安装JDK环境"
        exit 1
    fi
}

main "$@"