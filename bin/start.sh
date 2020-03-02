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

function main()
{
    base_dir=$(cd `dirname $0`; pwd)/..
    read_deployment_orders "$base_dir/deployment.orders.txt"

}

function read_deployment_orders() {
    list=()
    i=0
    while read line
    do
        list[i]=$line
        i=$[ $i + 1]
    done <  "$1"
    for item in  ${list[*]}
    do
        deploy $item
    done
}

function deploy()
{
    info "start to deploy $1"

    ansible-playbook -i $base_dir/inventory/hosts $base_dir/$1.yaml

    info "deploy $1 Success"
}

main "$@"