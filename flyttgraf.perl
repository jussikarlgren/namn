#Aabraham		M	1991	Flemingsberg	Huddinge	Stockholm	1
#Aaby	N	M	1969	Växjö	Växjö	Västervik	1
#Aada-Elina	J	K	2004	Nedert.-hap	Haparanda	Haparanda	1
open HH,"<hierarki.lista";
while(<HH>) {
    @hh = split;
    $upp1{$hh[0]} = $hh[1];
    $upp2{$hh[0]} = $hh[2];
    $upp3{$hh[0]} = $hh[3];
    $upp4{$hh[0]} = $hh[4];
    $upp5{$hh[0]} = $hh[5];
}
close HH;

while (<>) {
($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
next if $tilltal eq "N";
$ort{$fodelseort}++;
#$ort1{$upp1{$fodelseort}}++;
#$ort2{$upp2{$fodelseort}}++;
#$ort3{$upp3{$fodelseort}}++;
$ort4{$upp4{$fodelseort}}++;
$ort5{$upp5{$fodelseort}}++;
#$flytt{$fodelseort}{$bostadsort}++;
$flyttupp{$fodelseort}{$upp4{$bostadsort}}++;
$flytt1{$upp1{$fodelseort}}{$upp1{$bostadsort}}++;
$flytt2{$upp2{$fodelseort}}{$upp2{$bostadsort}}++;
$flytt3{$upp3{$fodelseort}}{$upp3{$bostadsort}}++;
$flytt4{$upp4{$fodelseort}}{$upp4{$bostadsort}}++;
$flytt5{$upp5{$fodelseort}}{$upp5{$bostadsort}}++;
}

print "========================\n";
for $ortnamn (keys %ort) {
    next unless $ortnamn;
    for $till (keys %{ $flyttupp{$ortnamn} }) {
    next unless $till;
	print "$ortnamn\t$till\t$flyttupp{$ortnamn}{$till}\t".$flyttupp{$ortnamn}{$till}/$ort{$ortnamn}."\t$ortupp{$ortnamn}\n";
    }
}
print "========================\n";
for $ortnamn (keys %ort2) {
    next unless $ortnamn;
for $till (keys %{ $flytt2{$ortnamn} }) {
    next unless $till;
	print "$ortnamn\t$till\t$flytt2{$ortnamn}{$till}\t".$flytt2{$ortnamn}{$till}/$ort2{$ortnamn}."\t$ort2{$ortnamn}\n";
    }
}
