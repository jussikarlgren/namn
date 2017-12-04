
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

while (<>) {
($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
$frekv{$namn} += $antal;
$frekvtilltal{$namn} += $antal if $tilltal eq "J";
$fodd{$fodar}{$namn} += $antal;
$foddt{$fodar}{$namn} += $antal if  $tilltal eq "J";
$decennium = int($fodar/10) * 10;
$decennielista{$decennium}++;
$foddd{$namn}{$decennium} += $antal;
$fodddt{$namn}{$decennium} += $antal if  $tilltal eq "J";
$stann{$namn} += $antal if $fodelseort eq $bostadsort;
$stannt{$namn} += $antal if ($tilltal eq "J" && $fodelseort eq $bostadsort);
$stannd{$namn}{$decennium} += $antal if $fodelseort eq $bostadsort;
$stanntd{$namn}{$decennium} += $antal if ($tilltal eq "J" && $fodelseort eq $bostadsort);
}

for $namn (keys %foddd) {
    if ($frekv{$namn} == 0) {
	$frekv{$namn} = 1;}
$max = 0;
$maxy = 0;
$median = 0;
$sdev = 0;
$mean = 0;
$sum = 0;
$dev = 0;
$min = $frekv{$namn};
$miny = 0;
$statstring = "";
$n = 0;
#    for $y (sort keys %{ $foddd{$namn} } ) {
for $y (sort keys %decennielista) {
    $n++;
    $foddd{$namn}{$y} == 0 unless $foddd{$namn}{$y};
    if ($foddd{$namn}{$y} < $min) {$min = $foddd{$namn}{$y}; $miny = $y}
    if ($foddd{$namn}{$y} == 0) {
	$stannqd = 0; 
    } else {
	if ($foddd{$namn}{$y} > $max) {$max = $foddd{$namn}{$y}; $maxy = $y;}
	$sum += $foddd{$namn}{$y};
	  $stannqd = $stannd{$namn}{$y} / $foddd{$namn}{$y};
      }
      $statstring .= "$y:$foddd{$namn}{$y}	";
}
    $mean = $sum/$n;
#    for $y (keys %{ $foddd{$namn} } ) {
    for $y (sort keys %decennielista) {
	$dev += ($foddd{$namn}{$y}-$mean)*($foddd{$namn}{$y}-$mean);
    }
    $sdev = sqrt($dev/$n);
    $stannq = $stann{$namn}/$frekv{$namn};
#    print "$namn\t$frekv{$namn}\t$mean\t$sdev\t$maxy\t($max)\t$miny\t($min)\t$stannq\n";
    print "$namn\t$frekv{$namn}\t$stannq\t$mean\t$sdev\t$statstring\n" if $frekv{$namn} > $threshold;
}

# stannar folk olika mkt i olika delar av landet, stannar popnman mer el mindre, stannar olika decennier olika för ett namn




#    print "$k\t$frekv{$k}\t$frekvtilltal{$k}\t".int($fodd{$k}/$frekv{$k})."\t".int($foddt{$k}/$frekvtilltal{$k})."\t".$stann{$k}/$frekv{$k}."\t".$stannt{$k}/$frekvtilltal{$k}."\n"; # if $frekv{$k} > 10000;
#    print "$y\t$n\t$foddd{$y}{$n}\t$foddt{$y}{$n}\t$frekv{$n}\n";
