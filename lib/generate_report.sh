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

perf_data_dir=$(get_perf_test_data_dir)
if [ ! -d "$perf_data_dir" ]
then
	echo "no data dir named: $perf_data_dir"
	exit 1
fi

function process_test_unit()
{
	write_to_report "<table align='center' border='1'>"
	test_unit=$1
	cd $test_unit
	write_to_report "<tr><td>TestUnit: $test_unit</td></tr>"
	write_to_report "<tr><td>"
	for server_address in $(ls )
	do
		cd $server_address
		write_to_report "<table><tr><td >Server: $server_address</td></tr><tr><table>"
		for data_file in $(ls *.csv|grep -v $perf_test_name)
		do
			collector_name=$(echo $data_file|awk -F'.csv' '{print $1}')
			write_to_report "<tr><td>$collector_name(<a href='$test_unit/$server_address/$data_file'>Download</a>)</td></tr>"
			if [ -f "$collector_name.png" ]
			then
				write_to_report "<tr><td><img src='$test_unit/$server_address/$collector_name.png' /></td></tr>"
				write_to_report "<tr><td></td></tr>"
			fi
		done
		write_to_report "</tr></table>"
		cd ..
	done
	write_to_report "</td></tr></table>"
}

cd $perf_data_dir
report_file=$perf_data_dir/report.html
echo "<html><title> performance test report for $perf_test_name, uuid:$perf_test_uuid</title><body>" > $report_file
function write_to_report()
{
	report_content=$1
	echo $report_content >> $report_file
}
write_to_report " <table align='center'><tr><td>Performance Test Report</td></tr><tr><td>name: $perf_test_name</td></tr><tr><td>uuid:$perf_test_uuid</td></tr>"
start_timestamp=$(echo $perf_test_uuid|awk -F '__' '{print $2}')
start_date=$(echo $start_timestamp|cut -d '.' -f 1)
start_time=$(echo $start_timestamp|cut -d '.' -f 2)
write_to_report "<tr><td>start_time: $start_date $start_time</td></tr></table>" 

#write_to_report "<table align='center' border='1'>"
for test_unit in $(ls )
do
	if [ ! -d "$test_unit" ]
	then
		continue
	fi
	process_test_unit $test_unit	
	cd $perf_data_dir
done
