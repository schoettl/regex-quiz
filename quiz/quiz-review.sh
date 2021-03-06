#!/bin/bash
# See the results of the answered quiz questions
# 
# Jakob Schöttl
# 

USAGE="usage: ${0##*/} [ OPTIONS ] QUIZFILE

  -s  Output a short one-line summary of the quiz results
  -i  Interactive review of quiz questions and answers
  -a ANSWERFILE  Specify the file where the answers are written down
      [default: answers.txt]
  -r RESULTFILE  Specify the file where to write down the results of
      the quiz questions and answers [default: results.txt]
  -h  Print this usage message"

# shellcheck disable=SC1091
source quizlib.sh

getOptions() {
	# default values for options
	INTERACTIVE=false
	SHORT=false
	ANSWERFILE="answers.txt"
	RESULTFILE="results.txt"

	# opions: help, interactive, short, answerfile, resultfile
	while getopts "hisa:r:" OPTION; do
		case $OPTION in
			i) INTERACTIVE=true ;;
			s) SHORT=true ;;
			a) ANSWERFILE="$OPTARG" ;;
			r) RESULTFILE="$OPTARG" ;;
			h) echo "$USAGE" && exit ;;
			\?) exitWithError "For usage see 'quiz -h'" ;;
		esac
	done

	# get arguments
	shift $((OPTIND-1))
	FILE="$1"
	if [ -z "$FILE" ]; then
		exitWithError "$USAGE"
	fi
}

assertDependencies
getOptions "$@"

cat "$ANSWERFILE" | sort | uniq | \
while read -r ID ANS; do
	TYPE=$(outputQuestionType "$FILE" "$ID")

	! checkAnswer "$FILE" "$ID" "$TYPE" "$ANS"
	RESULT=$?

	echo "$ID $TYPE $RESULT"
done > "$RESULTFILE"

if $INTERACTIVE; then
	while read -r ID TYPE RESULT; do
		clear
		echo "ID: $ID"
		echo "TYPE: $TYPE"
		echo

		# Oh, $ANS war ja gar nicht definiert... quick & dirty:
		ANS=$(grep "^$ID " "$ANSWERFILE" | sed "s/^$ID //")

		case $TYPE in
			"[x]"|"(x)") echo "usr sol  (usr: Ihre Antwort, sol: Korrekte Antwort)"
			             outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" ;;
			"0/1"|"___") echo "Ihre Antwort: $ANS" ;;
			"_i_") wdiff \
			        <(outputClozeWithAnswers "$FILE" "$ID" "$ANS" | fillCloze "$FILE" "$ID") \
			        <(outputClozeOriginal "$FILE" "$ID" | fillCloze "$FILE" "$ID")
			       ;;
		esac

		if (( RESULT )); then
			RESPONSE="Richtig"
		else
			RESPONSE="Falsch"
		fi
		echo -e "\n$RESPONSE\n"

		outputExplanation "$FILE" "$ID" "$TYPE"

		echo "(Vermeintliche) Fehler :P gerne formlos melden an"
		echo -e "Jakob Schöttl <jschoett@gmail.com>\n"

		read -rp "Weiter (Enter) oder Beenden (q)? " CMD < /dev/tty
		case "$CMD" in
			q|Q) exit ;;
		esac
	done < "$RESULTFILE"
else
	NTOTAL=$(awk 'END{print NR}' "$RESULTFILE")
	NCORRECT=$(grep -c "1$" "$RESULTFILE")

	if $SHORT; then
		echo "$NCORRECT / $NTOTAL"
	else
		echo "Quiz: $FILE"
		echo "Your answers: $ANSWERFILE"
		echo "----------------------"
		cat "$RESULTFILE" | awk '{printf "%-10s %s   %s\n", $1, $2, $3}' | sed 's/0$/Falsch/;s/1$/Richtig/'
		echo "----------------------"
		echo "Summary: $NCORRECT / $NTOTAL"
	fi
fi
