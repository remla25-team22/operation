#!/bin/bash
# chmod +x cleanup.sh

echo "Halting any running Vagrant VMs..."
vagrant halt

echo "Destroying all Vagrant VMs..."
vagrant destroy -f

 echo "Removing Vagrant box: bento/ubuntu-24.04 (if it exists)..."
 vagrant box remove bento/ubuntu-24.04 --force

echo "Removing local .vagrant metadata directory..."
rm -rf .vagrant

echo "Cleanup complete!"
