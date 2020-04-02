#!/bin/bash
# Check Settings is correct or not

source $(dirname $(cd `dirname $0`;pwd))/bin/env.sh
source $base_dir/bin/log.sh

note "开始一键部署前最好，检查与目标主机的连接是否正常。"
ansible-playbook -i "$base_dir/inventory/hosts" "$base_dir/playbooks/connection-test.yml"
