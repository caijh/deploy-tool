#!/bin/bash
# check mysql is installed or not, and compare mysql version
mysql_server_version=$(rpm -qi mysql-server|grep Version)

#Check if we have got the mysql-server version or not.If got,then we have installed mysql.
if [ -n "$mysql_server_version" ]
then
    if $mysql_server_version == $1
    then
        echo -n "Equal"
    else
        echo -n "Upgrade"
    fi
else
    echo -n "New"
fi