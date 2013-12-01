# 
# Jakob Schöttl
# 
# 

# Outputs the ID of the specified question
# param1: quizfile
# param2: question number (>= 1)
function outputQuestionID() {
	grep '^#' "$1" | awk "NR==$2"
}

# Exit with 0 if specified question exists, otherwise 1
# param1: quizfile
# param2: question id
function existsQuestion() {
	grep "^$2" "$1" > /dev/null
	return $?
}

# Outputs a full question from the quizfile
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
	awk '/^(\[_]|\(_\)|___|0\/1)/{f=1};f&&/^[[:space:]]*$/{g=1};!g{print}'
}

# Outputs the question without possible options
# param1: quizfile
# param2: question id
function outputQuestionOnly() {
	outputFullQuestion "$1" "$2" | \
	awk '/^(\[[_x]\]|\([_x]\)|___|0\/1)/{exit};{print}'
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

# Outputs both user and correct answer if type is one of "[x]", "(x)"
# param1: quizfile
# param2: question id
# param3: question type
# param4: user answer
function outputOptionsAnswered() {
	outputOptions "$1" "$2" | \
	awk -v type="$3" -v ans="$4" \
		'function inArray(arr, val) {for(v in arr) if(val == v) return 1; return 0}
		 BEGIN {l=substr(type,1,1); r=substr(type,3,1); split(ans,ansarr)}
		 {i++; if(inArray(ansarr,i)) check="x"; else check="_"; print " " l check r " " $0}'
}

# Outputs the options clearing the answer crosses ("x")
# param1: quizfile
# param2: question id
function outputOptionsWithoutAnswers() {
	outputOptions "$1" "$2" | \
	sed 's/^\[x]/[_]/' | sed 's/^(x)/(_)/'
}

# Outputs 
# param1: quizfile
# param2: question id
function outputNumberedOptions() {
	outputOptions "$1" "$2" | nl -w2 -s' '
}

# Outputs 
# param1: quizfile
# param2: question id
function outputNumberedOptionsWithoutAnswers() {
	outputOptionsWithoutAnswers "$1" "$2" | nl -w2 -s' '
}
