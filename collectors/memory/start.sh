#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-19.20:09:09
# 
# used to collect memory info
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"

wait_interval=5
echo "#timestamp,total,used,free,shared,buffers,cached,swap_total,swap_used,swap_free"
while :
do
	mem_info=$(free -m |awk '($1~"Mem"){MEM_2=$2;MEM_3=$3;MEM_4=$4;MEM_5=$5;MEM_6=$6;MEM_7=$7}($1~"Swap"){SWAP_2=$2;SWAP_3=$3;SWAP_4=$4}END{print MEM_2,MEM_3,MEM_4,MEM_5,MEM_6,MEM_7,SWAP_2,SWAP_3,SWAP_4}')
	echo "$(date +%Y%m%d%H%M%S),$(echo $mem_info|sed 's/ /,/g')"
	sleep $wait_interval
done
