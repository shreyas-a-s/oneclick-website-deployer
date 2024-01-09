#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "SETTING UP - SAMPLE BLAST DATABASE"
fi

# Store path to directory in which this script resides into a variable
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )")

# Gathering test database
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/db/16S_ribosomal_RNA
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/db/16S_ribosomal_RNA || exit
echo "Downloading Sample Blat database from NCBI. Please be patient..."
"$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/bin/update_blastdb.pl --passive --decompress 16S_ribosomal_RNA

# Check if Sample data was downloaded
if [ ! -f "$DRUPAL_HOME/$drupalsitedir/tools/blast/db/16S_ribosomal_RNA/16S_ribosomal_RNA.ndb" ]; then
  echo "\nSample data could not be downloaded. Hence aborting Blast Database setup."
  sleep 3
  exit # Don't setup if Sample data was not downloaded
fi

# Automatic blast db setup
drush php-script "$SCRIPT_DIR"/create-blastdb.php --root="$DRUPAL_HOME"/"$drupalsitedir"
exitstatus=$?

# User Intervention
if [ $exitstatus = 0 ]; then
  whiptail --title "SAMPLE BLAST DB SETUP" --msgbox \
    --ok-button "OK" \
    --notags \
    "Sample Blast Database is set.\
    \n\n1. Now you can go to http://localhost/""$drupalsitedir""/blast/nucleotide/nucleotide and test out blast by Entering a FASTA sequence (or uploading one) & Selecting the newly added database (16S_ribosomal_RNA) from dropdown under Nucleotide BLAST Databases & Clicking 'BLAST'\
    \n2. Press ENTER to continue." 15 60
else
  printf "\n\nSorry! Sample Blast Database setup failed for some reason.\n"
fi

