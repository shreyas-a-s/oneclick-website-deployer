#!/usr/bin/env bash

# Create cvitjs directory if does not exist
if [ ! -d "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs ]; then
  mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs
fi

# Change to cvitjs directory
cd "$DRUPAL_HOME"/"$drupalsitedir"/sites/all/libraries/cvitjs || exit

# Install dependencies
if command -v apt-get > /dev/null; then
  sudo apt-get install -y wget unzip
fi

# Install cvitjs library
wget https://github.com/awilkey/cvitjs/archive/master.zip
unzip -q master.zip
mv cvitjs-master/* ./
rm -r cvitjs-master master.zip

