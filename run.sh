#!/bin/bash
for i in `ls *.ulp`
do
	echo ================ $i ===================
	rm -f errr.txt 
	#valgrind -q --error-exitcode=66 --leak-check=full ~/workspace/C++/bin/UnitexToolLogger RunLog $i  -s summ.txt -e errr.txt --cleanlog
	~/workspace/C++/bin/UnitexToolLogger RunLog $i  -s summ.txt -e errr.txt --cleanlog
	#~/Unitex3.0beta/App/UnitexToolLogger RunLog $i  -s summ.txt -e errr.txt --cleanlog
	if [ "$?" -ne "0" ] ;
	then
		echo "Error detected by valgrind on log $i"
		exit 1
	fi
	if [ -f "errr.txt" ] ;
	then
		echo "Error detected while replaying log $i"
		exit 1
	fi
done

