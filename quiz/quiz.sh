#!/bin/bash
# Take a quiz and answer the questions
#
# Jakob Schöttl
#

USAGE="usage: ${0##*/} [ OPTIONS ] QUIZFILE

  -i NUMBER  Specify from wich question the quiz should start
      [default: 1 (first question)]
  -a ANSWERFILE  Specify the file where to write down the answers
      [default: answers.txt]
  -h  Print this usage message"

source quizlib.sh

function getOptions() {
	# default values for options
	ANSFILE="answers.txt"
	NUMBER=1

	# opions: help, firstquestion, answerfile
	while getopts "hi:a:" OPTION; do
		case $OPTION in
			i) NUMBER="$OPTARG" ;;
			a) ANSFILE="$OPTARG" ;;
			h) echo "$USAGE" && exit ;;
			\?) exitWithError "For usage see 'quiz -h'" ;;
		esac
	done

	# get arguments
	shift $(($OPTIND-1))
	FILE="$1"
	if [ -z "$FILE" ]; then
		exitWithError "$USAGE"
	fi
}

assertDependencies
getOptions $@

clear
echo "Quiz: $FILE"
echo "(ab Frage Nummer $NUMBER)"
echo -e "----------------------\n"

while true; do
	ID=$(outputQuestionID "$FILE" "$NUMBER")
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
	(( NUMBER++ ))
done
