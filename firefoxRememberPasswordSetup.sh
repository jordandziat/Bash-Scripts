#!/bin/sh
# Created by Jordan Dziat
# Created on 2/8/2013
# Sets the Firefox remember accounts properly.
# Internal File Space Value set to new line only. That way it avoids counting spaces in file names.
IFS=$'\n';
sitesArray[1]="https://vermilionlocal5417.smhost.net";
sitesArray[2]="https://accounts.google.com/Login";

# Path to search in
startingPath="/Users";
# Checks the Users dir for all user profiles. Only lists folders within the path specified.
for userFolderName in $(find $startingPath -type d -maxdepth 1 -exec basename {} \;)
do
	# Checks to see if the folder that stores the profiles exists.
	# If it does get a list of all profiles
	# Check each profile for the signons.sqlite file
	# If it detects the sql file it checks it for the hosts name that is specified.
	# If it does not have the host that we are checking for it gets the last ID and increments it
	# It then inserts it into the correct table
	if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles ]
		then
		for firefoxProfile in $(find $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles -type d -maxdepth 1 -exec basename {} \;)
			do
				if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile ]
					then
					cd $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile
						if [ -e signons.sqlite ]
							then
								for site in "${sitesArray[@]}"
								do
								if [ $(sqlite3 signons.sqlite "select * from moz_disabledHosts" | grep $site) ]
									then
										echo "User "$userFolderName" fire fox profile "$firefoxProfile" has Website "$site" nothing further needs to be done";
									else
										maxID=$(sqlite3 ./signons.sqlite "select id from moz_disabledHosts where id=(SELECT MAX(id) FROM moz_disabledHosts)");
										if [ -z "$maxID" ]
											then 
											maxID=1; 
											fi
									if [ "$maxID" -gt "0" ]
										then
											echo "ID is greater than 0 incrementing by 1"
											maxID=$[maxID+1]
											echo "Getting ready to insert "$site" into the table with id "$maxID;
											sqlite3 ./signons.sqlite "INSERT INTO "moz_disabledHosts" VALUES('$maxID','$site');"
											echo "Successfully inserted the value into the database"
											echo "Removing any saved username and passwords for specified sites"
											sqlite3 ./signons.sqlite "delete from moz_logins where hostname='$site';"
											echo "removed all saved signons for respective websites"
									fi
								fi
								done
						fi
				fi
			done
	fi
done
# Exit with status of 0 to show it was successful 
exit 0;