#!/bin/bash -x

num=$1

openstack baremetal node list
sudo virsh list --all
oc get baremetalhosts

openstack baremetal node maintenance set "uccp-worker-${num}"
openstack baremetal node delete "uccp-worker-${num}"
sudo virsh shutdown "openshift_worker_${num}"
oc delete baremetalhost "uccp-worker-${num}"
