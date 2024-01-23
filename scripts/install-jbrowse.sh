#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - JBROWSE"
fi

# Install dependencies
if command -v apt-get > /dev/null; then # Install for debian-based distros
  sudo apt-get -y install build-essential curl unzip wget zlib1g-dev
fi

# Prepare environment
cd "$WEB_ROOT"/"$DRUPAL_HOME" || exit
[ -d ./tools ] || mkdir tools/
mkdir -p sites/default/files/jbrowse/data/
sudo chgrp -R www-data sites/default/files/jbrowse/
sudo chmod -R g+w sites/default/files/jbrowse

# Install jbrowse
curl -L -O https://github.com/GMOD/jbrowse/releases/download/1.16.11-release/JBrowse-1.16.11.zip
unzip -q JBrowse-1.16.11.zip
rm JBrowse-1.16.11.zip
mv JBrowse-1.16.11 tools/jbrowse
cd tools/jbrowse/ || exit
./setup.sh

# User intervention
whiptail --title "JBROWSE EXAMPLE DATA (VOLVOX)" --msgbox \
  --ok-button "OK" \
  --notags \
  "To see JBrowse example data, go to http://localhost/""$DRUPAL_HOME""/tools/jbrowse/index.html?data=sample_data/json/volvox\
  \nPress ENTER to continue." \
  9 86

