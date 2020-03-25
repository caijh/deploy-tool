#!/bin/sh

source $(dirname $(cd `dirname $0`;pwd))/bin/env.sh
source $base_dir/bin/log.sh

function install_shyaml()
{
    local current_dir=`pwd`
    cd $base_dir/plugins/shyaml
    python setup.py install
    cd $current_dir
}

if [ -z $(command -v ansible) ] 
then
    warn "运行自动化部署需要安装ansible"
    info "尝试安装ansible"
    exec rpm -Uvh --force --nodeps $base_dir/plugins/ansible/package/*rpm
    ret=$?
    if [ $ret -ne 0 ] 
    then
        error "安装ansible失败"
        info "请访问 https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html, 查看如何安装ansible."
        exit 1
    fi
fi

if [ -z $(command -v shyaml) ] 
then
    info "开始安装shyaml依赖"
    install_shyaml
    success "安装shyaml成功"
fi