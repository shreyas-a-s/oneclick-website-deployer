#!/usr/bin/env bash

# Display task name
printf '+-------------------------+
|   Drupal Installation   |
+-------------------------+\n'

# Install dependencies
wget https://github.com/drush-ops/drush/releases/download/8.4.12/drush.phar # Install Drush (command-line shell interface for Drupal)
chmod +x drush.phar
sudo mv drush.phar /usr/local/bin/drush
if command -v apt-get > /dev/null; then # Install other dependencies for debian-based distros
  sudo apt-get install -y wget tar
fi

# Store latest drupal seven version to a variable
latest_drupal_seven_version=$(curl https://www.drupal.org/project/drupal/releases -s | grep '7\.[0-9][0-9]' | awk -F 'releases/' 'NR==1{print $2}' | awk -F '"' '{print $1}')

# Install Drupal
sudo chown -R "$USER" "$DRUPAL_HOME"
cd "$DRUPAL_HOME" || exit
mv index.html index.html.orig
wget http://ftp.drupal.org/files/projects/drupal-"$latest_drupal_seven_version".tar.gz
tar -zxf drupal-"$latest_drupal_seven_version".tar.gz
rm drupal-"$latest_drupal_seven_version".tar.gz
mv drupal-"$latest_drupal_seven_version"/ "$drupalsitedir"/

# Setup Drupal
cd "$drupalsitedir" || exit
cp sites/default/default.settings.php sites/default/settings.php
mkdir sites/default/files/
sudo chgrp -R www-data sites/default/files/
sudo chmod 777 sites/default/settings.php
sudo chmod g+rw sites/default/files/

# Write database credentials to Drupal settings file
sed -i "s/\$databases\ =\ array();/\n\$databases['default']['default']\ =\ array(\n\t'driver'\ =>\ 'pgsql',\n\t'database'\ =>\ '$psqldb',\n\t'username'\ =>\ '$psqluser',\n\t'password'\ =>\ '$ESCAPED_PGPASSWORD',\n\t'host'\ =>\ 'localhost',\n\t'prefix'\ =>\ '',\n);/" sites/default/settings.php

# Manual Setup of Drupal
echo -e '\n+----------------+'
echo '|   Site Setup   |'
echo '+----------------+'
while ! ({ drush variable-get --root="$DRUPAL_HOME"/"$drupalsitedir" | grep -q drupal; } &> /dev/null); do
  whiptail --title "Drupal Setup" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/install.php\n2. Ensure that 'Standard' option is selected and click 'Save and continue'\n3. Select the language you want to choose. Choose 'English'.\n4. You will see a progress bar as Drupal is installed.\n5. Once it completes, a configuration page will be visible.\n6. Provide details appropriate to your site and note down the Site Maintenance Account details.\n7. Click 'Save and continue.'\n8. Hit 'OK' after completing these steps." 15 78;
done

# Limit write permission to owner of 'settings.php' for security reasons
sudo chmod 755 sites/default/settings.php

# Set temp-path for drupal to prevent issues in future
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
sudo chgrp www-data "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
chmod g+w "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp/
drush variable-set file_temporary_path "$DRUPAL_HOME"/"$drupalsitedir"/sites/default/files/tmp --root="$DRUPAL_HOME"/"$drupalsitedir"

