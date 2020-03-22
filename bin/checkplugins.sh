#!/bin/sh

source $(dirname $(cd `dirname $0`;pwd))/bin/env.sh
source $base_dir/bin/log.sh

if [ -z $(command -v ansible) ] 
then
    error "运行自动化部署需要安装ansible"
    info "请访问 https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html, 查看如何安装ansible."
    exit 1
fi