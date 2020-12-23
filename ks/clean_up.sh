#!/bin/bash

services=$(kubectl get service | grep bot | tr -s ' ' | cut -d ' ' -f1)
deployments=$(kubectl get deployments | grep bot | tr -s ' ' | cut -d ' ' -f1)
echo "Cleaning up!"

for service in ${services[@]}
do
    kubectl delete service $service
done

for deployment in ${deployments[@]}
do
    kubectl delete deployment $deployment
done