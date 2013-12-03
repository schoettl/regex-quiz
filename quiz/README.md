Regular Expression Quiz
=======================

Anleitung
---------

Die Quiz-Software besteht aus zwei Bash-Scripts, die ein drittes als Library verwenden:

* `quiz.sh` -- zum Durcharbeiten des Quizzes
* `quiz-review.sh` -- zum Kontrollieren der eigenen Antworten
* `quizlib.sh` -- Library mit Bash-Funktionen

Zuerst sollten Sie sicherstellen, dass Sie mit Ihrer Shell im richtigen Verzeichnis sind:

    cd ~/learn-regex/quiz

Nun können Sie das Quiz starten (Abbrechen/Beenden mit Strg + C):

    ./quiz.sh quizfile.txt

Falls Sie aber schon die ersten 8 Aufgaben gemacht haben und mit der neunten Aufgabe beginnen wollen:

    ./quiz.sh 9 quizfile.txt

Ihre Antworten werden in der Datei `answers.txt` gespeichert.  Zum Kontrollieren Ihrer Antworten:

    ./quiz-review.sh quizfile.txt
	
Um Ihre Antworten zu löschen und von vorne zu beginnen:

    rm answers.txt

Bugs
----

Fehler gerne melden an Jakob Schöttl <jschoett@gmail.com>
