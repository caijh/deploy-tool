#!/bin/bash
rpm -Uvh --force --nodeps packages/*rpm

cd ansible-$1 && python setup.py install