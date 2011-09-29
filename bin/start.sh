#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to start the perf test and gather the basic perf data
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/../lib/env.sh
# print the help information
function print_help()
{
	echo
	echo "$0 - perf-runner start script"
	echo "Usage: $0 -n perf_test_name -c end_callback -d running_duration(unit: hour)"
	echo
	printf "\t-n\t the perf test name deployed in the deploy folder\n"
	printf "\t-c\t the callback executive file to call when the perf test is finished\n" 
	printf "\t-d\t how many hours the perf test will be running. when the time is reached, the runner will stop the perf test automatically\n"
	echo

}	

if [ -z "$1" ]
then
	print_help
	exit 1
fi

#parse the arguments
while getopts ":n:c:d:" OPT
do
	case $OPT in
		n)
			perf_test_name=$OPTARG
			;;
		c)
			perf_test_callback=$OPTARG
			;;
		d)
			perf_test_duration=$OPTARG
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
bash $PERF_RUNNER_LIB_DIR/sync_files.sh $perf_test_name
if [ "$?" -ne 0 ]
then
	exit 2
fi

bash $PERF_RUNNER_LIB_DIR/start_all.sh $perf_test_name
if [ "$?" -ne 0 ]
then
	exit 2
fi
