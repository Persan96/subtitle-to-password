#!/bin/sh

if [ $# -ne 4 ]; then #If number of arguments is anything else than 4, stop and show usage description
	echo "usage: $0 <file1.srt> <file2.srt> <word size> <amount of words>" # Print how script should be used
	exit 1
fi

check_fileexistance() #Check if file actually exists othewise stop
{
	if [ -f "$1" ]; then # If filename matches with a file in path, it exists
		echo "file "$1" exists" 
	else
		echo "Please check your filename again."
		exit 1
	fi
}

create_password() #Create password from the two entered files
{
	echo -n "" > prepass # Create file prepass
	cat $1 | grep -oE "( |$)[a-z]{$3}( |$)" | sort -nr > firstwordresult # Extract only words with small charaters
	cat $2 | grep -oE "( |$)[a-z]{$3}( |$)" | sort -nr > secondwordresult # and put them in files
	COUNTER=0
	while [ $COUNTER -lt "$4" ]; do # Repeat and fill prepass with words until limit is reached
		if [ $COUNTER -lt "$4" ]; then 
			shuf -n 1 firstwordresult >> prepass # Extract one word in the wordlist at random
			let COUNTER=COUNTER+1 # When word has been added, add one to the counter variable
		fi
		if [ $COUNTER -lt "$4" ]; then # If limit has not been reached, go in and add another word from the other file
			shuf -n 1 secondwordresult >> prepass
			let COUNTER=COUNTER+1
		fi
	done
	cat prepass | grep -oE [a-z]+ | tr -d '\n' > password.txt # Remove all newlines and add words to new file
	rm firstwordresult # Remove used files
	rm secondwordresult 
	rm prepass 
}

validate_password() #Check if a passwordfile has been created
{
	if [ -f "password.txt" ]; then # If file exists
		echo "Password created!"
		echo ""
	else 
		echo "Password creation failed"
		exit 1
	fi
}

#Execute functions to create password, if something is entered wrongly it will stop
check_fileexistance $1 # Check if first file exists
check_fileexistance $2 # Check if secodn file exists
create_password $1 $2 $3 $4 # Create password with recieved inputs
validate_password # Check that password was created
cat password.txt # Show contents of pasword.txt
echo ""
echo ""
