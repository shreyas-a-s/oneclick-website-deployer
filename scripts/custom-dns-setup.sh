#!/bin/bash

# Display task name
echo '---------------------'
echo '   Custom_DNS Setup   '
echo '---------------------'

# Install dependencies
sudo apt update && sudo apt install openresolv -y

# Setup
sudo sed -i '1,$d' /etc/resolv.conf && echo -e '# Custom DNS added by user\nnameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4' | sudo tee /etc/resolv.conf > /dev/null
sudo sed -i "$ a/ \n# Added by user\nresolvconf=NO" /etc/resolvconf.conf

# End
echo "Reboot for the changes to take place."