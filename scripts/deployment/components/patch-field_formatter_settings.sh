#!/usr/bin/env bash

# Store script's directory path into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Fix for "Trying to access array offset on value of type null" error that gets displayed
# when we refresh overlay menus (eg: localhost/drupal/bio_data/1#overlay-context=&overlay=admin/tripal)
# source: https://www.drupal.org/project/field_formatter_settings/issues/3166628
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/modules/field_formatter_settings || exit
patch -p1 < $SCRIPT_DIR/field_formatter_settings.patch

