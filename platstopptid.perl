
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
#Aadil		M	2013	Husby-ärl.	Sigtuna	Sigtuna	n1

open HH,"<ortlandsdel.lista";
while(<HH>) {
    @hh = split;
    $landsdel{$hh[0]} = $hh[1];
}
close HH;
$baratilltal = 0;
$threshold = 100;
$kthreshold = 5;
$ticker = 0;
$tocker = 0;
while (<>) {
    $ticker++;
    $tocker++;
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    next if $fodar < 1920;
    next if $baratilltal && $tilltal ne "J";
    #    $aar{$fodar}++;
    $fort{$fodelseort}++;
    $bort{$bostadsort}++;
    $frekv{$namn} += $antal;
#    $fodd{$fodar}{$namn} += $antal;
#    $decennium = int($fodar/10) * 10;
#    $decennielista{$decennium}++;
#    $foddd{$namn}{$decennium} += $antal;
    $foddplats{$fodelseort}{$namn} += $antal;
    $foddlandsdel{$landsdel{$fodelseort}}{$namn} += $antal;
    $landsdelar{$landsdel{$fodelseort}}++;
    $fodda{$landsdel{$fodelseort}} += $antal;
    $fodda{$fodelseort} += $antal;
    $boplats{$bostadsort}{$namn} += $antal;
    $boende{$bostadsort} += $antal;
    $stann{$namn} += $antal if $fodelseort eq $bostadsort;
    $stannlandsdel{$namn} += $antal if $landsdel{$fodelseort} eq $landsdel{$bostadsort};
    $pop += $antal;
    if ($ticker > 10000) {print "$tocker\n"; $ticker = 0;}
}

$yates = 0.5; # yates correction for 2x2 tables
for $namn (keys %frekv) {
    next unless $frekv{$namn} > $threshold;
    $max = 0;
    $maxort = "";
    $maxX2 = 0;
    $maxX2ort = "";
    $maxL = 0;
    $maxlandsdel = "";
    $maxX2L = 0;
    $maxX2landsdel = "";
    $topp = 0;
    $toppL = 0;
    for $ort (sort keys %fort) {
	next unless $ort;
	$t11 = $foddplats{$ort}{$namn};
	$t12 = $frekv{$namn} - $foddplats{$ort}{$namn};
	$t1x = $frekv{$namn};
	$t21 = $fodda{$ort} - $foddplats{$ort}{$namn};
	$t22 = $pop - $fodda{$ort} - $frekv{$namn} + $foddplats{$ort}{$namn};
	$t2x = $pop - $frekv{$namn};
	$tx1 = $fodda{$ort};
	$tx2 = $pop - $fodda{$ort};
	if ($t11 > $kthreshold && $t21 > $kthreshold) {
	$e11 = $t1x * $tx1/$pop;
	$e12 = $t1x * $tx2/$pop;
	$e21 = $t2x * $tx1/$pop;
	$e22 = $t2x * $tx2/$pop;
	$khi2 = (abs($t11-$e11) - $yates)**2/$e11 +
	    (abs($t12-$e12) - $yates)**2/$e12 +
	    (abs($t21-$e21) - $yates)**2/$e21 +
	    (abs($t22-$e22) - $yates)**2/$e22;
#	if ($namn eq "Ada") {print ">> $ort $khi2\n";
#			     print ">> $t11-$e11\t$t12-$e12\t$t1x\n";
#			     print ">> $t21-$e21\t$t22-$e22\t$t2x\n";
#			     print ">> $tx1\t$tx2\t$pop\n";}
	if ($khi2 > $maxX2) {$maxX2 = $khi2; $maxX2ort = $ort;}
	}
	if ($foddplats{$ort}{$namn} > $max) {$max = $foddplats{$ort}{$namn}; $maxort = $ort;}
    }
    for $landsdel (sort keys %landsdelar) {
	next unless $landsdel;
	if ($foddlandsdel{$landsdel}{$namn} > $maxL) {$maxL = $foddplats{$landsdel}{$namn}; $maxlandsdel = $landsdel;}
	$t11 = $foddlandsdel{$landsdel}{$namn};
	$t12 = $frekv{$namn} - $foddlandsdel{$landsdel}{$namn};
	$t1x = $frekv{$namn};
	$t21 = $fodda{$landsdel} - $foddlandsdel{$landsdel}{$namn};
	$t22 = $pop - $fodda{$landsdel} - $frekv{$namn} + $foddlandsdel{$landsdel}{$namn};
	$t2x = $pop - $frekv{$namn};
	$tx1 = $fodda{$landsdel};
	$tx2 = $pop - $fodda{$landsdel};
	$e11 = $t1x * $tx1/$pop;
	$e12 = $t1x * $tx2/$pop;
	$e21 = $t2x * $tx1/$pop;
	$e22 = $t2x * $tx2/$pop;
	$khi2 = (abs($t11-$e11) - $yates)**2/$e11 +
	    (abs($t12-$e12) - $yates)**2/$e12 +
	    (abs($t21-$e21) - $yates)**2/$e21 +
	    (abs($t22-$e22) - $yates)**2/$e22;
	if ($khi2 > $maxX2L) {$maxX2L = $khi2; $maxX2landsdel = $landsdel;}
    }
    $topp = int($max/$frekv{$namn}*1000)/1000;
    $toppL = int($maxL/$frekv{$namn}*1000)/1000;
    $toppX2 = int($foddplats{$maxX2ort}{$namn}/$frekv{$namn}*1000)/1000;
    $toppX2L = int($foddlandsdel{$maxX2landsdel}{$namn}/$frekv{$namn}*1000)/1000;
    $ss = int($stann{$namn}/$frekv{$namn}*1000)/1000;
    $sl = int($stannlandsdel{$namn}/$frekv{$namn}*1000)/1000;
    print "$namn\t$frekv{$namn}\t";
    print "$topp\t$maxort\t|\t$maxX2\t$foddplats{$maxX2ort}{$namn}\t$toppX2\t$maxX2ort\t||\t";
    print "$toppL\t$maxL\t$maxlandsdel\t|\t$maxX2L\t$foddlandsdel{$maxX2landsdel}{$namn}\t$toppX2L\t$maxX2landsdel\t||\t";
    print "$ss\t$sl";
    print "\n";
}

