#!/bin/bash
#  deploy controller
function main()
{
    echo 'start deploy controller...'
    copy_jenkins_settings
    start_jenkins
    choose_deply_type
}

function copy_jenkins_settings()
{
    echo 'copy jenkins settings'
}

function start_jenkins()
{
    echo 'jenkins starting'
    echo 'jenkins started'
}

function choose_deply_type()
{
    echo -e 'please choose the deply type: 1-(new),2(update)'
    read deply_type;
    case $deply_type in
        1) echo 1
        ;;
        2) echo 2
        ;;
        *) echo 'value error, exit!'
        ;;
    esac

    stop_jenkins
}

function stop_jenkins()
{
    echo 'stop jenkins'
}

main "$@"