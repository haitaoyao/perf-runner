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
export PERF_RUNNER_DATA_DIR=$PERF_RUNNER_HOME/data
export PERF_RUNNER_COLLOCTOR_DIR=$PERF_RUNNER_HOME/collectors
export PERF_RUNNER_LIB_DIR=$PERF_RUNNER_HOME/lib
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
	if [ -z "$perf_test_name" -o -z "$perf_test_uuid" -o -z "$server_group" ]
	then
		echo "failed to get perf runtime dir"
		exit 3
	fi
	runtime_dir=$PERF_RUNNER_RUNTIME/$perf_test_name/$perf_test_uuid/$server_group
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
	perf_log_dir="$PERF_RUNNER_HOME/logs/$perf_test_name/$perf_test_uuid/$server_group"
	if [ ! -d "$perf_log_dir" ]
	then
		mkdir -p $perf_log_dir
	fi
	echo "$perf_log_dir"
}
create_perf_test_uuid()
{
	perf_test_name=$1
	echo "${perf_test_name}__$(date +%Y%m%d.%H%M%S.$(expr $(date +%N ) % 100)) "
}

get_server_address()
{
	server_file=$1
	echo "$(cat $server_file|grep -v  '#' )"
}

# kill the collectors
function cleanup_collectors()
{
	for pid_file in $(ls *.pid|grep -v "$perf_test_name")
	do
		collector_pid=$(cat $pid_file)
		collector_name=$(echo $pid_file|awk -F '.pid' '{print $1}')	
		if [ -n "$(ps aux|grep $collector_pid)|grep -v 'grep'" ]
		then
			kill -9 $collector_pid
			rm $pid_file
			printf "\tcollector: $collector_name(pid: $collector_pid) killed\n"
		fi
	done
}

# cleanup runtime dir
function cleanup_runtime_dir()
{
	cleanup_collectors
	cd ../
	rm -rf $server_group
	if [ -z "$(ls)" ]
	then
		cd ../
		rm -rf $perf_test_uuid
	fi
}

# get the perf data dir
get_perf_data_dir()
{
	perf_data_dir="$PERF_RUNNER_DATA_DIR/$perf_test_name/$perf_test_uuid/$server_group/$server_address"
	if [ ! -d "$perf_data_dir" ]
	then
		mkdir -p $perf_data_dir
	fi
	echo $perf_data_dir
}
