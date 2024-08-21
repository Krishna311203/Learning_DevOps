#!/bin/bash

set -euo pipefail

check_aws_cli() {
	#to check if aws cli  is already installed
	if ! command -v aws &> /dev/null
	then
		echo "AWS CLI is not installed. Installing AWS CLI...."
		install_aws_cli
	else
		echo "AWS CLI is already Installed."
	fi
}

install_aws_cli() {
	echo "Installing AWS CLI v2 on the system...."

	#To donwload and install AWS CLI
	curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	sudo apt-get install -y unzip &> /dev/null
	unzip -q awscliv2.zip
	sudo ./aws/install

	# To verify the installation
	aws --version
	# to remove unnecessary files
	rm -rf awscliv2.zip ./aws
	
	echo "AWS CLI Installed Succesfully"
}

check_aws_cli
#main function execution


