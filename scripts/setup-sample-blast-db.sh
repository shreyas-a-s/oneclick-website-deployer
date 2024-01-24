#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "SETTING UP - SAMPLE BLAST DATABASE"
fi

# Store current directory into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Change directory
cd "$WEB_ROOT"/"$DRUPAL_HOME" || exit

# Gathering test database
mkdir -p tools/blast/db/16S_ribosomal_RNA
cp "$SCRIPT_DIR"/../components/blastdb/16S_ribosomal_RNA/* tools/blast/db/16S_ribosomal_RNA/

# Automatic blast db setup
drush php-script "$SCRIPT_DIR"/create-blastdb.php --root="$WEB_ROOT"/"$DRUPAL_HOME"

# Store exit status in a variable
exitstatus=$?

# User Intervention
if [ $exitstatus = 0 ]; then
  printf "Sample Blast Database Setup successful\n"
  sleep 2
  whiptail --title "SAMPLE BLAST DB SETUP" --msgbox \
    --ok-button "OK" \
    --notags \
    "Sample Blast Database is set.\
    \n\n1. Now you can go to http://localhost/""$DRUPAL_HOME""/blast/nucleotide/nucleotide and test out blast by Entering a FASTA sequence (or uploading one) & Selecting the newly added database (16S_ribosomal_RNA) from dropdown under Nucleotide BLAST Databases & Clicking 'BLAST'\
    \n2. Press ENTER to continue." 15 60
else
  printf "\n\nSorry! Sample Blast Database setup failed for some reason.\n"
fi

