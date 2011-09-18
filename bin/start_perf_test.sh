#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to start the local perf test
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

perf_test_name=$1
if [ -z "$perf_test_name" ]
then
	echo "no perf_test_name"
	exit 1
fi
server_group=$2
if [ -z "$server_group" ]
then
	echo "no server_group"
	exit 1
fi
perf_test_uuid=$3
if [ -z "$perf_test_uuid" ]
then
	echo "no perf_test_uuid"
	exit 1
fi
cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name 

perf_pid_dir=$(get_perf_test_runtime_dir)
nohup bash $server_group/start.sh >> $(get_perf_test_log_dir)/$server_group.csv 2>$(get_perf_test_data_dir)/$server_group.log &

# remember the pid 
echo $! > $perf_pid_dir/${perf_test_name}.pid
