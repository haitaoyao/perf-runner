#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-19.20:09:09
# 
# used to collect cpu usage info 
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"

wait_interval=5
echo "#timestamp,usr,nice,sys,iowait,irq,soft,steal,guest,idle"
while :
do
	sleep $wait_interval
	echo "$(date +%Y%m%d%H%M%S)$(mpstat |grep all|awk -F 'all' '{print $2}'|sed 's/ * /,/g')"
done
