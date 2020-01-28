#!/bin/bash
# controller for jenkins

function main()
{
    bin_path=$(cd `dirname $0`; pwd)
    if test $# -ne 1
    then
        echo 'argements error'
    else
        case $1 in
            start) echo -e 'jenkins starting'
                JENKINS_HOME=$bin_path/../plugins/jenkins/jenkins_home java -jar $bin_path/../plugins/jenkins/jenkins.war &
                echo $! > $bin_path/jenkins.pid
            ;;
            stop) echo -e 'jenkins stopping'
                net stop jenkins
            ;;
            *) echo default
            exit 1
            ;;
        esac
    fi
}

main "$@"