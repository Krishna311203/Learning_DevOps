#!/bin/bash

<< readme 
	this is a script for backup with 5 days rotation
usage for this script is as follows :
./backup.sh <path to source> <path to backup folder>
readme

function display_usage() {

	echo "Usage : ./backup.sh <path to source> <path to backup folder>"
}

if [ $# -lt 2 ]; then
	display_usage
fi

source_dir=$1
timestamp=$(date '+%Y-%m-%d-%H-%M-%S')
backup_dir=$2

function create_backup(){
	zip -r "${backup_dir}/backup_${timestamp}.zip" "${source_dir}" > /dev/null
	if [ $? -eq 0 ]; then
		echo "Backup generated successfully for ${timestamp}"
	fi
}

function perform_rotation() {
	backups=($(ls -t "${backup_dir}/backup_"*.zip 2>/dev/null))
	if [ "${#backups[@]}" -gt 5 ]; then
		echo "Performing rotation for 5 days"
		backups_remove=("${backups[@]:5}")
		for backup in "${backups_remove[@]}";
		do 
			rm -f ${backup}
		done
	fi

}

create_backup
perform_rotation


