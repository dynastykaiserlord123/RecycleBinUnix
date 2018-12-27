#!bin/bash

#checks to see if the deleted folder exists and creates it if it doesn't
if ! [ -e $HOME/deleted ]
then
	mkdir $HOME/deleted
fi

#checks to see if the .remove.info file exists and creates it if it doesn't
if ! [ -e $HOME/.remove.info ]
then
	touch $HOME/.remove.info
fi

#Option counters declared for tracking user options
verbose=0
interactive=0

#Checks to see which option(s) the user has selected an upadates the variables declared above as required
while getopts iv opt
	do
		case $opt in
		i) interactive=1;;
		v) verbose=1;;
	esac
done
shift $((OPTIND - 1))

#Checks for the cases where the user forgot to specify a filename, entered a file that doesn't exist, input a directory name, or tried to remove the script itself
if [ $# -lt 1 ]
then 
	echo No file name specified as input
	exit 1
elif ! [ -e $1 ]
then
	echo File specified does not exist. Perhaps the name was mis-spelt
	exit 1
elif [ -d $1 ]
then 
	echo Cannot remove a directory
	exit 1
elif [ $(readlink -m $1) = "$HOME/project/remove" ]
then
	echo Cannot remove itself! OPERATION ABORTED!
	exit 1

#Removes the file based on the option(s) specified by the user
else
	for file in "$@"
	do
		if [ $verbose = 1 ]
		then
			if [ $interactive = 1 ]
			then
				read -p "Are you sure you want to remove the file $file[y/n]?" response
				case $response in 
				[Yy]*) echo $(readlink -m $file)_$(stat -c%i $file) >> .remove.info
				mv -v "$file" "deleted/$(basename $file)_$(stat -c%i $file)" ;;
				esac
			else
				echo $(readlink -m $file)_$(stat -c%i $file) >> .remove.info
				mv -v "$file" "deleted/$(basename $file)_$(stat -c%i $file)"
			fi
		else
			if [ $interactive = 1 ]
			then
				read -p "Are you sure you want to remove the file $file[y/n]?" response
				case $response in 
				[Yy]*) echo $(readlink -m $file)_$(stat -c%i $file) >> .remove.info
				mv "$file" "deleted/$(basename $file)_$(stat -c%i $file)" ;;
				esac
			else
				echo $(readlink -m $file)_$(stat -c%i $file) >> .remove.info
				mv "$file" "deleted/$(basename $file)_$(stat -c%i $file)"
			fi
		fi
	done
fi
