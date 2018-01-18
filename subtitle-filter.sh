#!/bin/sh

SIZEOFPASS="$2"
COUNTER=0

if [ "$2" = "" ]; then
	echo "*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*"
	echo "Please enter wanted amount of words."
	echo "*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*"
	exit 1
else
	echo "*----------------------------------------*"
	echo "$2 is the amount of words used in password"
	echo ""
fi

echo "Filename entered: $1"
echo ""
cat $1 | grep -oE "( |$)[a-z]{5}( |$)" | sort -nr | uniq > results.txt

echo -n "" > password.txt
echo -n "" > prepassword.txt

while [ $COUNTER -lt $SIZEOFPASS ]; do
	shuf -n 1 results.txt >> prepassword.txt
	let COUNTER=COUNTER+1
done

cat prepassword.txt | grep -oE [a-z]+ | tr -d '\n' > password.txt

echo "Password created!"
echo "*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*"
cat password.txt
echo ""
echo "*----------------------------------------*"
