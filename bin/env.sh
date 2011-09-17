#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to export the env for all the scripts
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
export PERF_RUNNER_HOME="$(cd $(dirname $0)/../;pwd)"
export PERF_RUNNER_DEPLOY_DIR=$PERF_RUNNER_HOME/deploy
export PERF_RUNNER_RUNTIME=$PERF_RUNNER_HOME/tmp/runtime
if [ ! -d $PERF_RUNNER_HOME/logs ]
then
	mkdir $PERF_RUNNER_HOME/logs
fi

if [ ! -d $PERF_RUNNER_HOME/data ]
then
	mkdir $PERF_RUNNER_HOME/data
fi

if [ ! -d $PERF_RUNNER_RUNTIME ]
then
	mkdir -p $PERF_RUNNER_RUNTIME
fi

get_perf_test_runtim_dir()
{
	perf_test_name=$1
	if [ -z "$perf_test_name" ]
	then
		exit 1
	fi
	return 
}
