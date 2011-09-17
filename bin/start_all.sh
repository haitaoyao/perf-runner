#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to start all the perf tests 
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

perf_test_name=$1

if [ -z "$perf_test_name" ]
then
	echo "Usage: $0 perf_test_name"
	exit 1
fi


cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name 

for server_group in $(ls |sort)
do
	if [ ! -d $server_group ]
	then
		continue
	fi
done
