#!/usr/bin/env bash

# Gathering test database
mkdir -p "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/db/16S_ribosomal_RNA
cd "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/db/16S_ribosomal_RNA || exit
echo -e '\n+------------------------------------------------+'
echo '|   Downloading sample data. Wait a little bit   |'
echo '+------------------------------------------------+'
update_blastdb --passive --decompress 16S_ribosomal_RNA

# User Intervention
echo -e '\n+---------------------------+'
echo '|   Sample Blast DB Setup   |'
echo '+---------------------------+'

# Check if Sample data was downloaded
if [ ! -f "$DRUPAL_HOME"/"$drupalsitedir"/tools/blast/db/16S_ribosomal_RNA/16S_ribosomal_RNA* ]; then
	echo "Sample data could not be downloaded. Hence aborting Blast Database setup."
	sleep 2
	exit # Don't setup if Sample data was not downloaded
fi

whiptail --title "Sample Blast DB Setup" --msgbox --ok-button "OK" --notags "1. Go to http://localhost/""$drupalsitedir""/node/add/blastdb\n2. Fill out the form like this:\n- Human-readable Name: 16S_ribosomal_RNA\n- File Prefix including Full Path: ""$DRUPAL_HOME""/""$drupalsitedir""/tools/blast/db/16S_ribosomal_RNA/16S_ribosomal_RNA\n- Set 'Type of the blast database' to Nucleotide.\n3. Got to bottom of page and click 'Save'\n4. After the installation is completed and system is rebooted, you can go to http://localhost/""$drupalsitedir""/blast/nucleotide/nucleotide and test out blast by Entering a FASTA sequence (or uploading one) & Selecting the newly added Database from dropdown under Nucleotide BLAST Databases & Clicking 'BLAST'\n5. Hit 'OK' after completing these steps." 18 78
echo "Setup complete."

