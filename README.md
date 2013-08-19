# Aufgabenstellung
Ziel ist, Reguläre Ausdrücke zu lehren   
a) auch Abgrenzung zu shell path expansion  
b) auch die verschiedenen Dialekte (basic BRE, extended ERE, perl PCRE)  


Wichtig ist, gute Beispiele zum Demonstrieren (für mich) und üben (für Studenten)
zu haben, Beispiele, die lebensnah (für Stud. der E-Technik) sind.

## Umsetzung
Als Methode und Medien könnte man sich vorstellen:

* Demo live auf der Kommandozeile (mit grep oder im vim)
  hierzu bräuchte es einen guten "Text", auch mehrere Dateien,
  und interessante (= aussagekräftige [1]) Muster dazu passend.
* Übungsaufgaben (ähnlich hierzu: gegeben ein/mehrere Dateien,
  Aufgabenstellung: suchen Sie alle ... bla) die man einfach so
  im Praktikum (für sich, zu zweit) löst.
* Hausaufgaben: so ähnlich wie Praktikum: Vorgegeben ein 
  (langer, komplizierter) Text, etliche Fragen, die man mit 
  grep und/oder sed lösen kann, die Antworten sind dann
  online (von zuhause) einzureichen.
* einen interaktiven Regex-Editor/Entwicklungsumgebung
  hier bräuchte es dann aber echt sinnvolle Aufgaben dazu!
* Quizz/Tests [2]

--

[1] besonders wichtig ist, "übliche" Fallen zu erleben, z.B. 

* den Unterschied zwischen "Verankerung" `/^.../, /...$/ und ohne /.../, `
*  die Probleme mit dem Stern `/*.*/, /*.txt/, /*abc/,`
* oder auch die ungewollten Leerstrings ` /.*/ `
* oder auch den Unterschied zwischen "alle Dateien, die nicht ... enthalten" und "Dateien, die nichtin jeder Zeile ... enthalten"
* was ist mit "und" bzw. "oder" bei matching...


[2]  Quizz/Tests
hier kann ich mir vorstellen:

* multiple Choice-Aufgaben (man muss die richtige Aussage
  oder korrekte Regex unter 3-5 gegebenen suchen, ankreuzen)
* wahr/falsch: es stehen behauptungen da...
* numerische Kurzantwort: "Wie viele...", "wie oft..."

##Warnung
Im Netzt gibt es massig Tutorials, die aber alle 
nicht wirklich für unseren Einsatz geeignet sind. Wohl aber
können sie als Quelle für unser Vorhaben dienen.

##Anregung
Vielleicht findet sich auf youtube der ein oder andere geeignete
Film - nicht länger als 15 Minuten, sind 5 schon kritisch,
und vor allem: nicht fade, langweilig, zäh, stümperhaft, lieblos.


