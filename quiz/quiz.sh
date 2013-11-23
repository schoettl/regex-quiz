#!/bin/bash
# 
# Jakob Schoettl
# 
# 

# param1: quizfile
# param2: question id
function outputFullQuestion() {
	cat "$1" | awk '/^#/{f=0};/^'"$2"'[[:space:]]*$/||f{f=1;print}'
	# [:space:] ist ein Workaround, wahrscheinlich nötig wegen CRLF
}

# param1: quizfile
# param2: question id
function outputQuestionWithoutAnswer() {
	outputFullQuestion "$1" "$2" | \
	sed 's/^\[x]/[_]/' | sed 's/^(x)/(_)/' | \
	sed 's/^\(____*\).*/\1/' | sed 's/0\/1.*/0\/1/' | \
	awk '/^(\[_]|\(_\)|___+|0\/1)/{f=1};f&&/^[[:space:]]*$/{g=1};!g{print}'
}

if [ $# -gt 1 ]; then
	I="$1"
	FILE="$2"
else
	I=1
	FILE="$1"
fi

echo "Quiz: $FILE"
echo "ab Frage Nummer $I"

while true; do
	ID=$(grep ^# "$FILE" | awk "NR==$I")
	echo ID: $ID
	outputQuestionWithoutAnswer "$FILE" "$ID"
	break
	if [ $? -ne 0 ]; then
		break
	fi
	clear
	(( I++ ))
done
