#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "INSTALLING - TRIPAL JBROWSE"
fi

# Install tripal_jbrowse
wget https://github.com/tripal/tripal_jbrowse/archive/refs/tags/7.x-3.0.zip
unzip -q 7.x-3.0.zip
rm 7.x-3.0.zip
mv tripal_jbrowse-7.x-3.0 "$WEB_ROOT"/"$DRUPAL_HOME"/sites/all/modules/tripal_jbrowse
drush pm-enable -y tripal_jbrowse_mgmt tripal_jbrowse_page --root="$WEB_ROOT"/"$DRUPAL_HOME"

# Setup tripal_jbrowse
drush variable-set tripal_jbrowse_mgmt_settings "{\"data_dir\":\"$WEB_ROOT/$DRUPAL_HOME/sites/default/files/jbrowse/data\",\"data_path\":\"$DRUPAL_HOME/sites/default/files/jbrowse/data\",\"bin_path\":\"$WEB_ROOT\/$DRUPAL_HOME/tools/jbrowse/bin\",\"link\":\"tools/jbrowse\",\"menu_template\":[]}" --root="$WEB_ROOT"/"$DRUPAL_HOME"

