#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to sync  the files to all the servers
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
. $current_dir/env.sh

perf_test_name=$1
if [ -z "$perf_test_name" ]
then
	echo "no perf_test_name"
	exit 1
fi

cd $PERF_RUNNER_DEPLOY_DIR/$perf_test_name 

for server_group in $(ls |sort)
do
	if [ ! -d $server_group ]
	then
		continue
	fi
	if [ ! -f $server_group/servers.conf ]
	then
		echo "no servers.conf in $PERF_RUNNER_DEPLOY_DIR/$perf_test_name/$server_group, script exit"
		exit 2
	fi
	if [ "$(wc -l $server_group/servers.conf|awk '{print $1}')" -lt 1 ]
	then
		echo "no server address in $PERF_RUNNER_DEPLOY_DIR/$perf_test_name/$server_group/servers.conf, script exit"
		exit 2
	fi
	echo "rsync files for server group: $server_group, servers: "
	echo "$(cat $server_group/servers.conf)"
	for server_address in $(cat $server_group/servers.conf)
	do
		rsync -a --exclude-from=$PERF_RUNNER_CONFIG_DIR/sync_excluded_files $PERF_RUNNER_HOME/ $server_address:$PERF_RUNNER_HOME/
		exit_code=$?
		if [ "$exit_code" -ne '0' ]
		then
			echo "failed to sync files for server: $server_address, server_group: $server_group, script exit"
			exit 2
		else
			echo "sync file success for server: $server_address, server_group: $server_group"
		fi
	done
done

