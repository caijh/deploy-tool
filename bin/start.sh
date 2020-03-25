#!/bin/bash

source $(dirname $(cd `dirname $0`;pwd))/bin/env.sh
source $base_dir/bin/log.sh

deployment_home="playbooks"

function main()
{
    $base_dir/bin/checkplugins.sh

    $base_dir/bin/checksettings.sh

    deploy_main

    deploy_microservices
}

function deploy_main() {
    local length=`cat $base_dir/deployment.yaml | shyaml get-length`
    local i=0
    while [ $i -lt $length ] 
    do
        local hosts=$(cat "$base_dir/deployment.yaml" | shyaml get-value $i.hosts)
        local role_length=$(cat "$base_dir/deployment.yaml" | shyaml get-length $i.roles)
        local j=0
        while [ $j -lt $role_length ] 
        do
            local role=$(cat "$base_dir/deployment.yaml" | shyaml get-value $i | shyaml get-value roles.$j)

            cat "$base_dir/templates/playbook.yaml" > "$base_dir/$deployment_home/${role}.yaml"
            sed -i "s/\<host\>/$hosts/;s/\<role\>/$role/" "$base_dir/$deployment_home/${role}.yaml"
            deploy $role
            j=$[ $j+1 ]
        done
        i=$[ $i+1 ]
    done
}

function deploy()
{
    info "开始部署 $1"

    local main_template="main.yaml"
    if [ -e $base_dir/$deployment_home/roles/$1/files/check.ps1 ] 
    then
        main_template="main_win.yaml"
    fi

    if [ ! -d "$base_dir/$deployment_home/roles/$1/files/config" ] 
    then
        mkdir "$base_dir/$deployment_home/roles/$1/files/config"
    fi

    if [ ! -d "$base_dir/$deployment_home/roles/$1/tasks" ] 
    then
        mkdir "$base_dir/$deployment_home/roles/$1/tasks"
    fi
    
    cp $base_dir/templates/$main_template $base_dir/$deployment_home/roles/$1/tasks/main.yaml

    ANSIBLE_LOG_PATH="$base_dir/logs/${1}.log" ansible-playbook -i $base_dir/inventory/hosts $base_dir/$deployment_home/$1.yaml --extra-vars "base_dir=$base_dir"

    local test_result=`cat $base_dir/logs/${1}_test.log`
    if [ $test_result -eq 0 ] 
    then
        success "部署$app_name成功"
    else
        error "部署$app_name失败, 请修改后，再执行"
        exit 1
    fi
    
}

function deploy_microservices() {
    local length=`cat $base_dir/microservices.yaml | shyaml get-length microservices`
    local i=0
    while [ $i -lt $length ] 
    do
        local app_info=$(cat "$base_dir/microservices.yaml" | shyaml get-value microservices.$i)
        local app_name=$(cat "$base_dir/microservices.yaml" | shyaml get-value microservices.$i | shyaml get-value app_name)
        local image=$(cat "$base_dir/microservices.yaml" | shyaml get-value microservices.$i | shyaml get-value image)
        local image_tag=$(cat "$base_dir/microservices.yaml" | shyaml get-value microservices.$i | shyaml get-value image_tag)

        # 删除原role
        if [ -d "$base_dir/tmp/playbooks/roles/$app_name" ] 
        then
            rm -rf "$base_dir/tmp/playbooks/roles/$app_name"
        fi
        # 根据模板生成具体的role
        cat "$base_dir/templates/playbook.yaml" > "$base_dir/tmp/playbooks/${app_name}.yaml"  
        sed -i "s/\<host\>/k8s/;s/\<role\>/$app_name/" "$base_dir/tmp/playbooks/${app_name}.yaml"
        cp -r "$base_dir/templates/microservice" "$base_dir/tmp/playbooks/roles/$app_name"

        info "开始部署微服务：$app_name"

        ansible-playbook -i "$base_dir/inventory/hosts" "$base_dir/tmp/playbooks/${app_name}.yaml" --extra-vars "base_dir=$base_dir app_name=$app_name image=$image image_tag=$image_tag"
        
        success "部署成功"

        i=$[ $i+1 ]
    done
}

main "$@"