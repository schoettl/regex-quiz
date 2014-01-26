#
# quizlib -- a bash library to process quizfiles
# 
# Jakob Schöttl
# 

# Outputs the ID of the specified question
# param1: quizfile
# param2: question number (>= 1)
function outputQuestionID() {
	grep '^#' "$1" | awk "NR==$2"
}

# Outputs a full question from the quizfile
# param1: quizfile
# param2: question id
function outputFullQuestion() {
	awk -v id="$2" '/^#/ {f=0}
		$0 ~ "^" id "[[:space:]]*$" || f {f=1;print}' "$1"
	# [:space:] ist ein Workaround falls CRLF im quizfile
}

# Outputs the question without possible options
# param1: quizfile
# param2: question id
function outputQuestionOnly() {
	outputFullQuestion "$1" "$2" | \
	awk '/^(\[[_x]\]|\([_x]\)|___|0\/1)/{exit}; NR>2 {print}'
}

# Outputs the explanation (for the answer(s))
# param1: quizfile
# param2: question id
function outputExplanation() {
	outputFullQuestion "$1" "$2" | \
	awk '/^(\[[_x]\]|\([_x]\)|___|0\/1)/ {f=1}
	     /^[[:space:]]*$/ && f {f=0; g=1; next}
	     g {print}'
	# Options or answer, followed by blank line -> explanation comes next
}

# Outputs the type i.e. one of "[x]", "(x)", "0/1", "___"
# param1: quizfile
# param2: question id
function outputQuestionType() {
	outputFullQuestion "$1" "$2" | \
	awk '/^\[[_x]\]/ {print "[x]"; exit}
	     /^\([_x]\)/ {print "(x)"; exit}
	     /^0\/1/     {print "0/1"; exit}
	     /^___/      {print "___"; exit}'
}

# Outputs the options if type is one of "[x]", "(x)"
# param1: quizfile
# param2: question id
function outputOptions() {
	outputFullQuestion "$1" "$2" | \
	awk '/^\[[_x]\]/
	     /^\([_x]\)/'
}

# Outputs the answer if type is one of "0/1", "___"
# "0" or "1" for type "0/1", RE for type "___"
# param1: quizfile
# param2: question id
function outputAnswer() {
	outputFullQuestion "$1" "$2" | \
	awk '/^0\/1/ {print $2; exit}
	     /^___/ {sub(/^___[[:space:]]+/, ""); $0=gensub(/^\/(.*)\//, "\\1", "g"); gsub(/\\\//, "/"); print; exit}'
}

# Outputs both user and correct answer for types of "[x]", "(x)"
# param1: quizfile
# param2: question id
# param3: question type
# param4: user answer
function outputOptionsAnswered() {
	outputOptions "$1" "$2" | \
	awk -v type="$3" -v ans="$4" \
		'function inArray(arr, val) {for(k in arr) if(val == arr[k]) return 1; return 0}
		 BEGIN {l=substr(type,1,1); r=substr(type,3,1); split(ans,ansarr)}
		 {i++; if(inArray(ansarr,i)) check="x"; else check="_"; print l check r " " $0}'
}

# Outputs the options clearing the answer crosses ("x")
# param1: quizfile
# param2: question id
function outputOptionsWithoutAnswers() {
	outputOptions "$1" "$2" | \
	sed 's/^\[x]/[_]/' | sed 's/^(x)/(_)/'
}

# Return 0 for a correct answer, 1 otherwise
# param1: quizfile
# param2: question id
# param3: question type
# param4: user answer
function checkAnswer() {
	case $TYPE in
		"[x]"|"(x)") ! outputOptionsAnswered "$FILE" "$ID" "$TYPE" "$ANS" | \
				grep -vE '^((\[_\] +){2}|(\[x\] +){2}|(\(_\) +){2}|(\(x\) +){2})' > \
				/dev/null ;;
		"0/1")  [ $ANS == $(outputAnswer "$FILE" "$ID") ]  ;;
		"___") [[ $ANS =~ $(outputAnswer "$FILE" "$ID") ]] ;;
	esac
}
