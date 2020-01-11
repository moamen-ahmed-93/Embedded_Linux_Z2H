
#!/bin/bash
optionstr="Usage:./phonebook.sh [OPTION] [NAME] [NUMBER]\n\n\n  -i:\tInsert new contact name and number\n  -v:\tView all saved contacts details\n  -s:\tSearch by contact name\n  -e:\tDelete all records\n  -d:\tDelete only one contact name"
filename="/etc/phonebook/phonebook.txt"
backupfile="/etc/phonebook/phonebook.bak"
if [ "$1" == "" ]
	then
		echo -e $optionstr
		exit 1
fi
if [ -f $filename ] 
then
	echo "Database found..."
else
	echo "Database not found..."
	echo "Creating database..."
	sudo touch $filename
fi
case $1 in
	-v) 
		sudo cat $filename;;
	-e) 
		sudo rm $filename;;
	-d) 
		if [ "$2" == "" ] 
			then
				echo "Usage: ./phonebook.sh -s [NAME]"
				exit 2
		fi
		name="${@:2}"
		sudo cp $filename $backupfile
		delCom=`awk "/$name/ && !f{f=1; next} 1" $filename`
		sudo echo "$delCom" > $filename 

		;;
	-s) 
		if [ "$2" == "" ] 
			then
				echo "Usage: ./phonebook.sh -s [NAME]"
				exit 2
		fi
		name="${@:2}"
		echo $name
		regexline=`grep -Po "^$name(\s?[a-zA-Z])*\s\d+" $filename`
		sudo echo $regexline
		;;
	-i) 
		nameregex="[a-zA-Z]{2,}"
		numberregex="^[0-9]+$"
		fullname=""
		numbers=""
		if [ $# -lt 3 ]
		then
			echo "Usage: ./phonebook.sh -i [NAME] [PHONENUMBER]..."
			exit 2
		fi
		for arg in "$@"
		do
			#echo $arg
			if [[ $arg =~ $nameregex ]]
			then
				fullname=$fullname$arg" "
			elif [[ $arg =~ $numberregex ]]
			then
				
				numbers=$numbers$arg" "
			fi
		done
		echo -e "Name: "$fullname"\nNumbers: "$numbers
		sudo echo $fullname $numbers >> $filename
		sudo cp $filename $backupfile
	;;
	*) echo -e "Option not recognized\n"$optionstr;; 
esac