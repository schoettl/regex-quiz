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
		"[x]|(x)") for A in $ANS; do
					echo $A
		        done
				;;
		"0/1") echo "Antwort $ANS gegen 0/1 testen"
				;;
		"___") echo "Antwort $ANS gegen RE testen"
				;;
	esac
done
