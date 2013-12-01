#!/bin/bash
# quiz-review.sh quizfile
# 
# Jakob Schöttl
# 

source quizlib.sh

FILE="$1"
ANSFILE="answers.txt"

cat "$ANSFILE" | sort | uniq | \
while read ID ANS; do
	echo $ID
	TYPE=$(outputQuestionType "$FILE" "$ID")
	case "$TYPE" in
		"[x]"|"(x)") echo "usr sol"
				outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS"
				outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" | \
				if grep -vE '^((\[_\] +){2}|(\[x\] +){2}|(\(_\) +){2}|(\(x\) +){2})'; then
					echo "Falsch"
				else
					echo "Richtig"
				fi
				;;
		"0/1") echo "Ihre Antwort: $ANS"
				if
					echo $ANS | grep -F $(outputAnswer "$FILE" "$ID")
				then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
		"___") echo "Ihre Antwort: $ANS"
				if
					echo $ANS | grep -E "'$(outputAnswer "$FILE" "$ID")'"
				then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
	esac
	outputExplanation "$FILE" "$ID"

	read -p "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
	case "$CMD" in
		q) exit
		;;
	esac
done
