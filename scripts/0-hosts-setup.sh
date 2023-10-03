#!/bin/bash

# Display task name
echo -e '\n+-----------------+'
echo '|   Hosts Setup   |'
echo '+-----------------+'

# Setup
echo "185.199.108.133 raw.githubusercontent.com" | sudo tee -a /etc/hosts