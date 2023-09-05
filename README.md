# Tripal Website
Bash script to install and setup a basic working tripal website.

# Features of the script
- Installs in sub directory in /var/www/html directory. This makes it easier to develop and manage different versions of the website.
- Installs latest version of drupal.
- Installs active development version (currently [4.x](https://github.com/tripal/tripal/tree/4.x)) of tripal.

# Prerequisites
- A basic install of debian 12.
- It is better if the installation is new with no extra modification.

# Usage
Execute the following commands one by one from a terminal:
```bash
sudo apt update && sudo apt install git -y
git clone https://github.com/shreyas-a-s/website-tripal.git
cd website-tripal/scripts/
./install.sh
```
OR use this single line command from a terminal:
```bash
sudo apt update && sudo apt install git -y && git clone https://github.com/shreyas-a-s/website-tripal.git && cd website-tripal/scripts/ && ./install.sh
```
OR just right click the one-click.sh file and click "Run as a Program and follow the prompts."
