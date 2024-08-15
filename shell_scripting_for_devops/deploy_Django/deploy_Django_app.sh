#!/bin/bash

# Deploy a Django app and handle errors

# Function to clone the Django app code
code_clone() {
    echo "Cloning the Django app..."
    git clone https://github.com/LondheShubham153/django-notes-app.git
}

# Function to install required dependencies
install_requirements() {
    echo "Installing dependencies..."
    sudo apt-get install docker.io nginx -y docker-compose    
}

# Function to perform required restarts
required_restarts() {
    echo "Performing required restarts..."
    sudo chown "$USER" /var/run/docker.sock

    # Uncomment the following lines if needed:
    # sudo systemctl enable docker
    # sudo systemctl enable nginx
    # sudo systemctl restart docker
}

# Function to deploy the Django app
deploy() {
    echo "Building and deploying the Django app..."
    docker build -t notes-app . 
    docker-compose up -d 
}

# Main deployment script
echo "********** DEPLOYMENT STARTED *********"

# Clone the code
if ! code_clone; then
	echo "Code directory already exists"
    	cd django-notes-app 
fi

# Install dependencies
if ! install_requirements; then
    	echo "Installations Failed"
	exit 1
fi

# Perform required restarts
if ! required_restarts; then
	echo "System faults indentified"
    exit 1
fi

# Deploy the app
if ! deploy; then
    echo "Deployment failed. Mailing the admin..."
    # Add your sendmail or notification logic here
    exit 1
fi

echo "********** DEPLOYMENT DONE *********"
