use Getopt::Std;

#Carin   N       K       2011    Maria magd.     Stockholm       1
#Carina          K       1956    Maria   Tingsryd        1
#Carina  J       K       1944    Maria magd.     Tanum   1
#Carina  J       K       1957    Maria   G�teborg        1
#Carina  J       K       1957    Maria   Helsingborg     3

#A:son	N	M	1948	Visby	Gotland	Knivsta	1
#Aabo		M	1947	Enskede	Stockholm	Sollentuna	1
#Aabraham		M	1991	Flemingsberg	Huddinge	Stockholm	1
#Aaby	N	M	1969	Växjö	Växjö	Västervik	1
#Aada-Elina	J	K	2004	Nedert.-hap	Haparanda	Haparanda	1
#Aadel	N	M	2009	Karlskrona s	Karlskrona	Karlskrona	1
#Aadhi	N	M	1971	Sävedalen	Partille	Göteborg	1
#Aadhya	J	K	2013	Backa	Göteborg	Göteborg	1
#Aadil		M	2013	Husby-ärl.	Sigtuna	Sigtuna	1

$threshold = 100;
$window = 5;
$tilltalsfilter = 0;
$segment=100;
#$landsdelsfilter = "Götaland";
#$konfilter = "M";

&getopts('l:d:k:t:w:f:s:');
$konfilter = $opt_k if $opt_k;
$landsdelsfilter = $opt_l if $opt_l;
$decenniefilter = $opt_d if $opt_d;
$tilltalsfilter = $opt_t if $opt_t;
$threshold = $opt_f if $opt_f;
$window = $opt_w if $opt_w;
$segment = $opt_s if $opt_s;

print STDERR "Filter: $threshold ; $window ; $segment ; $tilltalsfilter ; $konfilter; $aldersfilter ; $fodelseortsfilter ; $landsdelsfilter ; $decenniefilter \n";

open HH,"<data/ortlandsdel.lista";
while(<HH>) {
    @hh = split;
    $region{$hh[0]} = $hh[1];
    $landsdel{$hh[0]} = $hh[2];
}
close HH;

# definiera mått som går att jämföra kommun, landsdel, decennium etc
# antal olika namn, tilltalsnamn, M/K
# hur många namn täcker hur många procent av namnen? kurva
# använd mätpunkter vid jämna tiotals procent
# minstakvadratsavståndsmått mellan sådana fördelningar
# hur stor andel av namnen är knasiga och ovanliga (< N förekomster)
# räkna hapax och eventuellt <1% eller liknande
#==========================================================================
# LÄS IN BASDATA
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
    next if ($tilltal ne "J" && $tilltalsfilter);
    next if ($konfilter && $kon ne $konfilter);
    next if ($aldersfilter && $fodar != $aldersfilter);
    next if ($fodelseortsfilter && $fodelseort ne $fodelsortsfilter);
    next if ($landsdelsfilter && $landsdel{$fodelseort} ne $landsdelsfilter);
    $decennium = int($fodar/10) * 10;
    next if ($decenniefilter && $decennium != $decenniefilter);
    $aar{$fodar}++;
    $frekv{$namn} += $antal;
    $fodd{$fodar}{$namn} += $antal;
    $decennielista{$decennium}++;
    $foddd{$namn}{$decennium} += $antal;
    $stann{$namn} += $antal if $fodelseort eq $bostadsort;
    $stannd{$namn}{$decennium} += $antal if $fodelseort eq $bostadsort;
}
#==========================================================================
# KATEGORISERA EFTER ORT ELLER DECENNIUM ETC
# just nu gör inte det utan kör alla
#==========================================================================
# FILTRERA PÅ FREKVENS
# men spara basdata för jämförelse och utmatning på slutet för säkerhets skull
$antalolikanamn = 0;
$antalolikafiltreradenamn = 0;
$antalnamn = 0;
$antalfiltreradenamn = 0;
$hapax = 0;
$filterfrekvensnamn = 0;
for $namn (keys %frekv) {
    $antalolikanamn++;
    $antalnamn += $frekv{$namn};
    if ($frekv{$namn} == 1) {$hapax++;}
    if ($frekv{$namn} == $threshold) {$filterfrekvensnamn++;}
    if ($frekv{$namn} < $threshold) {delete $frekv{$namn}; next;}
    $antalolikafiltreradenamn++;
    $antalfiltreradenamn += $frekv{$namn};
}
#==========================================================================
# ANALYS
$seddanamn=0;
$andelseddanamn=0;
$seddaolikanamn=0;
$andelar=1/$segment;
#$first = 1;
for $namn (sort {$frekv{$a} <=> $frekv{$b}} keys %frekv) {
    $seddanamn += $frekv{$namn};
    $andelseddanamn = $seddanamn/$antalfiltreradenamn;
    $seddaolikanamn++;
    $andelseddaolikanamn = $seddaolikanamn/$antalolikafiltreradenamn;
#    if ($first) {
#	print "1\t$seddaolikanamn\t$antaolikafiltreradenamn\n";
#	$first = 0;
#    }
    if ($andelseddanamn > $andelar) {
	print "$andelar\t$seddaolikanamn\t$andelseddaolikanamn\n";
	$andelar += 1/$segment;
    }
}
#for ($aa = $andelar; $aa <= 1; $aa += 1/$segment) {
#    print "$aa\t$seddaolikanamn\n";
#}
print "1.0\t$seddaolikanamn\t$andelseddaolikanamn\n";
print STDERR "antal namn:\t$antalnamn\n";
print STDERR "antal olika namn:\t$antalolikanamn\n";
print STDERR "antal namn med frekvens > $threshold\t$antalfiltreradenamn\n";
print STDERR "antal olika namn med frekvens > $threshold\t$antalolikafiltreradenamn\n";
print STDERR "namn med frekvens=$threshold\t$filterfrekvensnamn\n";
print STDERR "hapax:\t$hapax\n";
#==========================================================================
exit;

