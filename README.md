# deploy-tool
## 目录说明
```
deploy-tool
|-- all 微服务jenkins打包出来的镜像等
|-- bin 可以执行的脚本文件
|   |-- func 一些公共的shell函数
|-- inventory 主机清单目录
|   |-- group_vars 主机分组变量
|   |-- host_vars 主机变量
|   |-- host 主机
|-- logs 日志目录
|-- playbooks 部署脚本
|   |-- roles 部署脚本, playbook、role定义请参考ansible 
|-- plugins 部署用到的插件，插件的安次包
|-- templates 模板目录
|   |-- xxx 某一模板
|   |-- main.yaml 默认的单个组件的部署流程模板.
|-- tmp 临时目录
|-- deployment.yaml 需要部署主要组件，如redis, kafka等
|-- microservice.yaml 需要部署的微服务
```

## 使用
### 配置
1. 在`inventory/hosts`中修改主机信息
2. 根据实际部署情况修改`inventory/group_vars`和`inventory/host_vars`中定义的变量值

### 一键部署
使用`bin/start`命令,会顺序一键部署deployment.yaml及microservice.yaml中声明的部署组件。
### 只部署某一组件, 暂不支持模板templates目录中的部署
`bin/deployctrl.sh -a deploy -h $localhost -r $role`
选项说明
- `-a` 操作，可选(deploy)
- `-h` 目标主机, inventory/hosts文件中配置的主机
- `-r` 部署脚本role,部署名称
- `-t` 可选;指定使用哪个模板部署来部署,模板需要在templates目录中存在;
