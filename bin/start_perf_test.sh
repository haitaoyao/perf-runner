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

cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name 
