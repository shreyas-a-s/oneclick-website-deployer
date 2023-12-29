#!/bin/bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - POSTGRESQL DATABASE"
fi

# Install dependencies
if command -v apt-get > /dev/null; then
  sudo apt-get install -y postgresql
fi

# Setup postgreSQL
sudo -u postgres createuser "$psqluser" # Create a user
sudo -u postgres createdb "$psqldb"     # Create a database
sudo -u postgres psql -c "alter user \"$psqluser\" with encrypted password '$PGPASSWORD';" # Set new password to the user
sudo -u postgres psql -c "grant all privileges on database $psqldb to \"$psqluser\" ;"     # Set ownership of database to the user

# Create pg_trgm extension that is a dependency of Drupal
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"

