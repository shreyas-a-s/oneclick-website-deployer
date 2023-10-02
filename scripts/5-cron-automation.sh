#!/bin/bash

# Display task name
echo -e '\n+---------------------------+'
echo '|   Cron Automation Setup   |'
echo '+---------------------------+'

# Get user input
read -r -p "Enter the name of the directory in which drupal website was installed: " drupalsitedir

# Installation
echo "1. Go to http://localhost/""$drupalsitedir""/admin/config/system/cron"
echo "2. Set the drop down value titled 'Run cron every' to 'Never' and save the configuration."
echo "3. Also, on that page is the URL for cron."
echo "- Example URL: http://localhost/cron.php?cron_key=pnwI1cni8wjX1tVPOBaAJmoGOrzDsFQCW_7pwVHhigE"
echo "4. Execute sudo crontab -e from a terminal."
echo "5. Choose option [1] /bin/nano"
echo "6. Add this line as last line: 0,30 * * * * /usr/bin/wget -O - -q http://localhost/cron.php?cron_key=pnwI1cni8wjX1tVPOBaAJmoGOrzDsFQCW_7pwVHhigE"
echo "7. Ctrl + O"
echo "8. Enter"
echo "9. Ctrl + X"
