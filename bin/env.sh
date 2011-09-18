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
export PERF_RUNNER_CONFIG_DIR=$PERF_RUNNER_HOME/config
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

get_perf_test_runtime_dir()
{
	runtime_dir=$PERF_RUNNER_RUNTIME/$perf_test_name/$perf_test_uuid
	if [ ! -d $runtime_dir ]
	then
		mkdir -p $runtime_dir
	fi
	echo "$runtime_dir"
}

# get the perf test data dir
get_perf_test_data_dir()
{
	perf_data_dir="$PERF_RUNNER_HOME/data/$perf_test_name/$perf_test_uuid"
	if [ ! -d "$perf_data_dir" ]
	then
		mkdir -p $perf_data_dir
	fi
	echo "$perf_data_dir"
}

# get the perf test log dir
get_perf_test_log_dir()
{
	perf_log_dir="$PERF_RUNNER_HOME/logs/$perf_test_name/$perf_test_uuid"
	if [ ! -d "$perf_log_dir" ]
	then
		mkdir -p $perf_log_dir
	fi
	echo "$perf_log_dir"
}
create_perf_test_uuid()
{
	perf_test_name=$1
	echo "${perf_test_name}__$(date +%Y%m%d.%H%M%S.$(expr $(date +%s ) % 100)) "
}

get_server_address()
{
	server_file=$1
	echo "$(cat $server_file|grep -v  '#' )"
}
