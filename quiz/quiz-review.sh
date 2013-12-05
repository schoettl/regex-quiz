#!/bin/bash
# quiz-review.sh quizfile
# 
# Jakob Schöttl
# 

source quizlib.sh

FILE="$1"
ANSFILE="answers.txt"

cat "$ANSFILE" | sort | uniq | \
while read -r ID ANS; do
	echo $ID
	TYPE=$(outputQuestionType "$FILE" "$ID")
	case $TYPE in
		"[x]"|"(x)") echo "usr sol"
				outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS"
				;;
		"0/1"|"___") echo "Ihre Antwort: $ANS"
				;;
	esac

	echo
	if checkAnswer "$FILE" "$ID" "$TYPE" "$ANS"; then
		echo "Richtig"
	else
		echo "Falsch"
	fi

	outputExplanation "$FILE" "$ID"

	read -rp "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
	case "$CMD" in
		q) exit
		;;
	esac
done
