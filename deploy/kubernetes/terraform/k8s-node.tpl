#!/bin/bash

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo echo "deb http://apt.kubernetes.io/ kubernetes-jammy main" | sudo tee --append /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y docker.io
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni
sudo sysctl -w vm.max_map_count=262144