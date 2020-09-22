#!/usr/bin/env bash
#Create multiple Jmeter namespaces on an existing kuberntes cluster
#Started On January 23, 2018

working_dir=$(pwd)
namespace=$(awk '{print $NF}' "$working_dir/namespace")

echo "checking if kubectl is present"

if ! hash kubectl 2>/dev/null; then
  echo "'kubectl' was not found in PATH"
  echo "Kindly ensure that you can acces an existing kubernetes cluster via kubectl"
  exit
fi

kubectl version --short

echo "Current list of namespaces on the kubernetes cluster:"

echo

kubectl get namespaces | grep -v NAME | awk '{print $1}'

echo

#echo "Enter the name of the new namespace unique name, this will be used to create the namespace"
#read namespace
#echo

#Check If namespace exists

#kubectl get namespace $namespace > /dev/null 2>&1

#if [ $? -eq 0 ]
#then
#  echo "Namespace $namespace already exists, please select a unique name"
#  echo "Current list of namespaces on the kubernetes cluster"
#  sleep 2
#
# kubectl get namespaces | grep -v NAME | awk '{print $1}'
#  exit 1
#fi

echo
#echo "Creating Namespace: $namespace"

#kubectl create namespace $namespace

#echo "Namspace $namespace has been created"

echo

echo "Creating Jmeter slave nodes"

nodes=$(kubectl get no | egrep -v "master|NAME" | wc -l)

echo

echo "Number of worker nodes on this cluster is " $nodes

echo

#echo "Creating $nodes Jmeter slave replicas and service"

echo

kubectl create -n $namespace -f $working_dir/jmeter_slaves_deploy.yaml
kubectl create -n $namespace -f $working_dir/jmeter_slaves_svc.ml

echo "Creating Jmeter Master"

kubectl create -n $namespace -f $working_dir/jmeter_master_configmap.yaml
kubectl create -n $namespace -f $working_dir/jmeter_master_deploy.yaml

#echo "Creating Influxdb and the service"

#kubectl create -n $namespace -f $working_dir/jmeter_influxdb_configmap.yaml
#kubectl create -n $namespace -f $working_dir/jmeter_influxdb_deploy.yaml
#kubectl create -n $namespace -f $working_dir/jmeter_influxdb_svc.yaml

#echo "Creating Grafana Deployment"

#kubectl create -n $namespace -f $working_dir/jmeter_grafana_deploy.yaml
#kubectl create -n $namespace -f $working_dir/jmeter_grafana_svc.yaml

echo "Printout Of the $namespace Objects"

echo

kubectl get -n $namespace all

echo namespace = $namespace >$working_dir/namespace
