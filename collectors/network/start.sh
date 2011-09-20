#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-19.20:09:09
# 
# used to collect network
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"

wait_interval=5
network_interface=eth0
echo "#timestamp,in_speed(KB/s),out_speed(KB/s)"
net_info=$(ifconfig eth0|grep bytes)
last_in=$(echo $net_info|awk -F 'bytes:' '{print $2}'|cut -d ' ' -f 1)
last_out=$(echo $net_info|awk -F 'bytes:' '{print $3}'|cut -d ' ' -f 1)
net_value=$(($wait_interval * 1024 ))
while :
do
	sleep $wait_interval
	net_info=$(ifconfig eth0|grep bytes)
	now_in=$(echo $net_info|awk -F 'bytes:' '{print $2}'|cut -d ' ' -f 1)
	now_out=$(echo $net_info|awk -F 'bytes:' '{print $3}'|cut -d ' ' -f 1)
	in_speed=$(expr $(expr $now_in - $last_in ) / $net_value)
	out_speed=$(expr $(expr $now_out - $last_out ) / $net_value)
	last_in=$now_in
	last_out=$now_out
	echo "$(date +%Y%m%d%H%M%S), $in_speed, $out_speed"
done
