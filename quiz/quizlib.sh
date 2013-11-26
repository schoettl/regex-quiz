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
