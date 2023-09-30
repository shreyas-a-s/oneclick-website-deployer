#!/bin/bash

# Display task name
echo '--------------------------'
echo '   Cron Automation Setup   '
echo '--------------------------'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Installation
echo "Go to http://localhost/""$drupalsitedir""/admin/config/system/cron"
echo "Set the drop down value titled 'Run cron every' to 'Never' and save the configuration."
echo "Also, on that page is the URL for cron."
echo "Example URL: http://localhost/cron.php?cron_key=pnwI1cni8wjX1tVPOBaAJmoGOrzDsFQCW_7pwVHhigE"
echo "Execute sudo crontab -e from a terminal."
echo "Choose option [1] /bin/nano"
echo "Add this line as last line: 0,30 * * * * /usr/bin/wget -O - -q http://localhost/cron.php?cron_key=pnwI1cni8wjX1tVPOBaAJmoGOrzDsFQCW_7pwVHhigE"
echo "Ctrl + O"
echo "Enter"
echo "Ctrl + X"
