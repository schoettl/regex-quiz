#!/bin/bash
# quiz-review.sh quizfile
# 
# Jakob Schöttl
# 

USAGE="usage: "

source quizlib.sh

FILE="$1"
ANSWERFILE="answers.txt"
RESULTFILE="results.txt"

INTERACTIVE=true
#VERBOSE=false
#SUMMARY=false

CORRECT="Richtig"
INCORRECT="Falsch"

cat "$ANSWERFILE" | sort | uniq | \
while read -r ID ANS; do
	TYPE=$(outputQuestionType "$FILE" "$ID")

	if checkAnswer "$FILE" "$ID" "$TYPE" "$ANS"; then
		RESULT="$CORRECT"
	else
		RESULT="$INCORRECT"
	fi

	echo "$ID $TYPE $RESULT"
done > "$RESULTFILE"

if $INTERACTIVE; then
	while read -r ID TYPE RESULT; do
		clear
		echo "ID: $ID"
		echo "TYPE: $TYPE"
		echo

		case $TYPE in
			"[x]"|"(x)") echo "usr sol  (usr: Ihre Antwort, sol: Korrekte Antwort)"
			             outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" ;;
			"0/1"|"___") echo "Ihre Antwort: $ANS" ;;
		esac

		echo -e "\n$RESULT\n"

		outputExplanation "$FILE" "$ID"

		echo "(Vermeintliche) Fehler :P gerne formlos melden an"
		echo -e "Jakob Schöttl <jschoett@gmail.com>\n"

		read -rp "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
		case "$CMD" in
			q|Q) exit ;;
		esac
	done < "$RESULTFILE"
else
	NTOTAL=$(wc -l < "$RESULTFILE")
	NCORRECT=$(grep "$CORRECT"\$ "$RESULTFILE" | wc -l)

	echo "Quiz: $FILE"
	echo "Your answers: $ANSWERFILE"
	echo "----------------------"
	cat "$RESULTFILE"
	echo "----------------------"
	echo "Summary: $NCORRECT / $NTOTAL"
fi
