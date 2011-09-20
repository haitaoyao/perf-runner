#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.08:46:06
# 
# this is used to get the cpu load
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"

get_cpu_load()
{
	echo "#timestamp,load_1,load_5,load_15"
	while : 
	do
		echo "$(date +%Y%m%d%H%M%S),$(w |grep 'load average:'|awk -F 'load average:' '{print $2}')"
		sleep 5 
	done
}

get_cpu_load	
