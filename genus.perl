$listoutput=0;
$threshold = 0;
$minimum = 0.05;
while (<>) {
    ($namn,$tilltal,$kon,$fodar,$fodelseforsamling,$fodelseort,$bostadsort,$antal) = split "\t";
    $man{$namn}++ if $kon eq "M";
    $kvinna{$namn}++ if $kon eq "K";
    $freq{$namn}++;
    if ($tilltal eq "J") {
	$manT{$namn}++ if $kon eq "M";
	$kvinnaT{$namn}++ if $kon eq "K";
	$freqT{$namn}++;
    }
}
$antal=0;
$antalfiltrerade=0;
$kvi=0;$man=0;$ambi=0;
for $namn (keys %freq) {
    $kvot = 0;
    $kvotT = 0;
    $antal++;
    next if $freq{$namn} < $threshold;
    $antalfiltrerade++;
    $kvot = int($kvinna{$namn}/($kvinna{$namn}+$man{$namn})*1000)/1000 if ($man{$namn} && $kvinna{$namn});
    if ($kvot < $minimum || $kvot > 1 - $minimum) {$kvot = 0;}
    if ($kvot) {
	$amb++; $ambf += $freq{$namn};
    } else {
	if ($kvinna{$namn} > $man{$namn}) {$kvi++;     $kvif += $freq{$namn}; }
	elsif ($man{$namn} > $kvinna{$namn}) {$man++;     $manf += $freq{$namn}; }
    }

    $kvotT = int($kvinnaT{$namn}/($kvinnaT{$namn}+$manT{$namn})*1000)/1000 if ($manT{$namn} && $kvinnaT{$namn});
    if ($kvotT < $minimum || $kvotT > 1 - $minimum) {$kvotT = 0;}
    if ($kvotT) {
	$ambT++; $ambfT += $freqT{$namn};
    } else {
	if ($kvinnaT{$namn} > $manT{$namn}) {$kviT++;     $kvifT += $freq{$namn};}
	elsif ($manT{$namn} > $kvinnaT{$namn}) {$manT++;  $manfT += $freq{$namn};}
    }
    
    $diffTp++ if $kvot > $kvotT;
    $diffTn++ if $kvot < $kvotT;
    
    if ($listoutput) {
	print "$namn\t$kvot\t$freq{$namn}\t$kvinna{$namn}\t$man{$namn}\t$kvotT\t$freqT{$namn}\t$kvinnaT{$namn}\t$manT{$namn}\n" if $kvotT; #($kvot || $kvotT);
    }
}
print "$threshold\t$minimum\n";
print "antal namn:\t$antal\n";
print "antal efter frekvensfiltrering:\t$antalfiltrerade\n";
print "\tkv\tman\tambi\n";
print "alla\t$kvi\t$man\t$amb\n";
print "frekv\t$kvif\t$manf\t$ambf\n";
print "tilltal\t$kviT\t$manT\t$ambT\n";
print "frekv\t$kvifT\t$manfT\t$ambfT\n";
print "antal namn som oftare är ambi om de är andranamn: $diffTp\n";
print "antal namn som oftare är ambi om de är tilltalsnamn: $diffTn\n";
