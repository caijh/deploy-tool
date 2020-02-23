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

BASE_DIR=""

function main()
{
    BIN_PATH=$(cd `dirname $0`; pwd)
    BASE_DIR=$BIN_PATH/..
    check_plugins
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

function check_plugins {
    if ! java -version &> /dev/null 
    then
        error "需要安装JDK环境"
        test2.sh
        exit 1
    fi
}

main "$@"