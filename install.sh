#!/bin/bash

# Get user input
read -r -p "How much memory to allocate to the website (in MB)? " memorylimit && export memorylimit
read -r -p "Enter the name for a new database for our website: " psqldb && export psqldb
read -r -p "Enter a new username (role): " psqluser && export psqluser
sudo su - postgres -c "createuser -P $psqluser"
sudo su - postgres -c "createdb $psqldb -O $psqluser"
read -r -p "Enter the name of the directory to which drupal website needs to be installed: " drupalsitedir && export drupalsitedir

# Executing scripts
./scripts/1-base-setup.sh
./scripts/2-drush-install.sh
./scripts/3-postgres-setup.sh
./scripts/4-drupal-install.sh
./scripts/5-cron-automation.sh
./scripts/6-tripal-install.sh
./scripts/7-daemon-install.sh
./scripts/8-blast-install.sh
./scripts/9-jbrowse-install.sh
