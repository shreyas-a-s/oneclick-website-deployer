#!/bin/bash

# Install git if not present
sudo apt-get update
sudo apt-get -y install git

# Clone the GitHub repository into the temporary directory
git clone https://github.com/shreyas-a-s/website-tripal.git

# Change directory to the repository folder
cd website-tripal || exit

# Run the install.sh script
./install.sh

# Clean up: Remove the repository directory and its contents
cd .. || exit
rm -rf website-tripal

