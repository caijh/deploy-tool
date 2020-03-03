#!/bin/bash
if [[-x $(command -v mysql)]] 
then
    echo -n 'New'
else
    mysql_server_version = $(mysql --version | awk '{ print $5 }'|awk -F\, '{ print $1 }')
    if $mysql_server_version == $1
    then
        echo -n "Equal"
    else
        echo -n "Upgrade"
    fi
fi