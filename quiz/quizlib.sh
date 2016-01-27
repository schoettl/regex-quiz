#
# quizlib -- a bash library to process quizfiles
# 
# Jakob Schöttl
# 

# Exit the script with a message and status code 1
# param1: error message
exitWithError() {
	echo "$1" >&2
	exit 1
}

assertDependencies() {
	bash --version | grep -qE 'version ([3-9]|[[:digit:]]{2,})\.[[:digit:]]+\.[[:digit:]]+' \
		|| exitWithError "error: Bash version 3 or newer required"
	gawk --version | grep -q '^GNU Awk' \
		|| exitWithError "error: GNU Awk required"
	wdiff --version >/dev/null \
		|| exitWithError "error: wdiff required"
}

# Output the ID of the specified question
# return: 0 -> found, 1 -> not found
# param1: quizfile
# param2: question number (>= 1)
outputQuestionID() {
	grep '^#' "$1" | awk "NR==$2" | grep .
}

# Output a full question from the quizfile
# param1: quizfile
# param2: question id
outputFullQuestion() {
	awk -v id="$2" '/^#/ {f=0}
		$0 ~ "^" id "[[:space:]]*$" || f {f=1;print}' "$1"
	# [:space:] ist ein Workaround falls CRLF im quizfile
}

# Output the question without possible options
# param1: quizfile
# param2: question id
outputQuestionOnly() {
	outputFullQuestion "$1" "$2" | \
	awk '/^(\[[_x]\]|\([_x]\)|___|0\/1|_[[:digit:]]_)/{exit}; NR>2'
}

# Output the explanation (for the answer(s))
# param1: quizfile
# param2: question id
# param3: question type
outputExplanation() {
	case $3 in
		"_i_")
			outputFullQuestion "$1" "$2" | \
			awk '/^_[[:digit:]]_/ {f=1}
			     /^[[:space:]]*$/ && f {if(c++==1) next}
			     c>1'
			;;
		*)
			outputFullQuestion "$1" "$2" | \
			awk '/^(\[[_x]\]|\([_x]\)|___|0\/1)/ {f=1}
			     /^[[:space:]]*$/ && f {f=0; g=1; next}
			     g'
			# Options or answer, followed by blank line -> explanation comes next
			;;
	esac
}

# Output the type i.e. one of "[x]", "(x)", "0/1", "___", "_i_"
# param1: quizfile
# param2: question id
outputQuestionType() {
	outputFullQuestion "$1" "$2" | \
	awk '/^\[[_x]\]/      {print "[x]"; exit}
	     /^\([_x]\)/      {print "(x)"; exit}
	     /^0\/1/          {print "0/1"; exit}
	     /^___/           {print "___"; exit}
	     /^_[[:digit:]]_/ {print "_i_"; exit}'
}

# Output the options if type is one of "[x]", "(x)"
# param1: quizfile
# param2: question id
outputOptions() {
	outputFullQuestion "$1" "$2" | \
	awk '/^\[[_x]\]/
	     /^\([_x]\)/'
}

# Output the answer if type is one of "0/1", "___"
# "0" or "1" for type "0/1", RE for type "___"
# param1: quizfile
# param2: question id
outputAnswer() {
	outputFullQuestion "$1" "$2" | \
	awk '/^0\/1/ {print $2; exit}
	     /^___/ {sub(/^___[[:space:]]+/, ""); $0=gensub(/^\/(.*)\//, "\\1", "g"); gsub(/\\\//, "/"); print; exit}'
}

# Output both user and correct answer for types of "[x]", "(x)"
# param1: quizfile
# param2: question id
# param3: question type
# param4: user answer
outputOptionsAnswered() {
	outputOptions "$1" "$2" | \
	awk -v type="$3" -v ans="$4" \
		'function inArray(arr, val) {for(k in arr) if(val == arr[k]) return 1; return 0}
		 BEGIN {l=substr(type,1,1); r=substr(type,3,1); split(ans,ansarr)}
		 {i++; if(inArray(ansarr,i)) check="x"; else check="_"; print l check r " " $0}'
}

# Output the options clearing the answer crosses ("x")
# param1: quizfile
# param2: question id
outputOptionsWithoutAnswers() {
	outputOptions "$1" "$2" | \
	sed 's/^\[x]/[_]/' | sed 's/^(x)/(_)/'
}

# Output the cloze words of a question of type "_i_"
# param1: quizfile
# param2: question id
outputClozeWords() {
    outputFullQuestion "$1" "$2" | \
	awk '
	    /^_[[:digit:]]_/ {w=1; print}
	    /^[[:space:]]*$/ && w {exit}' | \
    sort
	# hier ist die leerzeile wichtig, im gegensatz zu "(x)", "[x]"
	# oder sollen wir das sortieren dem autor überlassen?
}

# Output the cloze with the original placeholders
# param1: quizfile
# param2: question id
outputClozeOriginal() {
	outputFullQuestion "$1" "$2" | \
	awk '
		/^_[[:digit:]]_/ {f1=1}
		/^[[:space:]]*$/ && f2 {exit}
		f2
		/^[[:space:]]*$/ && f1 {f2=1}'
}

# Output the cloze clearing all placeholders
# param1: quizfile
# param2: question id
outputClozeCleared {
	outputClozeOriginal "$1" "$2" | sed 's/_[[:digit:]]_/___/g'
}

# Output the cloze with the provided answers
# param1: quizfile
# param2: question id
# param3: user answer
outputClozeWithAnswers() {
	outputClozeCleared "$1" "$2" | \
	awk -v answers="$3" '
		BEGIN {
			cans = split(answers, aans, " ")
		}
		{
			while (ians < cans && index($0, "___"))
				$0 = gensub(/___/, "_" aans[++ians] "_", 1)
			print
		}'
}

# Output the cloze with filled gaps
# input: cloze to fill in e.g. outputClozeOriginal or outputClozeWithAnswers
# param1: quizfile
# param2: question id
fillCloze() {
	CLOZEWORDS=$(outputClozeWords "$1" "$2")
	#outputClozeOriginal "$1" "$2" | \
	awk -v clozewords="$CLOZEWORDS" '
		BEGIN {
			split(clozewords, awords, "\n")
			for (i in awords) {
				line = awords[i]
				match(line, /_[[:digit:]]_/)
				amap[substr(line, RSTART, RLENGTH)] = substr(line, RLENGTH + 2)
			}
		}
		{
			for (k in amap)
				gsub(k, "_" amap[k] "_", $0)
			# clear remaining gaps with invalid numbers
			gsub(/_[[:digit:]]_/, "___", $0)
			print
		}'
}

# Return 0 for a correct answer, 1 otherwise
# param1: quizfile
# param2: question id
# param3: question type
# param4: user answer
checkAnswer() {
	FILE="$1"
	ID="$2"
	TYPE="$3"
	ANS="$4"
	case $TYPE in
		"[x]"|"(x)") ! outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" | \
				grep -qvE '^((\[_\] +){2}|(\[x\] +){2}|(\(_\) +){2}|(\(x\) +){2})' ;;
		"0/1") [[ $ANS == $(outputAnswer "$FILE" "$ID") ]] ;;
		"___") [[ $ANS =~ $(outputAnswer "$FILE" "$ID") ]] ;;
		"_i_") cmp -s \
		        <(outputClozeOriginal "$FILE" "$ID" | fillCloze "$FILE" "$ID") \
		        <(outputClozeWithAnswers "$FILE" "$ID" "$ANS" | fillCloze "$FILE" "$ID") ;;
	esac
}
