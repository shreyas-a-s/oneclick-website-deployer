# One Click Website Deployer
Bash script to install and setup a basic working tripal website.

# Features of the script
- Installs in sub directory in /var/www/html directory. This makes it easier to develop and manage different versions of the website.
- Installs stable version 7 of drupal.
- Installs fully developed version (currently [7.x-3.x](https://github.com/tripal/tripal/tree/7.x-3.x)) of tripal.

# Prerequisites
- A basic install of debian 11.
- It is better if the installation is new with no extra modification.

# Usage
Execute the following commands one by one from a terminal:
```bash
sudo apt update && sudo apt install git -y
git clone https://github.com/shreyas-a-s/oneclick-website-deployer.git
cd oneclick-website-deployer/
./install.sh
```
OR use this single line command from a terminal:
```bash
sudo apt update && sudo apt install git -y && git clone https://github.com/shreyas-a-s/oneclick-website-deployer.git && cd oneclick-website-deployer/ && ./install.sh
```
OR if you want the simplest way:
```
Go to Releases section. Download deployer.zip from latest release. Extract it. Right click the install.sh file and click "Run as a Program" and follow the prompts.
```
>  NOTE: In some systems, right click menu might not have this option. In that case, just double click the file and select "Run in Terminal".

