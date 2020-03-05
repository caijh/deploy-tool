#!/bin/bash
# Check Settings is correct or not

base_dir=$(cd `dirname $0`; pwd)/..

source $base_dir/bin/log.sh

note "Before auto deploy, we must check connection. If connection is failed, will stop to deploy!"
ansible-playbook -i inventory/hosts connection-test.yml