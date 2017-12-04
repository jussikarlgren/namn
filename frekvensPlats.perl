
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


$threshold = 100;

while (<>) {
($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
$frekv{$namn} += $antal;
$frekvtilltal{$namn} += $antal if $tilltal eq "J";
$fodd{$fodar}{$namn} += $antal;
$foddt{$fodar}{$namn} += $antal if  $tilltal eq "J";
$stann{$namn} += $antal if $fodelseort eq $bostadsort;
$stann1{$namn} += $antal if $upp1{$fodelseort} eq $upp1{$bostadsort};
$stann2{$namn} += $antal if $upp2{$fodelseort} eq $upp2{$bostadsort};
$stann3{$namn} += $antal if $upp3{$fodelseort} eq $upp3{$bostadsort};
$stann4{$namn} += $antal if $upp4{$fodelseort} eq $upp4{$bostadsort};
$stann5{$namn} += $antal if $upp5{$fodelseort} eq $upp5{$bostadsort};
$stannt{$namn} += $antal if ($tilltal eq "J" && $fodelseort eq $bostadsort);
}

for $namn (keys %frekv) {
    if ($frekv{$namn} == 0) {
	$frekv{$namn} = 1;}
    if ($frekvtilltal{$namn} == 0) {
	$frekvtilltal{$namn} = 1;}
    $stannt = $stannt{$namn}/$frekvtilltal{$namn};
    $stannq = $stann{$namn}/$frekv{$namn};
    $stannq1 = $stann1{$namn}/$frekv{$namn};
    $stannq2 = $stann2{$namn}/$frekv{$namn};
    $stannq3 = $stann3{$namn}/$frekv{$namn};
    $stannq4 = $stann4{$namn}/$frekv{$namn};
    $stannq5 = $stann5{$namn}/$frekv{$namn};
    $tilt = $frekvtilltal{$namn}/$frekv{$namn};
    print "$namn\t$frekv{$namn}\t$tilt\t$stannt\t$stannq\t$stannq1\t$stannq2\t$stannq3\t$stannq4\t$stannq5\n" if $frekv{$namn} > $threshold;
}

# stannar folk olika mkt i olika delar av landet, stannar popnman mer el mindre, stannar olika decennier olika för ett namn




#    print "$k\t$frekv{$k}\t$frekvtilltal{$k}\t".int($fodd{$k}/$frekv{$k})."\t".int($foddt{$k}/$frekvtilltal{$k})."\t".$stann{$k}/$frekv{$k}."\t".$stannt{$k}/$frekvtilltal{$k}."\n"; # if $frekv{$k} > 10000;
#    print "$y\t$n\t$foddd{$y}{$n}\t$foddt{$y}{$n}\t$frekv{$n}\n";
