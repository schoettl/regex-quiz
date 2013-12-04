#!/bin/bash
# quiz-review.sh quizfile
# 
# Jakob Schöttl
# 

source quizlib.sh

FILE="$1"
ANSFILE="answers.txt"

CORRECT="Richtig"
INCORRECT="Falsch"

echo "Quiz: $FILE"
echo "Your answers: $ANSFILE"
echo -e "----------------------\n"

cat "$ANSFILE" | sort | uniq | \
while read -r ID ANS; do
	TYPE=$(outputQuestionType "$FILE" "$ID")
	echo "ID: $ID"
	echo "TYPE: $TYPE"
	echo

	outputQuestionOnly "$FILE" "$ID"
	case "$TYPE" in
		"[x]"|"(x)") echo "usr sol  (usr: Ihre Antwort, sol: Korrekte Antwort)"
				outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS"
				if
					outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" | \
					grep -vE '^((\[_\] +){2}|(\[x\] +){2}|(\(_\) +){2}|(\(x\) +){2})'
				then
					echo && echo $INCORRECT
				else
					echo && echo $CORRECT
				fi
				;;
		"0/1") echo -e "Ihre Antwort: $ANS\n"
				if [ $ANS == $(outputAnswer "$FILE" "$ID") ]; then
					echo $CORRECT
				else
					echo $INCORRECT
				fi
				;;
		"___") echo -e "Ihre Antwort: $ANS\n"
				if [[ $ANS =~ $(outputAnswer "$FILE" "$ID") ]]; then
					echo $CORRECT
				else
					echo $INCORRECT
				fi
				;;
	esac
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
