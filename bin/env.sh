#!/bin/bash
# check deploy-tool plugins is installed or not

base_dir=$(cd `dirname $0`; pwd)/..

source $base_dir/bin/log.sh

if [ -z $(command -v ansible) ] 
then
    error "Yout need to install ansible..."
    info "visit https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html to see how to install ansible"
    exit 1
fi