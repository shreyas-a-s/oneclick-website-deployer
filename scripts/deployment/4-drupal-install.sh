#!/bin/bash

# Variables
sed -i '$a\DRUPAL_HOME=/var/www/html' ~/.bashrc && DRUPAL_HOME=/var/www/html
latest_drupal_seven_version=$(curl https://www.drupal.org/project/drupal/releases -s | grep '7\.[0-9][0-9]' | awk -F 'releases/' 'NR==1{print $2}' | awk -F '"' '{print $1}')

# Display task name
printf '+-------------------------+
|   Drupal Installation   |
+-------------------------+\n'

# Get user input
if [[ -z ${drupalsitedir} ]]; then
  read -r -p "Enter the name of the directory in which drupal website need to be installed: " drupalsitedir
fi

# Read database credentials if not read already
if [[ -z ${psqldb} ]]; then
  . ./components/get-db-creds.sh
fi

# Escape special characters in PGPASSWORD using printf.
PGPASSWORD_ESCAPED=$(printf "%q" "$PGPASSWORD")

# Installation
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
wget http://ftp.drupal.org/files/projects/drupal-"$latest_drupal_seven_version".tar.gz
tar -zxvf drupal-"$latest_drupal_seven_version".tar.gz
rm drupal-"$latest_drupal_seven_version".tar.gz
mv drupal-"$latest_drupal_seven_version"/ "$drupalsitedir"/
cd "$drupalsitedir" || exit
cp sites/default/default.settings.php sites/default/settings.php
mkdir sites/default/files/
sudo chgrp -R www-data sites/default/files/
sudo chmod 777 sites/default/settings.php
sudo chmod g+rw sites/default/files/
echo -e '\n+----------------+'
echo '|   Site Setup   |'
echo '+----------------+'
sed -i "s/\$databases\ =\ array();/\n\$databases['default']['default']\ =\ array(\n\t'driver'\ =>\ 'pgsql',\n\t'database'\ =>\ '$psqldb',\n\t'username'\ =>\ '$psqluser',\n\t'password'\ =>\ '$PGPASSWORD_ESCAPED',\n\t'host'\ =>\ 'localhost',\n\t'prefix'\ =>\ '',\n);/" sites/default/settings.php
while ! ({ drush variable-get --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q drupal; } &> /dev/null); do
  whiptail --title "Drupal Setup" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/install.php\n2. Ensure that 'Standard' option is selected and click 'Save and continue'\n3. Select the language you want to choose. Choose 'English'.\n4. You will see a progress bar as Drupal is installed.\n5. Once it completes, a configuration page will be visible.\n6. Provide details appropriate to your site and note down the Site Maintenance Account details.\n7. Click 'Save and continue.'\n8. Hit 'OK' after completing these steps." 15 78;
done
sudo chmod 755 sites/default/settings.php

# Webform Module (for creating Google-form-like Forms)
drush pm-download -y webform
drush pm-enable -y webform
