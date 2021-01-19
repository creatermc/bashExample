#!/bin/bash

list="One\ntwo\nthree\nfour"

#Print the list with echo
echo -e "echo: \n$list"

#Set the field separator to new line
IFS=$'\n'

#Try to iterate over each line
echo "For loop:"
for item in $list
do
        echo "Item: $item"
done

#Output the variable to a file
echo -e $list > list.txt

#Try to iterate over each line from the cat command
echo "For loop over command output:"
for item in `cat list.txt`
do
        echo "Item: $item"
done
echo ""
for itemm in $list
do
        echo "Itemm: $itemm"
done

echo ""


list="One\ntwo\nthree\nfour"
echo "$list"
#output One\ntwo\nthree\nfour
list=$'One\ntwo\nthree\nfour'
echo "$list"
#output
#One
#two
#three 
#four

#И если у вас уже есть такая строка в переменной, вы можете читать ее построчно с помощью:
while read -r $line; do
    echo "... $line ..."
	echo ""

# Проверка на имеющуюся папку
	if [ -d "$line" ]
		then
		echo "Check folder - $line succesfully!"
	else
		echo "Folder $1 not exist. Create..."
		mkdir -p /home/andrew/1c/$line
	fi
done <<< "$list"
