#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.09:43:18
# 
# This is used to check the perf test status of local machine 
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

perf_test_name=$1
server_group=$2
perf_test_uuid=$3
if [ -z "$perf_test_name" ]
then
	echo "Usage: $0 perf_test_name server_group perf_test_uuid"
	exit 1
fi

if [ ! -d "$PERF_RUNNER_RUNTIME/$perf_test_name" ]
then
	echo "no perf test: $perf_test_name runnning"
	exit 0
fi

function status_collectors()
{
	for pid_file in $(ls *.pid|grep -v "$perf_test_name")
	do
		collector_pid=$(cat $pid_file)
		collector_name=$(echo $pid_file|awk -F '.pid' '{print $1}')	
		if [ -n "$(ps aux|grep $collector_pid)" ]
		then
			printf "\tcollector: $collector_name(pid: $collector_pid) is alive\n"
		else
			printf "\tcollector: $collector_name(pid: $collector_pid) is dead\n"
		fi
	done
		
}

function status_perf_test()
{
	perf_test_uuid=$1
	cd $perf_test_uuid/$server_group
	if [ -f "$perf_test_name.pid" ]
	then
		perf_test_pid=$(cat $perf_test_name.pid)
		if [ -z "$(ps aux|grep $perf_test_pid|grep -v grep)" ]
		then
			printf "\t$perf_test_uuid is dead already\n"
			cleanup_runtime_dir
		else
			printf "\tperf_test: $perf_test_uuid is still alive\n"
			status_collectors
			cd ../
		fi
	else
		cleanup_runtime_dir
	fi
}
cd $PERF_RUNNER_RUNTIME/$perf_test_name

if [ -n "$perf_test_uuid" ]
then
	status_perf_test $perf_test_uuid
else
	echo "check all the perf  test for $perf_test_name"
	now_cwd=$(pwd)
	for perf_test_uuid in $(ls |sort)
	do
		cd $now_cwd
		if [ -d "$perf_test_uuid/$server_group" ]
		then
			status_perf_test $perf_test_uuid
			echo "--------------------------------------------"
			alive_perf_found='true'
		else
			echo "no uuid: $perf_test_uuid server_group: $server_group here"
		fi
	done
	if [ -z "$alive_perf_found" ]
	then
		printf "\tno alive perf test found\n"
	fi
fi
echo
echo "###############################################"
echo
