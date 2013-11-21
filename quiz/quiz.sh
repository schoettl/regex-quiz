#!/bin/bash
# 
# Jakob Schoettl
# 
# 

if [ $# -gt 1 ]; then
	I="$1"
	FILE="$2"
else
	I=1
	FILE="$1"
fi

echo "Quiz: $FILE"
echo "ab Frage Nummer $I"

echo Alle Fragen:
grep ^# "$FILE"

while true; do
	ID=$(grep ^# "$FILE" | awk "NR==$I")
	echo ID: $ID
	awk "/^$ID/ , /^#/" "$FILE"
	#break
	# Increment ID
	(( I++ ))
done
#cat quizfile.txt | awk 'BEGIN {f=0}; {if(f)print}; /^#/ {if(/bin/bash~/^#RE-13$/) f=1; else f=0}' | sed '$ d'
