#!/usr/bin/env bash

if command -v apt-get > /dev/null; then # Install for debian-based linux distros
	sudo apt-get -y install postgresql
fi

