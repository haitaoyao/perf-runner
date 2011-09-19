#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-19.20:09:09
# 
# used to collect iostat
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"

wait_interval=5
echo "#timestamp,tps, kB_read/s, kB_wrtn/s, kB_read, kB_wrtn"
while :
do
	sleep $wait_interval
	echo "$(date +%Y%m%d%H%M%S)$(iostat -d | egrep '*[0-9][0-9]'|tail -1|sed 's/ * /,/g')"
done
