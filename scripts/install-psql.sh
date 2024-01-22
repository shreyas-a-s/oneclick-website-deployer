#!/bin/bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - POSTGRESQL DATABASE"
fi

# Install postgresql
if command -v apt-get > /dev/null; then
  sudo apt-get install -y postgresql
fi

# Create a postgresql user
sudo -u postgres createuser "$psqluser"

# Create database
sudo -u postgres createdb "$psqldb"

# Set new password to newly created user
sudo -u postgres psql -c "alter user \"$psqluser\" with encrypted password '$PGPASSWORD';"

# Set ownership of database to newly created user
sudo -u postgres psql -c "grant all privileges on database \"$psqldb\" to \"$psqluser\" ;"

