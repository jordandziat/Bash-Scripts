IFS=$'\n';
startingPath="/Users";

for userFolderName in $(find $startingPath -type d -maxdepth 1 -exec basename {} \;)
	do
		if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles ]
		then
			for firefoxProfile in $(find $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles -type d -maxdepth 1 -exec basename {} \;)
			do
				if [ -e $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile ]
				then
					cd $startingPath/$userFolderName/Library/Application\ Support/Firefox/Profiles/$firefoxProfile
					if [ -e blocklist.xml ]
					then
						echo $(pwd)
						chflags uchg blocklist.xml;
					fi
				fi
			done
		fi
	done