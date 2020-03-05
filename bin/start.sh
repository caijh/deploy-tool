#!/bin/bash

base_dir=$(cd `dirname $0`; pwd)/..

source $base_dir/bin/log.sh

function main()
{
    $base_dir/bin/env.sh

    $base_dir/bin/checksettings.sh

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

    success "deploy $1 Success"
}

main "$@"