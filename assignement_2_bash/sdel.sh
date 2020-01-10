#!/bin/bash
trashDir="/home/"$USER"/TRASH"

if [ -d $trashDir ] 
then
     
    if [ "$(ls -A $trashDir)" ];
    then
    	echo "TRASH directory found..."	
    	sudo find $trashDir/* -mtime +2 -exec rm -dr {} \;
    else
    	echo "TRASH directory found..."	
    fi
else
    echo "TRASH directory not found..."
    echo "Creating TRASH directory in user home directory..."
    sudo mkdir $trashDir
fi

if [ "$1" == "" ]
then
	echo "Usage: ./sdel.sh [FILENAME...]"
	exit 1
fi

for var in "$@"
do
	if [ -d $var  ] || [ -f $var ]
	then
	    case $(file --mime-type -b $var) in
	        application/zip) 
	        	mv $var $trashDir
	        ;;
			application/gzip)
				mv $var $trashDir
			;;
        	*)
				tar -czvf $var".tar.gz" $var
				mv $var".tar.gz" $trashDir
				if [ -d $var  ] 
				then
					rm -dr $var
				else
					rm $var
				fi
			;;
    	esac
    	echo $var" successfully deleted"
	else
		echo "File/directory "$var" not found"
	fi
done