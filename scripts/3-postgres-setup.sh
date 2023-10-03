#!/bin/bash

# Display task name
echo -e '\n+--------------------------------+'
echo '|   Postgres Database Creation   |'
echo '+--------------------------------+'

#Installation
sudo apt-get -y install postgresql

# Database creation
if [[ -z ${psqldb} ]]; then
	read -r -p "Enter the name for a new database for our website: " psqldb
	read -r -p "Enter a new username (role): " psqluser
	sudo su - postgres -c "createuser -P $psqluser"
	sudo su - postgres -c "createdb $psqldb -O $psqluser"
fi

# Creating pg_trgm extension that is a Drupal dependency
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"