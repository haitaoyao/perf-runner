#!/bin/bash
##################################################################
# 
# written by haitao.yao @ 2011-09-16.23:47:31
# 
# this is used to export the env for all the scripts
# 
##################################################################
current_dir="$(cd $(dirname $0);pwd)"
export PERF_RUNNER_HOME="$(cd $(dirname $0)/../;pwd)"
export PERF_RUNNER_DEPLOY_FOLDER=$PERF_RUNNER_HOME/deploy
