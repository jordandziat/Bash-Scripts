## Init Section
#
arrayActivePluginNames[0]="JavaAppletPlugin.plugin";
arrayActivePluginNames[1]="Flash Player.plugin";

#declare -a arrayProfilePaths;
arraySearchString[0]=0;
arrayReplaceString[0]=0;
startingPath="/Users"
fileNameToParse="pluginreg.dat"
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
		grabLineNumber
		#echo "came back"
	done
}
modifyText () {
 			currentNumber=$(echo ${foundString} | head -c$foundstringLineNumber)
    		#echo $currentNumber
    		((currentNumber+=3))
    		#echo $currentNumber
    		originalLine=$(sed -n $currentNumber","$currentNumber"p" $fileNameToParse | head -c$trimLength)
    		modifiedLine=$(sed -n $currentNumber","$currentNumber"p" $fileNameToParse | head -c$trimLength |sed s/./$charToChangeTO/$charLocationToReplace )
    		#echo "original line is = "$originalLine
    		#echo "modified line is = "$modifiedLine
    		sed -i -e "s/$originalLine/$modifiedLine/" $fileNameToParse
    		#echo $indexParse		
}
grabLineNumber () {
## Method Init
stringInitialLine=""
for indexParse in "${arrayActivePluginNames[@]}"
do
	foundString=$(grep -m 1 -n "$indexParse" $fileNameToParse);
	#echo $foundString;
		counterDelimiter=0
		charDelimiter=":"
		foundstringLineNumber=0;
		stringOfCharsWeWillModify=0
		for (( x=0; x<${#foundString}; x++ )); do
		  currentChar=${foundString:$x:1}
		  if [ "$currentChar" == "$charDelimiter" ]
		  	then
		  		if [ "$counterDelimiter" == "0" ]
		  			then
		  				#echo "found :"
		  				#echo "$currentChar"
		  				#echo "$x"
		  				((counterDelimiter++))
		  				((foundstringLineNumber=$x))
		  		fi

		  fi
		done
		modifyText
done
#echo "Completed profile Located At:"
#echo " ${arrayProfilePath[$i]}"
}

populateProfilePathsArray ( ) {
counter=0;
(/usr/libexec/PlistBuddy -c "Delete :WatchPaths " /Library/LaunchAgents/org.vermilionschools.firefoxWatchFiles.plist)
(/usr/libexec/PlistBuddy -c "Add :WatchPaths Array" /Library/LaunchAgents/org.vermilionschools.firefoxWatchFiles.plist)
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
    				(/usr/libexec/PlistBuddy -c "Add :WatchPaths: String ${fullPath}${fileNameToParse}" /Library/LaunchAgents/org.vermilionschools.firefoxWatchFiles.plist);
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
#grabLineNumber