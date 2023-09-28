#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo '--------------------------------'
echo '   Tripal_JBrowse Installation   '
echo '--------------------------------'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Install system pre-requisites
sudo apt update && sudo apt install build-essential zlib1g-dev unzip -y

# Download and setup jbrowse
curl -L -O https://github.com/GMOD/jbrowse/releases/download/1.16.11-release/JBrowse-1.16.11.zip
unzip JBrowse-1.16.11.zip
rm JBrowse-1.16.11.zip
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/
sudo mv JBrowse-1.16.11 "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse
./setup.sh

# Test out the install
echo "To check if the installation succeeded, go to http://localhost/""$drupalsitedir""/jbrowse/"