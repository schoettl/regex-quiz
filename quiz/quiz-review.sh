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
		"[x]|(x)") outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS"
				;;
		"0/1") echo "Antwort $ANS gegen 0/1 testen"
				if
					echo $ANS | grep -F $(outputAnswer "$FILE" "$ID")
				then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
		"___") echo "Antwort $ANS gegen RE testen"
				if
					echo $ANS | grep -E "'$(outputAnswer "$FILE" "$ID")'"
				then
					echo "Richtig"
				else
					echo "Falsch"
				fi
				;;
	esac
done
