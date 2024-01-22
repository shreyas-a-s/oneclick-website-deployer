#!/usr/bin/env bash

# Display title of script
if type _printtitle &> /dev/null; then
  _printtitle "SETTING UP - CRON"
fi

# Disable drupal cron to prevent website slowing down when users visit
drush vset cron_safe_threshold 0 --root="$DRUPAL_HOME"/"$drupalsitedir"

# Store exit status to variable
exitstatus=$?

# Display result of operation
if [ $exitstatus = 0 ]; then
  # Set up system cronjob to do drupal tasks
  echo "0,30 * * * * /usr/bin/wget -O - -q http://localhost/""$drupalsitedir""/cron.php?cron_key=""$drupal_cron_key" | sudo tee /etc/cron.d/drupal-cron-tasks > /dev/null
  echo "Cron setup Successfull"
else
  echo "Cron setup Unsuccessful"
fi

# Wait two seconds to allow user to read displayed message
sleep 2

