#!/bin/bash - 
#===============================================================================
#
#          FILE: db.sh
# 
#         USAGE: ./db.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: YOUR NAME (), 
#  ORGANIZATION: 
#       CREATED: 04/08/22 14:42:46
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error
dbfilename=users.db

help () {
	format='%-10s%-50s\n'
	echo "Here are the availbale arguments:"
	printf "$format" "argument" "function"
	printf "$format" "help" "to print all available argument"
	printf "$format" "add" "to add new record"
	printf "$format" "backup" "to create a backup db"
	printf "$format" "restore" "to restore latest backup db to current db"
	printf "$format" "find" "to search for certain record"
	printf "$format" "list" "to list all records, option to show in reverse order"
}
addnewuser () {
	declare useranwser
	read -p "Do you want to add a new user? Y/N " useranwser
	case $useranwser in
		Y|y)	read -p "Please input new user name: " newname
			read -p "Please input new user role: " newrole
			echo "$newname,$newrole" >> $dbfilename
			echo -e "New record \033[33m$newname,$newrole\033[0m is added to \033[33m$dbfilename\033[0m";;
		#*)	echo "no answer";;
	esac
}

backup () {
	backupfilename="$(date)-$dbfilename.backup"
	cat $dbfilename > "$backupfilename"
	echo -e "new backup file \033[33m$backupfilename\033[0m has been created."
}

restore () {
	list="$(ls -t | grep "db.backup" | head -1 )"
	cat "$list" > $dbfilename
	echo "$dbfilename has been restored from $list"
}

finduser () {
	read -p "Please input user name to be found: " username
	found=a
	for entry in $(cat $dbfilename); do
		if [[ "$entry" =~ ^${username},.* ]]; then
			echo $entry;
			found=b;
		fi
	done
	if [ "$found" = a ]; then 
		echo "User not found";
	fi
}

listcontent () {
	linecount=$(wc -l $dbfilename | cut -d ' ' -f 1)
	if [[ "$1" == "inverse" ]]; then
		for (( i=$linecount; i >= 1; i--))
		do
			content=$(cat $dbfilename | head -$i | tail -1)
			echo -e "$i. $content"
		done
	else 
		for (( i=1; i <= $linecount; i++))
		do
			content=$(cat $dbfilename | head -$i | tail -1)
			echo -e "$i. $content"
		done 
		
	fi
}
	

case $1 in
	'help') help;;
	add) addnewuser;;
	backup) backup;;
	restore) restore;;
	"find") finduser;; 
	"list") 
		if [[ $# > 1 && $2="--inverse" ]]; then 
			listcontent inverse;
		else listcontent order
		fi;;
	*) echo "unknows $1"
esac

