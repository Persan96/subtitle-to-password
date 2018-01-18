#!/bin/sh

if [ $# -ne 4 ]; then
	echo "usage: $0 <file1.srt> <file2.srt> <word size> <amount of words>"
	exit 1
fi

check_fileexistance() #Check if file actually exists othewise stop
{
	if [ -f "$1" ]; then
		echo "file "$1" exists"
	else
		echo "Please check your filename again."
		exit 1
	fi
}

create_password() #Create password from the two entered files
{
	echo -n "" > prepass
	cat $1 | grep -oE "( |$)[a-z]{$3}( |$)" | sort -nr > firstwordresult
	cat $2 | grep -oE "( |$)[a-z]{$3}( |$)" | sort -nr > secondwordresult
	COUNTER=0
	while [ $COUNTER -lt "$4" ]; do
		shuf -n 1 firstwordresult >> prepass
		let COUNTER=COUNTER+1
		shuf -n 1 secondwordresult >> prepass
		let COUNTER=COUNTER+1
	done
	cat prepass | grep -oE [a-z]+ | tr -d '\n' > password.txt
	rm firstwordresult
	rm secondwordresult
	rm prepass
}

validate_password() #Check if a passwordfile has been created
{
	if [ -f "password.txt" ]; then
		echo "Password created!"
		echo ""
	else
		echo "Password creation failed"
		exit 1
	fi
}

#Execute functions to create password, if something is entered wrongly it will stop
check_fileexistance $1
check_fileexistance $2
create_password $1 $2 $3 $4
validate_password
cat password.txt
echo ""
echo ""
