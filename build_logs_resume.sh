#!/bin/bash

rm logs_resume.txt
for i in `ls *.ulp`
do
	echo "Command line for $i">> logs_resume.txt
	unzip -p $i "test_info/command_line_synth.txt" >> logs_resume.txt
	echo -e "\n">> logs_resume.txt
done

