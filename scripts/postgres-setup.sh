#!/bin/bash

# Display task name
echo '-------------------------------'
echo '   Postgres Database Creation   '
echo '-------------------------------'

#Installation
sudo apt install postgresql -y

# Database creation
read -r -p "Enter a new username (role): " psqluser
read -r -p "Enter the name for a new database for our website: " psqldb
sudo su - postgres -c "createuser -P $psqluser"
sudo su - postgres -c "createdb $psqldb -O $psqluser"

# Creating pg_trgm extension that is a Drupal dependency
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"