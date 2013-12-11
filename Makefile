# Makefile for learn-regex

DIST   =  README.md quiz.sh quiz-review.sh quizlib.sh  quizfile.txt
SRC    = ./quiz
TARGET = /tmp/learn-regex.tgz
DIR    = ./learn-regex

dist:
	rm -rf $(DIR) && mkdir $(DIR)
	cd ($SRC) cp $(DIST) $(DIR)
	rm -f $(TARGET) && tar zcf $(TARGET) $(DIR)
	rm -rf $(DIR)
	@echo
	@echo "    created $(TARGET)"
	@echo


