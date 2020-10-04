#!/usr/bin/env bash

working_dir=$(pwd)

#Get namespace variable
namespace=$(awk '{print $NF}' "${working_dir}/namespace")

master_pod=$(kubectl get po -n ${namespace} | grep jmeter-master | awk '{print $1}')

kubectl exec -n ${namespace} -it ${master_pod} -- /bin/bash /opt/jmeter/bin/stoptest.sh
