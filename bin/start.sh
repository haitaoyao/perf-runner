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
	echo
	echo "$0 - perf-runner start script"
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
if [ ! -d $PERF_RUNNER_DEPLOY_DIR/$perf_test_name ]
then
	# no perf test in deploy folder, exit 
	echo "no perf test : $perf_test_name in $PERF_RUNNER_DEPLOY_DIR"
	exit 1
fi

# sync files
bash $current_dir/sync_files.sh $perf_test_name
if [ "$?" -ne 0 ]
then
	exit 2
fi

bash $current_dir/start_all.sh $perf_test_name
if [ "$?" -ne 0 ]
then
	exit 2
fi
