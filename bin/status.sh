#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.09:43:18
# 
# This is used to get the status of the test cluster
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh
# print the help information
print_help()
{
	echo "Usage: $0 perf_test_name perf_test_uuid(optional)"
	printf "\tperf_test_name\t the perf test name in the deploy folder\n"
	printf "\tperf_test_uuid(optional)\t the uuid of the test, if not provided, this will check all the status"
}
perf_test_name=$1
perf_test_uuid=$2
if [ -z "$perf_test_name" ]
then
	print_help
	exit 1
fi
if [ ! -d "$PERF_RUNNER_DEPLOY_DIR/$perf_test_name" ]
then
	echo "invalid perf test name: $perf_test_name"
	print_help
	exit 2
fi
cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name

check_server_group_status()
{
	echo
	echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
	echo
	echo "test unit: $server_group"
	for server_address in $(get_server_address $server_group/servers.conf)
	do
		echo "perf_test: $perf_test_name status @ $server_address: "
		ssh $server_address "bash $PERF_RUNNER_HOME/bin/check_status.sh $perf_test_name $perf_test_uuid"
	done
}

for server_group in $(ls |sort)
do
	if [ ! -d $server_group ]
	then
		continue
	fi
	check_server_group_status	
done
