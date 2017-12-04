
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
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
    $aar{$fodar}++;
    $frekv{$namn} += $antal;
    $frekvtilltal{$namn} += $antal if $tilltal eq "J";
    $fodd{$fodar}{$namn} += $antal;
    $foddt{$fodar}{$namn} += $antal if  $tilltal eq "J";
    $decennium = int($fodar/10) * 10;
    $decennielista{$decennium}++;
    $foddd{$namn}{$decennium} += $antal;
    $fodddt{$namn}{$decennium} += $antal if $tilltal eq "J";
    $stann{$namn} += $antal if $fodelseort eq $bostadsort;
    $stannt{$namn} += $antal if ($tilltal eq "J" && $fodelseort eq $bostadsort);
    $stannd{$namn}{$decennium} += $antal if $fodelseort eq $bostadsort;
    $stanntd{$namn}{$decennium} += $antal if ($tilltal eq "J" && $fodelseort eq $bostadsort);
}

for $namn (keys %frekv) {
    next unless $frekv{$namn} > $threshold;
#   if ($frekv{$namn} == 0) {$frekv{$namn} = 1;}
    $max = 0;
    $maxy = 0;
    $median = 0;
    $sdev = 0;
    $mean = 0;
    $sum = 0;
    $sumsqdev = 0;
    $min = $frekv{$namn};
    $miny = 0;
    undef %decenniumscore;
    $n = 0;
    $topp = 0;
    #init roller --> @roller = {0,0,0};  
    for ($kk=0;$kk<$window;$kk++) {$roller[$kk]=0;} 
    for $y (sort keys %aar) {
	$thisdecennium = int($y/10) * 10;
	$n++;
	$this = $fodd{$y}{$namn}; # $foddd{$y}{$namn};
	$this = 0 unless $this;
	$decenniumscore{$thisdecennium} += $this;
	push @roller, $this;
	shift @roller;
	$now = 0;
	for $yy (@roller) { $now += $yy; }
	if ($now > $max) {$max = $now; $maxy = $y; $maxd = $thisdecennium;}
	$sum += $this;
#	print "$y $sum $max     $now = "; 	for $yy (@roller) {print "$yy + ";} print "\n";
#	$mean = $sum/$n;
#	$sumsqdev += ($this-$mean)*($this-$mean);
#	$sdev = sqrt($sumsqdev/$n);
    }
    $topp = int($max/$sum*100)/100;
    $toppY = $topp/$window;
    print "$namn\t$frekv{$namn}\t$topp\t$toppY\t$maxy\t$maxd\t";
    for $kk (sort keys %decennielista) {
	print "$decenniumscore{$kk}\t";
    }
    print "\n";
}

