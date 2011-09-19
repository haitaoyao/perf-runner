#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.15:23:45
# 
# this is used to monitor the current perf status of the test
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/../lib/env.sh
# print the help info
function print_help()
{
	echo
	printf "$0 - check the current status of running performance test\n\n"
	printf "Usage: $0 -n perf_test_name -u perf_test_uuid -i refresh_interval -c collector_name\n"
	echo
	printf "\t-n\t the perf test name in deploy dir\n"
	printf "\t-u\t the perf test uuid\n"
	printf "\t-i\t the refresh interval. default: 1 second. unit: second\n"
	printf "\t-c\t the collector name. \n"
	echo
}

if [ -z "$1" ]
then
	print_help
	exit 1
fi
while getopts ":n:u:i:c:" OPT
do
	case $OPT in
		n)
			perf_test_name=$OPTARG
			;;
		u)
			perf_test_uuid=$OPTARG
			;;
		i)
			monitor_interval=$OPTARG
			;;
		c)
			collector_name=$OPTARG
			;;
		?)
			print_help
			;;
		*)
			print_help
			exit 1
			;;
	esac	
done
if [ -z "$perf_test_name" -o -z "$perf_test_uuid" -o -z "$collector_name" ]
then
	print_help
	exit 1
fi
if [ -z "$monitor_interval" ]
then
	monitor_interval=1
fi

if [ ! -d "$PERF_RUNNER_DEPLOY_DIR/$perf_test_name" ]
then
	echo "invalid perf_test_name"
	print_help
	exit 1
fi

if [ ! -d "$PERF_RUNNER_COLLOCTOR_DIR/$collector_name" ]
then
	echo "invalid collector name"
	print_help
	exit 1
fi
cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name

function monitor_perf_test()
{
	printf "\t\t time: $(date +'%Y-%m-%d %H:%M:%S') collector: $collector_name\n"
	for server_group in $(ls |sort)
	do
		if [ ! -d "$server_group" ]
		then
			continue
		fi
		echo "test unit: $server_group"
		for server_address in $(get_server_address $server_group/servers.conf)
		do
			printf "\t$server_address:\t"
			fetch_command="tail -1 $(get_perf_test_log_dir)/$collector_name.csv"
			printf "$(ssh localhost $fetch_command)\n"
		done
	done

}

while :
do
	monitor_perf_test
	sleep $monitor_interval
	printf "\n\n"
done

