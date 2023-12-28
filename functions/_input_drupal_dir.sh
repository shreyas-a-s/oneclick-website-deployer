#!/usr/bin/env bash

function _input_drupal_dir {
  drupalsitedir=$(whiptail --title "User Input" --inputbox "\nEnter the name of the directory to which drupal website needs to be installed: " 10 45 "$drupalsitedir" 3>&1 1>&2 2>&3)
  export drupalsitedir
}

export -f _input_drupal_dir
