#!/bin/bash
# ./test/test.sh
# Aufzurufen aus dem Ordner quiz/ heraus
# 
# Führt einige Tests an quiz.sh und quiz-review.sh durch.
# 
# Jakob Schöttl
# 

#param1: quiz-input.txt
#param2: number of tested questions
#param3: number of correct answered questions
#param4: answers-to-compare.txt
function run_test() {
	rm -f answers.txt~
	mv answers.txt answers.txt~

	./quiz.sh        test/quizfile.txt < "$1"                       > /dev/null
	./quiz-review.sh test/quizfile.txt < test/quiz-review-input.txt > test/quiz-review-output.txt

	rm answers.txt
	mv answers.txt~ answers.txt

	# Auswertung

	NUMQ=$(grep -E 'Richtig|Falsch' test/quiz-review-output.txt | wc -l)
	if [ $NUMQ != $2 ]; then
		echo "Anzahl der getesteten Fragen ist falsch: $NUMQ statt $2"
	fi

	NUMC=$(grep -E 'Richtig' test/quiz-review-output.txt | wc -l)
	if [ $NUMC != $3 ]; then
		echo "Anzahl der als korrekt befundenen Fragen ist falsch: $NUMC statt $3"
	fi

	grep -E 'Richtig|Falsch' test/quiz-review-output.txt | sed 's/Richtig/1/' | sed 's/Falsch/0/' > test/quiz-review-answers.txt
	if ! diff test/quiz-review-answers.txt "$4"; then
		echo "quiz-review.sh wertet nicht korrekt aus. Unterschiede zwischen test/quiz-review-answers.txt und test/answers-to-compare.txt"
	fi
}

echo "Running tests"
echo "----------------"

# Positive test
echo "Positive test i.e. testing with correct answers"
run_test test/quiz-input.pos.txt 8 8 test/answers-to-compare.pos.txt

# Negative test
echo "Negative test i.e. testing with wrong answers"
run_test test/quiz-input.neg.txt 8 0 test/answers-to-compare.neg.txt

echo "----------------"
echo "Tests complete"
echo "If there are no error messages, the test was successful!"
