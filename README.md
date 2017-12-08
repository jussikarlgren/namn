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
========================
Kvinnligt-manligt

genus.perl räknar hur många som är manliga kvinnliga eller ambi. filtreras på minfrekv för att få bort knasnamn ($threshold) och på enstaka knasföräldras tilltag ($minimum). Om mindre än $minimum (nedan 5%) av namnen är av det mindre representerade könet så räknas namnet som enkönat.
TODO:
1) gör kurva över $minimum (5% är taget ur en hatt) och kolla om det mer finns övervägande kvinnliga namn som ibland är manliga eller tvärtom. 
2) kolla om detta varierar efter region och kommun och över tid

------------------------------------
0	0.05
antal namn:	175387
antal efter frekvensfiltrering:	175387
	kv	man	ambi
alla	87900	73833	13654
tilltal	41113	31566	2586
antal namn som oftare är ambi om de är andranamn: 12245
antal namn som oftare är ambi om de är tilltalsnamn: 1246
------------------------------------
10	0.05
antal namn:	175387
efter filtrering: 19134
	kv	man	ambi
alla	8270	6354	4510
tilltal	8382	7497	1725
antal namn som oftare är ambi om de är andranamn: 3650
antal namn som oftare är ambi om de är tilltalsnamn: 934
------------------------------------
100	0.05
antal namn:	175387
efter filtrering: 4307
	kv	man	ambi
alla	2105	1723	479
tilltal	2107	1880	285
antal namn som oftare är ambi om de är andranamn: 345
antal namn som oftare är ambi om de är tilltalsnamn: 153
===================================================================
Plats:

Först omformar vi Mickes platshierarki (hierarki.lista) till Ort Län(typ) Landsdel men det gör vi inte för det var för svårt. Just nu finns ingen länsnivå. Data finns i ortlandsdel.lista. För länsnivå måste vi lista ut länsindikerande mellannivåstäder av lagom pregnans. 

Avstånd mellan landsdelar

         Svealand Norrland Götaland Skåne
Svealand 0	  500	   250	    500
Norrland 500	  0	   750	    1000
Götaland 250	  750	   0	    250
Skåne	 500	  1000	   250	    0

Avståndstabell (1) mellan kommuner och (2) mellan län måste göras
===================================================================
Knasighetsmått och kickar för namn

Om ett namn förekommer mycket sparsamt i en population räknas namnet som knasigt. Detta kan vara hapax eller namn som finns högst N ggr i materialet där N måste sättas i relation till populationens storlek, eller eventuellt högst p% av alla namn i populationen. 

Är ett namn ovanligt men ökar hastigt är det en kick. Om antalet individer med namnet är mycket fler i en ort än jämfört med andra orter eller hela populationen eller i en tidsperiod jämfört med alla tidsperioder är det en kick för namnet. 

GIV EXEMPEL HÄR
===================================================================
Variationsbreddsmått för namn

Vi vill kunna jämföra ort A och ort B eller tidperiod X och tidsperiod Y. Vi vill kunna avgöra hur många kreativa namn det finns på något ställe. Då behöver vi ett mått som berättar hur många olika namn ett stickprov (t ex en viss orts alla namn för en viss tidsperiod) innehåller, hur många i den mängden är knasiga dvs ovanliga (antingen lokalt eller för hela mängden), och ur många av populationen täcks av de N vanligaste namnen.

1) En kurva: hur många olika namn krävs för att täcka k% av populationen?
2) En skalär: hur många hapax eller knasiga namn
3) En skalär: hur många olika namn
4) En skalär: hur stor population (för att kunna normalisera (3) ovan)
5) En skalär: avståndsmått från (1) till hela populationens motsvarande kurva.
6) En skalär: var korsar kurva (1) hela populationens motsvarande kurva.


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
---------------------------------
(TID) Slutsats:

(TIDb) Basdata: ser namnpaletterna olika ut över tid? Fler namn? Toppigare namn?

(TIDd) Skillnad per decennium? Varierar något slags toppighetsmått över tid?

(TIDg) Skillnad m/f?

(TIDt) Skillnad t/a?

===================================================================
2. platshierarki:


perl platstopp.perl namn.txt > platstoppighet.list
cut -f1,20 platstoppighet.list |sort -k2.4 -n (av någon anledning fixar inte sort -k20.4 -n samma sak!)




toppighet i plats:

