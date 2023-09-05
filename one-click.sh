#!/bin/bash

# Install git if not present
sudo apt update
sudo apt install git -y

# Create a temporary directory
temp_dir=$(mktemp -d)

# Clone the GitHub repository into the temporary directory
git clone https://github.com/shreyas-a-s/website-tripal.git "$temp_dir"

# Change directory to the temporary folder
cd "$temp_dir"

# Run the install-tripal.sh script
./install-tripal.sh

# Clean up: Remove the temporary directory and its contents
cd ..
rm -rf "$temp_dir"
