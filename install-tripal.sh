#!/bin/bash
####################################################################
# This works only on the latest debian (currently it's version 12) #
####################################################################
# (not needed anymore) username=$(id -u -n 1000)
sudo apt update && sudo apt upgrade
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html
sudo apt install apache2 -y
cd /etc/apache2/mods-enabled && sudo ln -s ../mods-available/rewrite.load
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf
sudo service apache2 restart
sudo apt install php php-dev php-cli libapache2-mod-php php8.2-mbstring -y
sudo apt install php-pgsql php-gd php-xml php-curl php-apcu php-uploadprogress -y
sudo sed -i "/memory_limit/ c\memory_limit = 2048M" /etc/php/8.2/apache2/php.ini
sudo service apache2 restart
sudo apt install postgresql phppgadmin composer -y
sudo su - postgres
# The below commands create a database user and a database for our website.
# These needs to be manually entered.
# createuser -P drupal
# createdb drupal -O drupal
# exit
cd $DRUPAL_HOME
sudo chown -R $USER $DRUPAL_HOME
composer create-project drupal/recommended-project:10.0.10 drupalwebsite # replace drupalwebsite with the name for your website
cd drupalwebsite
composer require drush/drush
composer require drupal/core
sed -i '$a\PATH=$PATH:./vendor/bin' "$HOME"/.bashrc && PATH=$PATH:./vendor/bin
cp ./web/sites/default/default.settings.php ./web/sites/default/settings.php
sudo chown www-data:www-data ./web/sites/default/settings.php
sudo chown www-data:www-data ./web/sites/default/
psql -U drupal -d drupal -h localhost
# The below commands create a database user and a database for our website.
# These needs to be manually entered.
# CREATE EXTENSION pg_trgm;
# exit
# (not needed anymore) sudo chgrp www-data $DRUPAL_HOME/sites/default/files
# (not needed anymore) sudo chmod g+rw $DRUPAL_HOME/sites/default/files
echo ""
echo "Go to http://localhost/drupalwebsite/web/install.php and complete initial setup of website by providing necessary database details and email address."
echo "After completing initial setup, come back and press any key to continue."
read -s -n 1
composer require drupal/entity
composer require drupal/ctools
composer require drupal/ds
composer require drupal/field_group
composer require drupal/field_group_table
composer require drupal/field_formatter_class
drush pm-enable entity views views_ui ctools ds field_group field_group_table field_formatter_class
git clone -b 4.x https://github.com/tripal/tripal.git ./web/modules/contrib/tripal
drush pm-enable tripal tripal_chado
## Chado Installation
echo "Go to http://localhost/drupalwebsite/web/ > Tripal > Data Storage > Chado > Install Chado. Then click on Install Chado 1.3 and follow the on-screen instructions to create a job to install chado."
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing on-screen instructions, come back and press any key to continue."
read -s -n 1
drush trp-run-jobs --username=admin # replace admin with Administrator username that you've set during initial setup of website
## Chado Preparation
echo "Go to http://localhost/drupalwebsite/web/ > Tripal > Data Storage > Chado > Prepare Chado. Then click on Prepare this site and follow the on-screen instructions to create a job to install chado."
echo "NOTE: THERE IS NO NEED TO RUN THE DRUSH COMMAND."
echo "After completing on-screen instructions, come back and press any key to continue."
read -s -n 1
drush trp-run-jobs --username=admin # replace admin with Administrator username that you've set during initial setup of website
echo "Installation completed. Press any key to exit."
read -s -n 1
