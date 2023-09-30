#!/bin/bash

./scripts/1-base-setup.sh
./scripts/2-drush-install.sh
./scripts/3-postgres-setup.sh
./scripts/4-drupal-install.sh
./scripts/5-cron-automation.sh
./scripts/6-daemon-install.sh
./scripts/7-tripal-install.sh
./scripts/8-blast-install.sh
./scripts/9-jbrowse-install.sh
