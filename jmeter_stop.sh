#!/usr/bin/env bash
#Script writtent to stop a running jmeter master test
#Kindly ensure you have the necessary kubeconfig

working_dir=$(pwd)

#Get namespace variable
namespace=$(awk '{print $NF}' "$working_dir/namespace")

master_pod=$(kubectl get po -n $namespace | grep jmeter-master | awk '{print $1}')

kubectl exec -n $namespace -it $master_pod bash /opt/jmeter/bin/stoptest.sh
