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
	echo "Stop the perf test"
	echo "Usage: $0 perf_test_name perf_test_uuid"
	echo
	printf "\tperf_test_name\t the perf test name in deploy folder\n"
	printf "\tperf_test_uuid\t the perf test uuid, if not known, use status.sh to find it out\n"
	echo
}

perf_test_name=$1
perf_test_uuid=$2
if [ -z "$perf_test_name" -o -z "$perf_test_uuid" ]
then
	print_help
	exit 1
fi

if [ ! -d "$PERF_RUNNER_DEPLOY_DIR/$perf_test_name" ]
then
	echo "invalid perf test name"
	echo
	print_help
	exit 1
fi
