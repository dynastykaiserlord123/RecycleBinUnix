#!bin/bash

#Checks to make sure the deleted folder has already been created
#Thus you cannot run this script prior to running the remove script
if ! [ -e $HOME/deleted ]
then
	echo No deleted folder found
	exit 1
fi

#Makes sure that the user has input a filename
if [ $# -lt 1 ]
then 
	echo No file name specified
	exit 1
fi

#Checks for the existence of the .remove.info file
if ! [ -e $HOME/.remove.info ]
then
	echo No .remove.info file found to track deletion information. EXITING!
	exit 1
fi

#Modified to be able to take multiple filenames as arguments and simultaneously restore all of them
for file in "$@"
	do
	if ! [ -e $HOME/deleted/$file ]
	then
		echo Filename $file not found in deleted folder
	else
		if ! [ -e $(fgrep $file .remove.info | cut -d '_' -f1) ]
		then
			mv deleted/$file $(fgrep $file .remove.info | rev | cut -d '_' -f2- | rev)
			sed -i /$file/d .remove.info
		else
			echo File with same name $file already exists! Are you sure you want to overwrite[y/n]?
			read response
			if [ $response = 'y' -o $response = 'Y' -o $response = 'Yes' -o $response = 'yes' ]
			then
				mv deleted/$file $(fgrep $file .remove.info | rev | cut -d '_' -f2- | rev)
				sed -i /$file/d .remove.info
			elif [ $response = 'n' -o $response = 'N' -o $response = 'No' -o $response = 'no' ]
			then
				echo File was not restored
				exit 0
			else
				echo Invalid option selected
				exit 1
			fi
		fi
	fi
done
