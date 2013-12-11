# Makefile for learn-regex

FILES  =  README.md quiz.sh quiz-review.sh quizlib.sh  quizfile.txt
SRC    = ./quiz
TARGET = /tmp/learn-regex.tgz
PACK   = ./learn-regex

dist:
	rm -rf $(PACK) && mkdir $(PACK)
	cd $(SRC) && cp $(FILES) ../$(PACK)
	rm -f $(TARGET) && tar zcf $(TARGET) $(PACK)
	rm -rf $(PACK)
	@echo
	@echo "    created $(TARGET)"
	@echo


