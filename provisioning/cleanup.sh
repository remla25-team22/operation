#!/bin/bash
# chmod +x cleanup.sh

echo "Halting any running Vagrant VMs..."
vagrant halt

echo "Destroying all Vagrant VMs..."
vagrant destroy -f


echo "Removing local .vagrant metadata directory..."
rm -rf .vagrant

echo "Cleanup complete!"
