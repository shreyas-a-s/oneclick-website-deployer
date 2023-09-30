#!/bin/bash

# Install git if not present
sudo apt-get update
sudo apt-get -y install git

# Create a temporary directory
temp_dir=$(mktemp -d)

# Clone the GitHub repository into the temporary directory
git clone -b dev-3 https://github.com/shreyas-a-s/website-tripal.git "$temp_dir"

# Change directory to the temporary folder
cd "$temp_dir" || exit

# Run the install.sh script
./scripts/1-base-setup.sh
./scripts/2-drush-install.sh
./scripts/3-postgres-setup.sh
./scripts/4-drupal-install.sh
./scripts/5-tripal-install.sh
./scripts/6-blast-install.sh
./scripts/7-daemon-install.sh
./scripts/8-jbrowse-install.sh

# Clean up: Remove the temporary directory and its contents
cd .. || exit
rm -rf "$temp_dir"
