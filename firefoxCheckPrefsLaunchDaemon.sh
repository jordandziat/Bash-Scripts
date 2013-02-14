## Init Section
#
arrayActivePrefs[0]="app.update.auto";
arrayActivePrefs[1]="app.update.enabled";
arrayActivePrefs[2]="signon.rememberSignons";
arrayActivePrefs[3]="startup.homepage_welcome_url";

arrayCorrectValues[0]="false"
arrayCorrectValues[1]="false"
arrayCorrectValues[2]="false"
arrayCorrectValues[3]="http://www.vermilionschools.org"

arrayFullPropertyValue[0]='user_pref("app.update.auto", false);'
arrayFullPropertyValue[1]='user_pref("app.update.enabled", false);'
arrayFullPropertyValue[2]='user_pref("signon.rememberSignons", false);'
arrayFullPropertyValue[3]='user_pref("startup.homepage_welcome_url", "http://www.vermilionschools.org");'

#declare -a arrayProfilePaths;
arraySearchString[0]=0;
arrayReplaceString[0]=0;
startingPath="/Users"
fileNameToParse="prefs.js"
counterStringIndex=0;
trimLength=17;
charLocationToReplace=17;
charToChangeTO=5;

changeDirectoryToEachProfile () {
echo ${arrayProfilePath[@]}
for (( i = 0 ; i < ${#arrayProfilePath[@]} ; i++ ))
	do
		cd "${arrayProfilePath[$i]}"
		#echo "echo array ${arrayProfilePath[$i]}"
		#echo "echo i = "$i
		checkPrefsFile
		#echo "came back"
	done
}
correctPreference () {
		echo "${arrayFullPropertyValue[$prefsCounter]}" | cat - $fileNameToParse > temp && mv temp $fileNameToParse
}
checkPrefsFile () {
## Method Init
stringInitialLine=""
prefsCounter=0
touch $fileNameToParse
for indexParse in "${arrayActivePrefs[@]}"
do
		foundString=$(grep -m 1 "$indexParse" $fileNameToParse);
		echo $foundString;
		if [[ "$foundString" == "${arrayFullPropertyValue[$prefsCounter]}" ]];
		then
			echo "value is Correct"
			else
			echo "wrong value"
			correctPreference
		fi
		counterDelimiter=0
		charDelimiter=":"
		foundstringLineNumber=0;
		stringOfCharsWeWillModify=0
		((prefsCounter++))
done
#echo "Completed profile Located At:"
#echo " ${arrayProfilePath[$i]}"
}

populateProfilePathsArray ( ) {
counter=0;
(/usr/libexec/PlistBuddy -c "Delete :WatchPaths " /Library/LaunchDaemons/org.vermilionschools.firefoxWatchPrefs.plist)
(/usr/libexec/PlistBuddy -c "Add :WatchPaths Array" /Library/LaunchDaemons/org.vermilionschools.firefoxWatchPrefs.plist)
for userFolderName in $(find $startingPath -type d -maxdepth 1 -exec basename {} \;)
do
	if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles ]
    	then
    		for firefoxProfile in $(find $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles -type d -maxdepth 1 -exec basename {} \;)
    		do
    		 	if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile/$fileNameToParse ]
    		 		then
    				#echo $firefoxProfile 
    				fullPath=$startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile
    				arrayProfilePath[$counter]="${fullPath}"
    				#echo "${fullPath}${fileNameToParse}"
    				(/usr/libexec/PlistBuddy -c "Add :WatchPaths: String ${fullPath}" /Library/LaunchDaemons/org.vermilionschools.firefoxWatchPrefs.plist);
    				echo ${arrayProfilePath[$counter]}
    				((counter++))
    			fi
    		done
    fi
done
}

populateProfilePathsArray
echo "calling Change Dir"
changeDirectoryToEachProfile
