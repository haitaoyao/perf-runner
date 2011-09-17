#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to start the perf test and gather the basic perf data
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh
# print the help information
function print_help()
{
	echo "perf-runner start script"
	echo "Usage: $0 -n perf_test_name"
	echo
	printf "\tperf_test_name\t the perf test name deployed in the deploy folder\n"
	echo

}	

if [ -z "$1" ]
then
	print_help
	exit 1
fi

#parse the arguments
while getopts ":n:" OPT
do
	case $OPT in
		n)
			perf_test_name=$OPTARG
			;;
		?)
			print_help
			exit 1
			;;
		:)
			print_help
			exit 1
			;;
	esac

done
if [ ! -d $PERF_RUNNER_DEPLOY_FOLDER/$perf_test_name ]
then
	# no perf test in deploy folder, exit 
	echo "no perf test : $perf_test_name in $PERF_RUNNER_DEPLOY_FOLDER"
	exit 1
fi
