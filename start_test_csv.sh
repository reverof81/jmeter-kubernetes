#!/usr/bin/env bash

working_dir=$(pwd)

# Get namespace variable
namespace=$(awk '{print $NF}' "${working_dir}/namespace")

jmx_dir=$1
jmx_file=$2

if [ ! -d "${jmx_dir}" ]; then
  echo "Test script dir was not found"
  echo "Kindly check and input the correct file path"
  exit
fi

if [ ! -f "${jmx_dir}/${jmx_file}" ]; then
  echo "Test script file was not found"
  echo "Kindly check and input the correct file path"
  exit
fi

# Get Master pod details

printf "Copy %s to master\n" "${jmx_dir}/${jmx_file}"

master_pod=$(kubectl get po -n "${namespace}" | grep jmeter-master | awk '{print $1}')

printf "Master pod name: [%s]\n" "${master_pod}"

kubectl cp "${jmx_dir}/${jmx_file}" -n "${namespace}" "${master_pod}:/tmp/${jmx_file}"

# Get slaves

printf "Get number of slaves\n"

slave_pods=($(kubectl get po -n "$namespace" | grep jmeter-slave | awk '{print $1}'))

# for array iteration
number_of_slaves_str=${#slave_pods[@]}

echo $number_of_slaves_str

# for split command suffix and seq generator
number_of_slaves="${#number_of_slaves_str}"

printf "Number of slaves is [%s]\n" "${number_of_slaves_str}"

# Split and upload tsv files

for tsv_file_full in "${jmx_dir}"/*.tsv; do
  tsv_file="${tsv_file_full##*/}"

  j=0
  for i in $(seq -f "%0${number_of_slaves}g" 0 $((number_of_slaves_str - 1))); do
    printf "Copy %s on %s\n" "${tsv_file}" "${slave_pods[j]}"
    kubectl -n "${namespace}" cp "${jmx_dir}/${tsv_file}" "${slave_pods[j]}":/tmp/

    let j=j+1
  done # for i in "${slave_pods[@]}"

done # for tsv_file in "${jmx_dir}/*.tsv"

## Echo Starting Jmeter load test

kubectl exec -it -n "${namespace}" "${master_pod}" -- /bin/bash /load_test "/tmp/${jmx_file}"
