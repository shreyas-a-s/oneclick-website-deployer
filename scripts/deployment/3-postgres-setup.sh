#!/bin/bash

# Display task name
echo -e '\n+----------------------------------+'
echo '|   PostgreSQL Database Creation   |'
echo '+----------------------------------+'

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Install postgresql if not already
if command -v psql > /dev/null; then
  ./components/install-psql.sh
fi

# Read database credentials if not read already
if [[ -z ${psqldb} ]]; then
  . ../pre-deployment/components/get-db-creds.sh
fi

# Create database
sudo -u postgres createuser "$psqluser"
sudo -u postgres createdb "$psqldb"
sudo -u postgres psql -c "alter user $psqluser with encrypted password '$PGPASSWORD';"
sudo -u postgres psql -c "grant all privileges on database $psqldb to $psqluser ;"

# Create pg_trgm extension that is a dependency of Drupal
psql -U "$psqluser" -d "$psqldb" -h localhost -c "CREATE EXTENSION pg_trgm;"

