#!/bin/bash
#  deploy controlle

bin_path=""

function main()
{
    bin_path=$(cd `dirname $0`; pwd)

    choose_deploy_type
    deploy_type=$?

    copy_jenkins_settings

    start_jenkins

    if [ $deploy_type -eq 1 ]
    then
        deploy
    else
        update
    fi

    stop_jenkins
}

function copy_jenkins_settings()
{
    echo 'copy jenkins settings'
}

function start_jenkins()
{
    $bin_path/jenkinsctl.sh start

    
    exit_status=$?
    echo -e "$exit_status"
    case $exit_status in
        0) echo -e 'jenkins start successfully.'
        ;;
        *) echo -e 'jenkins start fail.'
        exit 1
        ;;
    esac
}

function choose_deploy_type()
{
    echo -e 'please choose the deploy type: 1-(new),2(update),q(quit)'
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
    echo 'stop jenkins'
    exec $bin_path/jenkinsctl.sh stop
}


function deploy()
{
    echo -e "start deploy"
}

function update()
{
    echo -e "start update"
}

main "$@"