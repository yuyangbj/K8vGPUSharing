#!/bin/bash -e

unset GOVC_URL
unset KUBECONFIG
export GOVC_INSECURE=1
export GOVC_URL=10.110.165.233
export GOVC_USERNAME=root
export GOVC_PASSWORD=demo
export KUBECONFIG=/tmp/admin.conf

echo -n "Listing kubernetes cluster setup:\n"
echo -n "kubectl get nodes\n"
kubectl --kubeconfig=/tmp/admin.conf get nodes
echo "\n"

echo -n "Listing kubernetes worker nodes with specified vGPU type:\n"
worker=$(kubectl --kubeconfig=/tmp/admin.conf get nodes -l "virtual.gpu.type=$1" -o name)
echo -n $worker
echo "\n"

echo -n "Suspending the worker node with vGPU profile $1:\n"
for i in $worker
do
    vmname=$(echo $i | awk -F '/' '{print $2}')
    govc vm.power -off /ha-datacenter/vm/$vmname &
    echo "\n"
done
echo "\n"

echo -n "Waiting to show kubernetes cluster setup:\n"
echo -n "kubectl get nodes\n"
sleep 60
kubectl get nodes
