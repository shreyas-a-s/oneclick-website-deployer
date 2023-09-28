#!/bin/bash

# Install git if not present
sudo apt update
sudo apt install git -y

# Create a temporary directory
temp_dir=$(mktemp -d)

# Clone the GitHub repository into the temporary directory
git clone -b dev-3 https://github.com/shreyas-a-s/website-tripal.git "$temp_dir"

# Change directory to the temporary folder
cd "$temp_dir" || exit

# Run the install.sh script
./scripts/base-setup.sh
./scripts/drush-install.sh
./scripts/postgres-setup.sh
./scripts/drupal-install.sh
./scripts/tripal-install.sh
./scripts/blast-install.sh
./scripts/daemon-install.sh

# Clean up: Remove the temporary directory and its contents
cd .. || exit
rm -rf "$temp_dir"
