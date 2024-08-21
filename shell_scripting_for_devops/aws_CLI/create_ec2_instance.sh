#!/bin/bash

# Run the check_aws_cli script
./check_aws_cli.sh

# Function to wait for the instance to be in the 'running' state
wait_for_instance() {
	local instance_id="$1"
	echo "Waiting for instance $instance_id to be in running state..."
	
	#  Loop until the instance state is 'running'
	while true; do
		state=$(aws ec2 describe-instances --instance-ids "$instance_id" --query 'Reservations[0].Instances[0].State.Name' --output text)
		#code to break the loop
		if [[ "$state" == "running" ]]; then
			echo "Instance "$instance_id" is now running."
			break
		fi

		#If not running, wait for 10 seconds before checking again
		sleep 10
	done
} 


# Function to create an EC2 instance
create_ec2_instance() {
	# Define variables
	local ami_id=$1
	local instance_type=$2
	local key_name=$3
	local security_group=$4
	local subnet_id=$5
	local instance_name=$6
	
	echo "Creating EC2 instance with the following details:"
    	echo "AMI ID: $ami_id"
    	echo "Instance Type: $instance_type"
    	echo "Key Name: $key_name"
    	echo "Security Group: $security_group"
    	echo "Subnet ID: $subnet_id"
    	echo "Instance Name: $instance_name"

	#CLI command to create an EC2 instance
	instance_id=$(aws ec2 run-instances \
	       	--image-id "$ami_id" \
	       	--instance-type "$instance_type" \
		--key-name "$key_name" \
		--subnet-id "$subnet_id" \
		--security-group-ids "$security_group" \
		--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance_name}]" \
		--query 'Instances[0].InstanceId' \
		--output text \
	)
	
	# Debugging output to check instance_id
	echo "Instance ID returned by AWS: $instance_id"

	if [[ -z "$instance_id" ]]; then
		echo "Failed to create EC2 instance." >&2
		exit 1
	fi
	
	echo "Instance $instance_id created successfully."
	# Wait for the instance to be in running state
	wait_for_instance "$instance_id"
}	

#check if the correct commands are passed to the file


if [ "$#" -lt 6 ] ; then
	echo "**ERROR** Usage: $0 <AMI_ID> <INSTANCE_TYPE> <KEY_NAME> <SECURITY_GROUP> <SUBNET_ID> <INSTANCE_NAME>"
	exit 1
fi

create_ec2_instance "$1" "$2" "$3" "$4" "$5" "$6"
		
	

