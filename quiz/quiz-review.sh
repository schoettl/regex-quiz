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
				if [ $ANS == $(outputAnswer "$FILE" "$ID") ]; then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
		"___") echo "Ihre Antwort: $ANS"
				if [[ $ANS =~ $(outputAnswer "$FILE" "$ID") ]]; then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
	esac
	outputExplanation "$FILE" "$ID"

	read -rp "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
	case "$CMD" in
		q) exit
		;;
	esac
done
