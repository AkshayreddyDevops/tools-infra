#!/bin/bash
# pip3.11 install ansible
# ansible-pull -i localhost, -U "location to main.yml" /*-e <list of variables> ex*/ -e ${env_name} -e ${role_name} 2>&1 | tee /opt/userdata.log /* tee is used to print output on screen as well as write to file and 2 is error which we are redirecting to 1 where 1 is logfile*/
dnf install docker -y
