#!/bin/bash

# Install git if not present
sudo apt-get update
sudo apt-get -y install git

# Create a temporary directory
temp_dir=$(mktemp -d)

# Clone the GitHub repository into the temporary directory
git clone -b 3 https://github.com/shreyas-a-s/website-tripal.git "$temp_dir"

# Change directory to the temporary folder
cd "$temp_dir" || exit

# Run the install.sh script
./install.sh

# Clean up: Remove the temporary directory and its contents
cd .. || exit
rm -rf "$temp_dir"
