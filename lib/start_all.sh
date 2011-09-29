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
perf_test_duration=$2
perf_test_callback=$3
if [ -z "$perf_test_name" ]
then
	echo "Usage: $0 perf_test_name"
	exit 1
fi


cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name 

#create the uuid
perf_test_uuid=$(create_perf_test_uuid $perf_test_name)
echo "start the perf test, uuid: $perf_test_uuid"
for server_group in $(ls |sort)
do
	if [ ! -d $server_group ]
	then
		continue
	fi
	echo "start server_group: $server_group"
	for server_address in $(cat $server_group/servers.conf)
	do
		ssh $server_address "bash $PERF_RUNNER_LIB_DIR/start_collectors.sh $perf_test_name $server_group $perf_test_uuid"
		ssh $server_address "bash $PERF_RUNNER_LIB_DIR/start_perf_test.sh $perf_test_name $server_group $perf_test_uuid"
		exit_code=$?
		if [ "$exit_code" -ne '0' ]
		then
			printf "\tperf_test: $perf_test_name server_group: $server_group server: $server_address start failed!!!\n"
		else
			printf "\tperf_test: $perf_test_name server_group: $server_group server: $server_address start successfully\n"
		fi
	done
done

function schedule_callback()
{
	if [ -z "$perf_test_callback" -o -z "$perf_test_duration" ]
	then
		return 0
	fi
	current_time=$(date +%s)
	end_time=$(date -d "$perf_test_duration hours" +%s)
	running_interval=$(expr $end_time - $current_time)
	run_callback $running_interval	 &
	end_time=$(date -d "$perf_test_duration hours" +'%Y-%m-%d %H:%m:%S')
	printf "\t perf test: $perf_test_name will be stopped at $end_time, callback: $perf_test_callback will be executed\n"
}

function run_callback()
{
	sleep_interval=$1
	sleep $sleep_interval
	bash "$PERF_RUNNER_BIN_DIR/stop.sh -n $perf_test_name -u $perf_test_uuid" >/dev/null 2>&1
	$perf_test_callback
}
echo
echo "##############################################"
echo "#"
echo "#               perf test: $perf_test_name"
echo "#               perf uuid: $perf_test_uuid"
echo "#		       started"
echo "#"
echo "##############################################"
