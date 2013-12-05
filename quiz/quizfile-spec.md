Spezifikation für den Aufbau eines Quizfiles
============================================

Ein Quizfile ist eine Textdatei und besteht aus beliebig vielen Aufgaben.  Die Aufgaben sind durch eine Leerzeile getrennt.  Die Aufgaben haben IDs, die natürlich eindeutig sein müssen.

Begriffsbestimmung
------------------

Folgende Begriffe werden hier in der deutschen Form verwendet.  In den Shell-Skripten werden die englischen Bezeichner verwendet.

* Aufgabe / FullQuestion
* ID der Aufgabe / QuestionID
* Aufgabentyp / QuestionType
* Frage / QuestionOnly
* Optionen / Options (bei Typ `[x]`, `(x)`)
* Antwort / Answer (bei Typ `0/1`, `___`)
* Erklärung / Explanation

Aufbau einer Aufgabe
--------------------

Der Aufbau einer Aufgabe ist folgendermaßen:

    #ID-der-Aufgabe
    
    Frage
    
    Fragetyp, Optionen/Antwort
    
    Erklärung der Lösung

Die vier Teile sind durch je eine Leerzeile getrennt.

### ID der Aufgabe

Die ID besteht aus aus dem Doppelkreuz ("#") gefolgt von einem Bezeichner.  In der gesamten Zeile der ID dürfen keine Leerzeichen stehen.  Der Bezeichner unterliegt keinen weiteren Beschränkungen.

Es macht vielleicht Sinn, die IDs wie folgt aufzubauen: `#QUIZTHEMA-NR`; Beispiel: `#RE-13`

### Frage

Die Frage ist beliebiger [Markdown][md]-Text, bis auf folgende Ausnahmen:

* darf keine Überschriften enthalten
* keine Zeile darf mit folgendem Regulären Ausdruck matchen: `^(\[[_x]]|\([_x]\)|0/1|___)`.  In anderen Worten, die Zeilen mit keinem der folgenden Strings beginnen: "[\_]", "[x]", "(\_)", "(x)", "0/1", "\_\_\_".

(Leerzeilen/Absätze sind erlaubt.)

### Fragetyp, Optionen/Antwort

Dieser Teil enthält den Fragetyp und die korrekten Antworten.  Der Text dieses Teils ist je nach Fragetyp unterschiedlich.

#### Typ: Multiple Choice `[x]`

Bei diesem Typ gibt es mindestens eine Option.  Die einleitende Klammer steht am Zeilenanfang (keine führenden Leerzeichen).  Jede Option bekommt genau eine Zeile.  Es sind keine Leerzeilen zwischen den Optionen erlaubt.  Der Text jeder Option ist [Markdown][md]-Text.  Er wird von den einleitenden Klammern durch ein Leerzeichen getrennt.  Es gilt die inherente Einschränkung, dass der Text nur Teil einer Zeile ist und somit nur bestimmte [Markdown][md]-Features nutzen kann.

Beispiel:

    [x] Richtige Antwort
    [_] Falsche Antwort

Richtige Optionen werden mit einem kleinen X ("x") markiert, falsche Optionen mit einem Unterstrich ("\_").

#### Typ: Single Choice `(x)`

Bei diesem Typ gibt es mindestens eine Option.  Die einleitende Klammer steht am Zeilenanfang (keine führenden Leerzeichen).  Jede Option bekommt genau eine Zeile.  Es sind keine Leerzeilen zwischen den Optionen erlaubt.  Der Text jeder Option ist [Markdown][md]-Text.  Er wird von den einleitenden Klammern durch ein Leerzeichen getrennt.  Es gilt die inherente Einschränkung, dass der Text nur Teil einer Zeile ist und somit nur bestimmte [Markdown][md]-Features nutzen kann.

Beispiel:

    (x) Richtige Antwort
    (_) Falsche Antwort

Die richtigen Optionen werden mit einem kleinen X ("x") markiert, falsche Optionen mit einem Unterstrich ("\_").  Es muss genau eine Option richtig sein.

#### Typ: True/False `0/1`

Fragen dieses Typs erlauben nur eine Richtig/Falsch-Antwort.  Der String "0/1" definiert den Fragetyp.  Er steht am Zeilenanfang (keine führenden Leerzeichen).  Die korrekte Antwort wird durch genau ein Leerzeichen getrennt binär ("0" oder "1") dahinter angegeben.

Beispiel:

    0/1 1

#### Typ: Free Input `___`

Fragen dieses Typs erlauben eine freie Eingabe als Antwort.  Der String "\_\_\_" definiert den Fragetyp.  Er steht am Zeilenanfang (keine führenden Leerzeichen).  Die korrekte Antwort wird durch genau ein Leerzeichen getrennt als POSIX Extended Regular Expression zwischen Schrägstrichen ("/") angegeben.

Beispiel:

    ___ /^(richtig|korrekt)$/

Schrägstriche innerhalb des Regulären Ausdrucks müssen natürlich mit dem Backslash ("\") entwertet werden.  Der Reguläre Ausdruck muss in der Regel mit `^...$` an der Zeile verankert werden.  Ansonsten würde z.B. `42` als Antwort durchgehen wenn die korrekte Antwort (ohne Anker) durch `/4/` definiert ist.

### Erklärung der Lösung

Die Erklärung ist beliebiger [Markdown][md]-Text, bis auf folgende Ausnahmen:

* darf keine Überschriften enthalten

(Leerzeilen/Absätze sind erlaubt.)

Die Erklärung sollte

* eine gute Erklärung der Lösung sein.
* insbesondere beim Fragetyp `___` die korrekte Antwort wiederholen!  Aber nicht als Regulären Ausdruck, sondern z.B.: Richtig sind die Antworten "richtig" oder "korrekt".
* zusätzlich auf die Hilfe verweisen, z.B.: Siehe `man grep` oder `grep --help`.
* erklärende oder weiterführende Internetlinks bereithalten.

Beispiel einer Aufgabe
----------------------

    #RE-16
    
    Schreiben Sie einen Regulären Ausdruck, der die Maus in folgendem Satz findet: "Wo ist die Maus?"
    
    ___ /^Maus$/
    
    Um ein Wort zu finden, die keine RE-Metazeichen enthält, ergibt sich ein ganz einfacher Regulärer Ausdruck: `Maus`

Für weitere Beispiele siehe `quizfile.txt`.


[md]: http://markdown.de/ "Markdown"
