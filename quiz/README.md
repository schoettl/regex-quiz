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

Ihre Antworten werden in der Datei `answers.txt` gespeichert.  Existiert die Datei bereits, werden die Antworten hinten angehängt.

Zum Kontrollieren Ihrer Antworten:

    ./quiz-review.sh quizfile.txt

Um Ihre Antworten zu löschen und von vorne zu beginnen:

    rm answers.txt

Bemerkungen
-----------

Die Quizaufgaben sind in [Markdown](http://daringfireball.net/projects/markdown/) geschrieben.  Im "Rohformat" stehen Programmaufrufe und Reguläre Ausdrücke daher entweder eingerückt oder zwischen Backticks ("\`").  Die Backticks sind also nie Teil des Regulären Ausdrucks!

Das Quiz ist so gedacht, dass Sie nebenbei (in einer zweiten Shell) auch ausprobieren und `man` oder `--help` benutzen.

Um Aufrufe von grep, sed oder awk ohne Datei zu testen, können Sie folgendes machen:

    echo 'ein text' | sed 's/ /-/'

Dependencies
------------

The quiz requires at least Bash version 3 for the Conditional Construct `[[...]]`


The quiz requires GNU Awk.  To install it with APT:

    sudo apt-get -y install gawk

Bugs
----

Fehler gerne melden an Jakob Schöttl <jschoett@gmail.com>
