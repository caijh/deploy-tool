#!/bin/bash

source ./env.sh
source ./log.sh

function main()
{
    $base_dir/bin/checkplugins.sh

    $base_dir/bin/checksettings.sh

    # read_deployment_orders "$base_dir/deployment.orders.txt"

    deploy_microservices
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
        deploy_main $item
    done
}

function deploy_main()
{
    info "开始部署 $1"

    ansible-playbook -i $base_dir/inventory/hosts $base_dir/$1.yaml
    
    ret=$?
    if [ $ret -eq 0 ] 
    then
        success "部署$1成功"
    else
        error "部署$1失败"
    fi
    
}

function deploy_microservices() {
    local length=`cat $base_dir/microservices.yaml | shyaml get-length microservices`
    local i=0
    while [ $i -lt $length ] 
    do
        local app_info=$(cat "$base_dir/microservices.yaml" | shyaml get-length microservices.$i)
        local app_name=$(echo $app_info | shyaml get-value app_name)
        local image=$(echo $app_info | shyaml get-value image)
        local image_tag=$(echo $app_info | shyaml get-value image_tag)

        # 删除原role
        if [ -d "$base_dir/tmp/playbooks/roles/$app_name"] 
        then
            rm -rf "$base_dir/tmp/playbooks/roles/$app_name"
        fi
        # 根据模板生成具体的role
        cat <<EOF > "$base_dir/tmp/playbooks/${app_name}.yaml"
---
- hosts: k8s 
  roles:
    - app_name
EOF     
        sed -i "s/app_name/$app_name/" "$base_dir/tmp/playbooks/${app_name}.yaml"
        cp "$base_dir/templates/microserivce" "$base_dir/tmp/playbooks/roles/$app_name"

        info "开始部署微服务：$app_name"

        ansible-playbook -i "$base_dir/inventory/hosts" "$base_dir/tmp/playbooks/${app_name}.yaml" --extra-vars "app_name=$app_name image=$image image_tag=$image_tag"
        
        success "部署成功"

        i=$[ $i+1 ]
    done
}

main "$@"