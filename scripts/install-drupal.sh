#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - DRUPAL"
fi

# Install dependencies
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar # Install Drush (command-line shell interface for Drupal)
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush
if command -v apt-get > /dev/null; then # Install other dependencies for debian-based distros
  sudo apt-get install -y curl tar wget
fi

# Install Drupal
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
drush dl drupal --drupal-project-rename="$drupalsitedir"

# Setup Drupal
cd "$drupalsitedir" || exit
cp sites/default/default.settings.php sites/default/settings.php
mkdir sites/default/files/
sudo chgrp -R www-data sites/default/files/
sudo chmod g+rw sites/default/files/

drush site-install standard --db-url=pgsql://"$psqluser":"$PGPASSWORD"@localhost:5432/"$psqldb" --account-mail="$drupal_mail" --account-name="$drupal_user" --account-pass="$drupal_pass" --site-mail="$drupal_mail" --site-name="$drupal_site_name" install_configure_form.site_default_country="$drupal_country" -y

# Set temp-path for drupal to prevent issues in future
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
sudo chgrp www-data "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
chmod g+w "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
drush variable-set file_temporary_path "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp --root="$DRUPAL_HOME"/"$drupalsitedir"

# Prompt user to login to Drupal
whiptail --title "DRUPAL SETUP" --msgbox \
  --ok-button "OK" \
  --notags \
  "Drupal is installed and setup.\
  \n\n1. Now you can go to http://localhost/""$drupalsitedir"" and test out your site by logging in with your drupal username and password.\
  \n2. Press ENTER to continue." 13 56

