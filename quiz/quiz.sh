#!/bin/bash
# 
# Jakob Schoettl
# 
# 

source quizlib.sh

if [ $# -gt 1 ]; then
	I="$1"
	FILE="$2"
else
	I=1
	FILE="$1"
fi

echo "Quiz: $FILE"
echo "ab Frage Nummer $I"

while true; do
	ID=$(grep ^# "$FILE" | awk "NR==$I")
	echo ID: $ID
	TYPE=$(outputQuestionType "$FILE" "$ID")
	echo TYPE: $TYPE
	echo ---------------
	outputQuestionOnly "$FILE" "$ID"
	case "$TYPE" in
		"[x]") outputNumberedOptionsWithoutAnswers "$FILE" "$ID"
		       echo -e "\nBitte geben Sie die Nummern der richtigen Antworten ein (space-separated):"
		       ;;
		"(x)") outputNumberedOptionsWithoutAnswers "$FILE" "$ID"
		       echo -e "\nBitte geben Sie die Nummer der richtigen Antwort ein:"
		       ;;
		"0/1") echo "Bitte geben Sie 1 oder 0 ein (wahr/falsch):"
		       ;;
		"___") echo "Bitte geben Sie Ihre Antwort ein:"
		       ;;
	esac
	read ANS
	echo "$ID $ANS" >> answers.txt
	
	break
	if [ $? -ne 0 ]; then
		break
	fi
	clear
	(( I++ ))
done
