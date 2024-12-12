#!/bin/bash

default="\e[39m"
red="\e[91m"

#echo -e "${red} $1 ${default}"

grep nvidia "$1" -A5 -B5 2>/dev/null 

if [ $? -eq 0 ]
then
	echo -e "${red} $1 ${default}"
fi
