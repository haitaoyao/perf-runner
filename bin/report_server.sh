#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-18.11:02:31
# 
# this is used to stop the perf test 
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/../lib/env.sh

function print_help()
{
	echo
	echo "$0 - start the perf test data server"
	echo "Usage: $0 -n perf_test_name -i perf_test_uuid -p server_port"
	echo
	printf "\t-n\t the perf test name in deploy folder\n"
	printf "\t-i\t the perf test uuid, if not known, use status.sh to find it out\n"
	printf "\t-p\t http port for the data server, default: 8080\n"
	echo
}

while getopts ":n:u:p:" OPT
do
	case $OPT in
		n)
			perf_test_name=$OPTARG
			;;
		u)
			perf_test_uuid=$OPTARG
			;;
		p)
			server_port=$OPTARF
			;;
		:)
			print_help
			exit 1
			;;
		?)
			print_help
			;;
	esac
done
if [ -z "$perf_test_name" -o -z "$perf_test_uuid" ]
then
	print_help
	exit 1
fi

if [ -z "$server_port" ]
then
	server_port=8080
fi
running_server=$(netstat -tlnp|grep $server_port |awk '{print $7}' 2>/dev/null )
if [ -n "$running_server" ]
then
	echo "server_port: $server_port is taken by : $running_server, choose another available port please."
	print_help
	exit 1
fi
if [ ! -d "$PERF_RUNNER_DEPLOY_DIR/$perf_test_name" ]
then
	echo "invalid perf test name"
	echo
	print_help
	exit 1
fi

perf_data_dir=$(get_perf_test_data_dir)
if [ ! -d "$perf_data_dir" ]
then
	echo "no data dir named: $perf_data_dir"
	exit 1
fi
cd $perf_data_dir

bash $PERF_RUNNER_LIB_DIR/plot.sh $perf_test_name $perf_test_uuid
bash $PERF_RUNNER_LIB_DIR/generate_report.sh $perf_test_name $perf_test_uuid
echo "start data server @ port: $server_port"
python -m SimpleHTTPServer $server_port 2>/dev/null
