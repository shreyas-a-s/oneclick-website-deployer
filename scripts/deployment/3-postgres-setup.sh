#!/bin/bash

# Display task name
echo -e '\n+--------------------------------+'
echo '|   Postgres Database Creation   |'
echo '+--------------------------------+'

# Install postgreSQL
if command -v apt-get > /dev/null; then # Install for debian-based linux distros
	sudo apt-get -y install postgresql
fi

# Taking user-choice if not taken already
if [[ -z ${psqldb} ]]; then
	read -r -p "Enter the name for a new database for our website: " psqldb
	read -r -p "Enter a new username (role) for postgres: " psqluser
	read -r -p "Enter a password for the new user: " PGPASSWORD
	export PGPASSWORD
fi

# Create database
sudo -u postgres createuser "$psqluser"
sudo -u postgres createdb "$psqldb"
sudo -u postgres psql -c "alter user $psqluser with encrypted password '$PGPASSWORD';"
sudo -u postgres psql -c "grant all privileges on database $psqldb to $psqluser ;"

# Create pg_trgm extension that is a dependency of Drupal
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"

