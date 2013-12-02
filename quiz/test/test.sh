#!/bin/bash
# ./test/test.sh
# 
# Aufzurufen aus dem Ordner quiz/ heraus
# Jakob Schöttl
# 

# Positive test
echo "Positive test: all answers are correct"

rm answers.txt~
mv answers.txt answers.txt~

./quiz.sh        test/quizfile.txt < test/quiz-input.pos.txt
./quiz-review.sh test/quizfile.txt < test/quiz-review-input.txt > test/quiz-review-output.txt

rm answers.txt
mv answers.txt~ answers.txt

# Auswertung

NUMQ=$(grep -E 'Richtig|Falsch' test/quiz-review-output.txt | wc -l)
if [ $NUMQ != "8" ]; then
	echo "Anzahl der getesteten Fragen ist falsch: $NUMQ"
fi

NUMC=$(grep -E 'Richtig' test/quiz-review-output.txt | wc -l)
if [ $NUMC != "8" ]; then
	echo "Anzahl der als korrekt befundenen Fragen ist falsch: $NUMC"
fi

grep -E 'Richtig|Falsch' test/quiz-review-output.txt | sed 's/Richtig/1/' | sed 's/Falsch/0/' > test/quiz-review-answers.txt
if ! diff test/quiz-review-answers.txt test/answers-to-compare.pos.txt; then
	echo "quiz-review.sh wertet nicht korrekt aus. Unterschiede zwischen test/quiz-review-answers.txt und test/answers-to-compare.txt"
fi



# Negative test
echo "Negative test: all answers are wrong"

rm answers.txt~
mv answers.txt answers.txt~

./quiz.sh        test/quizfile.txt < test/quiz-input.neg.txt
./quiz-review.sh test/quizfile.txt < test/quiz-review-input.txt > test/quiz-review-output.txt

rm answers.txt
mv answers.txt~ answers.txt

# Auswertung

NUMQ=$(grep -E 'Richtig|Falsch' test/quiz-review-output.txt | wc -l)
if [ $NUMQ != "8" ]; then
	echo "Anzahl der getesteten Fragen ist falsch: $NUMQ"
fi

NUMC=$(grep -E 'Richtig' test/quiz-review-output.txt | wc -l)
if [ $NUMC != "0" ]; then
	echo "Anzahl der als korrekt befundenen Fragen ist falsch: $NUMC"
fi

grep -E 'Richtig|Falsch' test/quiz-review-output.txt | sed 's/Richtig/1/' | sed 's/Falsch/0/' > test/quiz-review-answers.txt
if ! diff test/quiz-review-answers.txt test/answers-to-compare.neg.txt; then
	echo "quiz-review.sh wertet nicht korrekt aus. Unterschiede zwischen test/quiz-review-answers.txt und test/answers-to-compare.txt"
fi
