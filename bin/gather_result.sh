#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.11:02:31
# 
# this is used to gather all the result
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

function print_help()
{
	echo "Usage: $0 perf_test_name perf_test_uuid"
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
	echo "invalid perf test name: $perf_test_name"
	print_help
	exit 2
fi
cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name
function gather_perf_result()
{
	
	for server_address in $(get_server_address $server_group/servers.conf)
	do
		perf_data_dir=$(get_perf_data_dir)
		rsync -a $server_address:$(get_perf_test_log_dir)/ $perf_data_dir/
		printf "\t result from $server_address fetched\n"
	done
}
for server_group in $(ls |sort)
do
	echo "Fetch result for test unit: $server_group"
	if [ ! -d $server_group ]
	then
		continue
	fi
	gather_perf_result
done
