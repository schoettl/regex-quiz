#!/bin/bash
# quiz.sh [ first_question_number ] quizfile
#
# Jakob Schöttl
#

USAGE="usage: "

source quizlib.sh

if [ $# -gt 1 ]; then
	I="$1"
	FILE="$2"
else
	I=1
	FILE="$1"
fi

ANSFILE="answers.txt"

clear
echo "Quiz: $FILE"
echo "(ab Frage Nummer $I)"
echo -e "----------------------\n"

while true; do
	ID=$(outputQuestionID "$FILE" "$I")
	if [ -z $ID ]; then
		break
	fi
	TYPE=$(outputQuestionType "$FILE" "$ID")
	echo "ID: $ID"
	echo "TYPE: $TYPE"
	echo
	outputQuestionOnly "$FILE" "$ID"
	case $TYPE in
		"[x]") outputOptionsWithoutAnswers "$FILE" "$ID" | nl -w2 -s' '
		       echo -e "\nBitte geben Sie die Nummern der richtigen Antworten ein (space-separated):"
		       ;;
		"(x)") outputOptionsWithoutAnswers "$FILE" "$ID" | nl -w2 -s' '
		       echo -e "\nBitte geben Sie die Nummer der richtigen Antwort ein:"
		       ;;
		"0/1") echo "Bitte geben Sie 1 oder 0 ein (wahr/falsch):"
		       ;;
		"___") echo "Bitte geben Sie Ihre Antwort ein:"
		       ;;
	esac

	read -r ANS
	echo "$ID $ANS" >> "$ANSFILE"

	clear
	(( I++ ))
done
