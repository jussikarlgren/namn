use Getopt::Std;
$threshold = 100;
$window = 1;
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

open HH,"<data/ortlandsdel.lista";
while(<HH>) {
    chomp;
    @hh = split "\t";
    $landsdel{$hh[0]} = $hh[2];
    $region{$hh[0]} = $hh[1];
}
close HH;
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
    $fodelseorter{$fodelseort}++;
    $landsdelar{$landsdel{$fodelseort}}++;
    $fodelseortaar{$fodelseort}{$fodar}{$namn} += $antal;
    $fodelselandsdelaar{$landsdel{$fodelseort}}{$fodar}{$namn} += $antal;
    $frekvfodelseort{$fodelseort}{$namn} += $antal;
    $frekvfodelselandsdel{$landsdel{$fodelseort}}{$namn} += $antal;
    print unless $landsdel{$fodelseort};
    print ">>$fodelseort<<\n" unless $landsdel{$fodelseort};

    
#-------chk below for necessity
#    $foddd{$namn}{$decennium} += $antal;
#    $bort{$bostadsort}++;
#    $fodda{$landsdel{$fodelseort}} += $antal;
#    $fodda{$fodelseort} += $antal;
#    $boplats{$bostadsort}{$namn} += $antal;
#    $boende{$bostadsort} += $antal;
#    $stann{$namn} += $antal if $fodelseort eq $bostadsort;
#    $stannlandsdel{$namn} += $antal if $landsdel{$fodelseort} eq $landsdel{$bostadsort};
#    $stannd{$namn}{$decennium} += $antal if $fodelseort eq $bostadsort;
#    $pop += $antal;
}
#==========================================================================
# FILTRERA PÅ FREKVENS
# men spara basdata för jämförelse och utmatning på slutet för säkerhets skull
$antalolikafiltreradenamn = 0;
for $namn (keys %frekv) {
    if ($frekv{$namn} < $threshold) {delete $frekv{$namn}; next;}
    $antalolikafiltreradenamn++;
}
#==========================================================================
for $namn (keys %frekv) {
    for $ll (sort keys %landsdelar) { #ll
	$max = 0;
	$maxyear = 0;
	$maxdecennium = 0;
	$median = 0;
	$sum = 0;
	undef %decenniumscore;
	$n = 0;
	$topp = 0;
	#init roller --> @roller = {0,0,0};  
	for ($kk=0;$kk<$window;$kk++) {$roller[$kk]=0;} 
	for $y (sort keys %aar) {
	    $thisdecennium = int($y/10) * 10;
	    $n++;
	    $this = $fodelselandsdelaar{$ll}{$y}{$namn}; #ll
	    $this = 0 unless $this;
	    $decenniumscore{$thisdecennium} += $this;
	    push @roller, $this;
	    shift @roller;
	    $now = 0;
	    for $yy (@roller) { $now += $yy; }
	    if ($now > $max) {$max = $now; $maxyear = $y; $maxdecennium = $thisdecennium;}
	    $sum += $this;
	}
	$topp = int($max/$sum*100)/100;
	$toppY = $topp/$window;
	print "$namn\t$ll\t$frekvfodelselandsdel{$ll}{$namn}\t$topp\t$toppY\t$maxyear\t$maxdecennium\t"; #ll
	for $kk (sort keys %decennielista) {
	    print "$kk:$decenniumscore{$kk}\t";
	}
	print "\n";
    } #ll
}


exit();
#==========================================================================
$kthreshold = 5;
$yates = 0.5; # yates correction for 2x2 tables
#==========================================================================
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
	if ($foddlandsdel{$landsdel}{$namn} > $maxL) {$maxL = $foddlandsdel{$landsdel}{$namn}; $maxlandsdel = $landsdel;}
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

