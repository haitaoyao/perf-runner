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
perf_test_uuid=$2

if [ -z "$perf_test_name" ]
then
	echo "Usage: $0 perf_test_name perf_test_uuid"
	exit 1
fi

if [ ! -d "$PERF_RUNNER_RUNTIME/$perf_test_name" ]
then
	echo "no perf test: $perf_test_name runnning"
	exit 0
fi

function cleanup_collectors()
{
	for pid_file in $(ls *.pid|grep -v "$perf_test_name")
	do
		collector_pid=$(cat $pid_file)
		if [ -n "$(ps aux|grep $collector_pid)|grep -v 'grep'" ]
		then
			kill -9 $collector_pid
			printf "\tcollector: $pid_file killed\n"
		fi
	done
}

function status_collectors()
{
	for pid_file in $(ls *.pid|grep -v "$perf_test_name")
	do
		collector_pid=$(cat $pid_file)
		if [ -n "$(ps aux|grep $collector_pid)" ]
		then
			printf "\tcollector: $pid_file is alive\n"
		else
			printf "\tcollector: $pid_file is dead\n"
		fi
	done
		
}

function status_perf_test()
{
	perf_test_uuid=$1
	cd $perf_test_uuid
	if [ -f "$perf_test_name.pid" ]
	then
		perf_test_pid=$(cat $perf_test_name.pid)
		if [ -z "$(ps aux|grep $perf_test_pid|grep -v grep)" ]
		then
			printf "\t$perf_test_uuid is dead already\n"
			cleanup_collectors
			cd ../
			rm -rf $perf_test_uuid
		else
			printf "\tperf_test: $perf_test_uuid is still alive\n"
			status_collectors
			cd ../
		fi
	else
		cleanup_collectors
		cd ../
		rm -rf $perf_test_uuid
	fi
}
cd $PERF_RUNNER_RUNTIME/$perf_test_name

if [ -n "$perf_test_uuid" ]
then
	status_perf_test $perf_test_uuid
else
	echo "check all the perf  test for $perf_test_name"
	for perf_test_uuid in $(ls |sort)
	do
		if [ -d "$perf_test_uuid" ]
		then
			status_perf_test $perf_test_uuid
			echo "###############################################"
		fi
	done
fi
echo "###############################################"
echo "###############################################"
echo
