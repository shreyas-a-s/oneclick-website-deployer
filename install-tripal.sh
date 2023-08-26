#!/bin/sh
# username=$(id -u -n 1000)
sudo apt update && sudo apt upgrade
sed -i '$a\DRUPAL_HOME=/var/www/html' "$HOME"/.bashrc && DRUPAL_HOME=/var/www/html
sudo apt install apache2
cd /etc/apache2/mods-enabled || exit
sudo ln -s ../mods-available/rewrite.load
sudo sed -i '$i<Directory /var/www/html>\n   Options Indexes FollowSymLinks MultiViews\n   AllowOverride All\n   Order allow,deny\n   allow from all\n</Directory>' /etc/apache2/sites-available/000-default.conf >> /dev/null
sudo service apache2 restart
sudo apt install php php-dev php-cli libapache2-mod-php php8.2-mbstring
sudo apt install php-pgsql php-gd php-xml php-curl php-apcu php-uploadprogress
sudo sed -i "/memory_limit/ c\memory_limit = 2048M" /etc/php/8.2/apache2/php.ini
sudo service apache2 restart
sudo apt install postgresql
sudo apt install phppgadmin
sudo apt install composer
cd $DRUPAL_HOME
sudo chown -R $USER $DRUPAL_HOME
composer require drush/drush
sed -i '$a\PATH=$PATH:/var/www/html/vendor/bin' "$HOME"/.bashrc && PATH=$PATH:/var/www/html/vendor/bin
composer require drupal/core
drush init
sudo su - postgres
createuser -P drupal
createdb drupal -O drupal
exit
# wget https://www.drupal.org/download-latest/tar.gz -O drupal-latest.tar.gz
# tar -zxvf drupal-latest.tar.gz
# mv drupal-*/* ./
# mv drupal-*/.htaccess ./
# mv index.html index.html.orig
# cd $DRUPAL_HOME/sites/default/
# cp default.settings.php settings.php
sudo chown www-data:www-data $DRUPAL_HOME/sites/default/settings.php
sudo chown www-data:www-data $DRUPAL_HOME/sites/default/
# $databases['default']['default'] = array(
#   'driver' => 'pgsql',
#   'database' => 'drupal',
#   'username' => 'drupal',
#   'password' => '********',
#   'host' => 'localhost',
#   'prefix' => '',
# );
psql -U drupal -d drupal -h localhost
CREATE EXTENSION pg_trgm;
exit
mkdir -p $DRUPAL_HOME/sites/default/files
# sudo chgrp www-data $DRUPAL_HOME/sites/default/files
# sudo chmod g+rw $DRUPAL_HOME/sites/default/files
#http://localhost/install.php
# composer require drupal/entity
# composer require drupal/tripal
# drush en entity
# drush en tripal
# drush en tripal_chado
