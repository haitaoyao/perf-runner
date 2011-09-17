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

create the uuid
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
		ssh $server_address "$PERF_RUNNER_HOME/bin/start_perf_test.sh $perf_test_name"
		exit_code=$?
		if [ "$exit_code" -ne '0' ]
		then
			printf "\tperf_test: $perf_test_name server_group: $server_group server: $server_address start failed!!!\n"
		else
			printf "\tperf_test: $perf_test_name server_group: $server_group server: $server_address start successfully\n"
		fi
	done
done
