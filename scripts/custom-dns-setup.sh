#!/bin/bash

# Display task name
echo '---------------------'
echo '   Custom_DNS Setup   '
echo '---------------------'

# Install dependencies
sudo apt-get -qq update && sudo apt-get -qq install openresolv

# Setup
sudo sed -i '1,$d' /etc/resolv.conf && echo -e '# Custom DNS added by user\nnameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4' | sudo tee /etc/resolv.conf > /dev/null
sudo sed -i "/resolvconf=/ c\resolvconf=NO" /etc/resolvconf.conf || sudo sed -i "$ a/ \n# Added by user\nresolvconf=NO" /etc/resolvconf.conf

# Check DNS Server
if [ $(nslookup example.com | awk 'NR==1{print $2}') = '1.1.1.1' ]; then
  echo "Custom DNS setup Successful."
else
  echo "Custom DNS setup Unsuccessful. Reboot the system and check."
fi
