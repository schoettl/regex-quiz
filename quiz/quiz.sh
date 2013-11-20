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

echo Fragen:
grep ^# "$FILE" | sed "$1,"