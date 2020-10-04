#!/usr/bin/env bash

working_dir=$(pwd)
namespace=$(awk '{print $NF}' "${working_dir}/namespace")

echo "checking if kubectl is present"

if ! hash kubectl 2>/dev/null; then
  echo "'kubectl' was not found in PATH"
  echo "Kindly ensure that you can acces an existing kubernetes cluster via kubectl"
  exit
fi

kubectl version --short

echo "Creating Jmeter slave nodes"

nodes=$(kubectl get no | egrep -v "master|NAME" | wc -l)

echo

echo "Number of worker nodes on this cluster is " $nodes

echo

echo "Creating $nodes Jmeter slave replicas and service"

echo

kubectl apply -n ${namespace} -f ${working_dir}/jmeter_slaves_deploy.yaml
kubectl apply -n ${namespace} -f ${working_dir}/jmeter_slaves_svc.ml

echo "Creating Jmeter Master"

kubectl apply -n ${namespace} -f ${working_dir}/jmeter_master_configmap.yaml
kubectl apply -n ${namespace} -f ${working_dir}/jmeter_master_deploy.yaml

echo "Printout Of the ${namespace} Objects"
