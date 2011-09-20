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

which gnuplot >/dev/null 2>&1
if [ "$?" -ne 0 ]
then
	echo "no gnuplot found! cant't plot!"
	exit 1
fi


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

function get_data_field_name()
{
	f_index=$1
	echo $data_title|awk -F ',' "{print \$$f_index}"
}

function generate_plot_script()
{
	data_file=$1
	collector_name=$2
	echo "set terminal png"
	echo "set datafile separator ','"
	echo "set output '$collector_name.png'"
	echo "set timefmt '%Y%m%d%H%M%S'"
	echo "set xdata time"
	printf "plot "
	data_title=$(head -1 $data_file)
	field_count=$(echo $data_title|awk -F',' '{print NF}')
	for ((f_index=2;f_index<$field_count;f_index++))
	do
		printf "\"$data_file\" using 1:$f_index with lines title \'$(get_data_field_name $f_index)\', "
	done
	printf "\"$data_file\" using 1:$field_count with lines title \'$(get_data_field_name $field_count)\' \n "
}
function process_test_unit()
{
	test_unit=$1
	cd $test_unit
	for server_address in $(ls )
	do
		cd $server_address
		for data_file in $(ls *.csv|grep -v $perf_test_name)
		do
			collector_name=$(echo $data_file|awk -F'.csv' '{print $1}')
			generate_plot_script $data_file $collector_name > $collector_name.gnuplot
			gnuplot -persit $collector_name.gnuplot
		done
		cd ..
	done
}

cd $perf_data_dir
for test_unit in $(ls )
do
	if [ ! -d "$test_unit" ]
	then
		continue
	fi
	process_test_unit $test_unit	
	cd $perf_data_dir
done
