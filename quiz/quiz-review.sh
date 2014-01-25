#!/bin/bash
# quiz-review.sh quizfile
# 
# Jakob Schöttl
# 

source quizlib.sh

FILE="$1"
ANSFILE="answers.txt"

INTERACTIVE=true
#VERBOSE=false
#SUMMARY=false

CORRECT="Richtig"
INCORRECT="Falsch"

clear
echo "Quiz: $FILE"
echo "Your answers: $ANSFILE"
echo -e "----------------------\n"

if $INTERACTIVE; then
	cat "$ANSFILE" | sort | uniq | \
	while read -r ID ANS; do
		TYPE=$(outputQuestionType "$FILE" "$ID")
		echo "ID: $ID"
		echo "TYPE: $TYPE"
		echo

		case $TYPE in
			"[x]"|"(x)") echo "usr sol  (usr: Ihre Antwort, sol: Korrekte Antwort)"
					outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" ;;
			"0/1"|"___") echo "Ihre Antwort: $ANS" ;;
		esac

		echo
		if checkAnswer "$FILE" "$ID" "$TYPE" "$ANS"; then
			echo $CORRECT
		else
			echo $INCORRECT
		fi

		echo
		outputExplanation "$FILE" "$ID"

		echo "(Vermeintliche) Fehler :P gerne formlos melden an"
		echo -e "Jakob Schöttl <jschoett@gmail.com>\n"

		read -rp "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
		case "$CMD" in
			q|Q) exit
			;;
		esac
		clear
	done
else
	NTOTAL=0
	NCORRECT=0
	# BUG: piping into while -> subshell -> changed variables not "exported"
	cat "$ANSFILE" | sort | uniq | \
	while read -r ID ANS; do
		(( NTOTAL++ ))
		TYPE=$(outputQuestionType "$FILE" "$ID")

		if checkAnswer "$FILE" "$ID" "$TYPE" "$ANS"; then
			RESULT="$CORRECT"
			(( NCORRECT++ ))
		else
			RESULT="$INCORRECT"
		fi

		echo "$ID $TYPE $RESULT"
	done

	echo "----------------------"
	echo "Summary: $NCORRECT / $NTOTAL"
fi
