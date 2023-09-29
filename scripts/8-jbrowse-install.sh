#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html

# Display task name
echo '--------------------------------'
echo '   Tripal_JBrowse Installation   '
echo '--------------------------------'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Install pre-requisites
sudo apt update && sudo apt install build-essential zlib1g-dev unzip wget curl -y

# Install jbrowse
curl -L -O https://github.com/GMOD/jbrowse/releases/download/1.16.11-release/JBrowse-1.16.11.zip
unzip JBrowse-1.16.11.zip
rm JBrowse-1.16.11.zip
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/
mv JBrowse-1.16.11 "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse || exit
./setup.sh

# Install tripal_jbrowse
wget https://github.com/tripal/tripal_jbrowse/archive/refs/tags/7.x-3.0.zip
unzip tripal_jbrowse-7.x-3.0.zip
rm tripal_jbrowse-7.x-3.0.zip
mv tripal_jbrowse-7.x-3.0 "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse/data/
sudo chown -R www-data:www-data "$DRUPAL_HOME"/"$drupalsitedir"/tools/jbrowse/data/
drush en tripal_jbrowse_mgmt -y