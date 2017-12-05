Namnvolatilitetsstatistik för projektet SINUS 2012-2017
Jussi Karlgren och Mikael Parkvall

=======================
data:

finns två leveranser, pga ändring i fråga om enbart födelsförsamling till även födelsekommun (vissa andra skillnader finns)

vi struntar i personer födda innan 1920. de har gallrats så hårt av liemannen så de är inte användbara. 

konvertera namn till vettiga bokstävlar måste göras någon gång:

% iconv -f ISO_8859-1 -t UTF-8 sdev.namn.datum.txt > sdev.namn.datum.txt.8

ny820.txt innehåller basdata

========================
basic stats:

tilltal.perl räknar hur många som är unikt tilltal, unikt andranamn, etc etc

% perl tilltal.perl ny820.txt  > tilltal.ny820.txt

namn: 16416968 antal sedda namn
tru 1: 33744   antal olika som alltid är tilltal
tru 2: 62695   antal olika som alltid är andranamn
tru 0: 26075   antal olika som vi inte fått veta huruvida de är det ena eller andra
moz 1: 5987    antal olika som inte är andranamn
moz 2: 11352   antal olika som inte är förstanamn
unk12: 23697   antal som finns som alla tre sorter
knw12: 45581   antal som aldrig varit okända utan enbart som tilltal eller andra

filtrera nu på namn som finns mer än THRESHOLD gånger

namn: 16416968
threshold: 100
tru 1: 0
tru 2: 0
tru 0: 0
moz 1: 0
moz 2: 35
unk12: 4264
knw12: 8

namn: 16416968
threshold: 50
tru 1: 0
tru 2: 0
tru 0: 0
moz 1: 12
moz 2: 110
unk12: 6476
knw12: 46

namn: 16416968
threshold: 10
tru 1: 11
tru 2: 237
tru 0: 3
moz 1: 342
moz 2: 1290
unk12: 16097
knw12: 1165
------------------------------------
SLUTSATS: de flesta namn är ibland obetecknade. om vi bara vill ha de namn som bärs av minst 100 personer får vi endast 4307 stycken kvar.

OM vi trösklar strikt blir det få kvar.

Vi bör köra med
1) alla namn vi har och tröskla endast på 1 2 eller så
2) endast tilltalsnamn
------------------------------------
genus.perl räknar hur många som är manliga kvinnliga eller ambi. filtreras på minfrekv för att få bort knasnamn ($threshold) och på enstaka knasföräldras tilltag ($minimum)
------------------------------------
100:
         kv   man  ambi
alla:    2892 2247 479
tilltal: 2520 2109 285
------------------------------------
10:
         kv   man  ambi
alla:    9503 7209 4510
tilltal: 8852 7776 1725
------------------------------------

NEEDS CHECKING

===================================================================
1. toppighet i tid:

"hur stor andel av namnets förekomster är inom ett visst tidsspann?"

om spannet ($window i frekvens.perl) sätts till 1 är frågan alltså "hur stor andel av namnet är från ett visst år"; om spannet sätts till något större är det en eftersläpning för varje år bakåt med $window antal år, dvs antal förekomster från år T och $window år tidigare. detta ger ett visst fel i redovisningen för jag redovisar sedan per decennium och då har ju ett namn som har sin högsta andel år 1960 med fem års spann alltså peakat på femtitalet och alls icke på sextitalet. men det får vi reda ut senare.

gör detta för 3, 5, 10 spann:

perl frekvens.perl namn.txt > frekvensToppW1.lista &
perl frekvens.perl namn.txt > frekvensToppW3.lista &
perl frekvens.perl namn.txt > frekvensToppW5.lista &
perl frekvens.perl namn.txt > frekvensToppW10.lista &
for d in 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010; do sort frekvensToppW1.lista -k3 |grep $d > $d.w1; done
for d in 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010; do sort frekvensToppW3.lista -k3 |grep $d > $d.w3; done
for d in 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010; do sort frekvensToppW5.lista -k3 |grep $d > $d.w5; done
for d in 1920 1930 1940 1950 1960 1970 1980 1990 2000 2010; do sort frekvensToppW10.lista -k3 |grep $d > $d.w10; done


platshierarki:

först omformar vi mickes platshierarki (hierarki.lista) till
ort län(typ) landsdel men det gör vi inte för det var för svårt. det blir ingen länsnivå. finns nu i ortlandsdel.lista. länsnivå måste vi lista ut länsindikerande mellannivåstäder av lagom pregnans. 


perl platstopp.perl namn.txt > platstoppighet.list
cut -f1,20 platstoppighet.list |sort -k2.4 -n (av någon anledning fixar inte sort -k20.4 -n samma sak!)




toppighet i plats:

