#!/usr/bin/env bash

# Create cvitjs directory if does not exist
if ! [ -d "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs ]; then
  mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs
fi

# Change to cvitjs directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs || exit

# Install cvitjs library
wget https://github.com/awilkey/cvitjs/archive/master.zip
unzip master.zip
mv cvitjs-master/* ./
rm -r cvitjs-master master.zip

