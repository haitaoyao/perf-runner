#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.11:02:31
# 
# this is used to stop the perf test 
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

function print_help()
{
	echo "Usage: $0 perf_test_name perf_test_uuid"
}
perf_test_name=$1
perf_test_uuid=$2
if [ -z "$perf_test_name" -o -z "$perf_test_uuid" ]
then
	print_help
	exit 1
fi

pid_dir=$(get_perf_test_runtime_dir)

if [ ! -d "$pid_dir" ]
then
	echo "no pid dir for perf test: $perf_test_name, uuid: $perf_test_uuid"
	exit 2
fi

cd $pid_dir
function stop_perf_test()
{
	pid_file=$perf_test_name.pid
	if [ ! -f $pid_file ]
	then
		echo "no perf test: $perf_test_name, uuid: $perf_test_uuid alive"
		return 1
	fi
	perf_pid=$(cat $pid_file)
	if [ -n "$(ps aux|grep $perf_pid|grep -v grep)" ]
	then
		if [ -f "$PERF_DEPLOY_DIR/$perf_name/" ]	
	fi
}
cd $PERF_RUNNER_DELOY_DIR/$perf_test_name
